<#
.SYNOPSIS
    Merges tracked Windows Terminal settings into the live settings.json.

.DESCRIPTION
    Run this from the Windows Terminal LocalState directory after
    DeploySettings.ps1 has been run and Terminal has regenerated
    settings.json.

    Merge rules:
      - Top-level keys (theme, initialRows, rendering options, etc.):
            tracked file wins; live keys not in tracked are preserved
      - profiles.defaults:
            replaced wholesale from tracked file
      - profiles.list:
            profiles named in changes.json (marked "managed") are upserted
            by name from the tracked file; all other profiles (auto-detected
            VS dev prompts, WSL distros, etc.) are left untouched.
            The list is then reordered to match the "profile" entries in
            newTabMenu (by name or guid, searching folders too); profiles
            not named there keep their relative order after them. This
            keeps the OpenNewTabProfileN keybindings — which index into
            visible profiles in list order — in step with the menu
      - schemes:
            merged by name — add or update, never remove
      - actions / keybindings:
            replaced wholesale from tracked file
      - $schema:
            always taken from tracked file

    Post-merge fixups are driven by changes.json:
      - getCommand: resolves executable path via Get-Command; on failure,
            sets hidden=true for that profile
      - Any other non-directive key: added or replaced in the profile
      - managed: marks profile for upsert from tracked settings
      - default: an integer priority (lower = preferred) marking this profile
            as a defaultProfile candidate. After fixups run, candidates are
            tried in ascending priority order and the first one that exists
            in the merged profile list becomes the defaultProfile. This lets
            a profile that depends on optional software (e.g. a Visual Studio
            dev prompt) be preferred without breaking the default when that
            software isn't installed. If the chosen candidate ended up
            hidden (explicitly, or via a failed getCommand), it is un-hidden
            — a profile can't be both the default and hidden from the UI.

.PARAMETER TrackedSettingsPath
    Path to the tracked settings file.
    Default: settings.tracked.json in the same directory as this script.

.PARAMETER LiveSettingsPath
    Path to the live settings.json.
    Default: settings.json in the same directory as this script.

.PARAMETER ChangesPath
    Path to the changes.json file.
    Default: changes.json in the same directory as this script.

.PARAMETER WhatIf
    Show what would change without writing anything.

.EXAMPLE
    .\MergeSettings.ps1

.EXAMPLE
    .\MergeSettings.ps1 -WhatIf
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [string] $TrackedSettingsPath = (Join-Path $PSScriptRoot 'settings.tracked.json'),
    [string] $LiveSettingsPath    = (Join-Path $PSScriptRoot 'settings.json'),
    [string] $ChangesPath         = (Join-Path $PSScriptRoot 'changes.json')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ---------------------------------------------------------------------------
# Keys that are directives in changes.json — not passed through to profiles
# ---------------------------------------------------------------------------

$directiveKeys = @('name', 'managed', 'default', 'getCommand')

# ---------------------------------------------------------------------------
# Keys replaced wholesale from tracked file
# ---------------------------------------------------------------------------

$wholesaleKeys = @(
    '$schema'
    '$help'
    'actions'
    'keybindings'
)

# ---------------------------------------------------------------------------
# Top-level keys handled separately (not subject to simple wholesale replace)
# ---------------------------------------------------------------------------

$topLevelSkip = @(
    'profiles'
    'schemes'
    'actions'
    'keybindings'
    'defaultProfile'  # resolved by name after merge
)

# ---------------------------------------------------------------------------
# Helper: deep-clone a hashtable
# ---------------------------------------------------------------------------

function Copy-Hashtable([hashtable] $ht) {
    $copy = @{}
    foreach ($key in $ht.Keys) {
        $val = $ht[$key]
        if ($val -is [hashtable]) {
            $copy[$key] = Copy-Hashtable $val
        } elseif ($val -is [System.Collections.IList]) {
            $copy[$key] = [System.Collections.Generic.List[object]]::new($val)
        } else {
            $copy[$key] = $val
        }
    }
    return $copy
}

# ---------------------------------------------------------------------------
# Helper: get a value from a profile regardless of whether it is a hashtable
# or a PSCustomObject (ConvertFrom-Json without -AsHashtable returns the
# latter for nested objects)
# ---------------------------------------------------------------------------

function Get-ProfileValue($profile, [string] $key) {
    if ($profile -is [hashtable]) { return $profile[$key] }
    return $profile.$key
}

function Set-ProfileValue($profile, [string] $key, $value) {
    if ($profile -is [hashtable]) { $profile[$key] = $value }
    else { $profile.$key = $value }
}

# ---------------------------------------------------------------------------
# Load files
# ---------------------------------------------------------------------------

if (-not (Test-Path $TrackedSettingsPath)) {
    Write-Error "Tracked settings file not found: $TrackedSettingsPath"
    exit 1
}
if (-not (Test-Path $LiveSettingsPath)) {
    Write-Error "Live settings.json not found: $LiveSettingsPath"
    exit 1
}
if (-not (Test-Path $ChangesPath)) {
    Write-Error "Changes file not found: $ChangesPath"
    exit 1
}

Write-Host "Tracked : $TrackedSettingsPath"
Write-Host "Live    : $LiveSettingsPath"
Write-Host "Changes : $ChangesPath"
Write-Host ''

$tracked = Get-Content $TrackedSettingsPath -Raw -Encoding UTF8 | ConvertFrom-Json -AsHashtable
$live    = Get-Content $LiveSettingsPath    -Raw -Encoding UTF8 | ConvertFrom-Json -AsHashtable
$changes = Get-Content $ChangesPath         -Raw -Encoding UTF8 | ConvertFrom-Json  # array of objects

# ---------------------------------------------------------------------------
# First pass through changes.json — collect managed profiles and default
# candidates (name + priority)
# ---------------------------------------------------------------------------

$ManagedProfiles   = [System.Collections.Generic.List[string]]::new()
$DefaultCandidates = [System.Collections.Generic.List[object]]::new()

foreach ($entry in $changes) {
    $entryName = $entry.name
    if (-not $entryName) {
        Write-Warning "changes.json entry missing 'name' — skipping"
        continue
    }

    # 'managed' key presence (any value) marks this as a managed profile
    if ($null -ne $entry.PSObject.Properties['managed']) {
        $ManagedProfiles.Add($entryName)
        Write-Verbose "Managed profile from changes.json: $entryName"
    }

    # 'default' key is an integer priority (lower = preferred) marking this
    # profile as a defaultProfile candidate
    $defaultProp = $entry.PSObject.Properties['default']
    if ($null -ne $defaultProp) {
        $DefaultCandidates.Add([pscustomobject]@{ Name = $entryName; Priority = [int] $defaultProp.Value })
        Write-Verbose "Default candidate from changes.json: $entryName (priority $($defaultProp.Value))"
    }
}

if ($DefaultCandidates.Count -eq 0) {
    Write-Warning "No default profile candidates specified in changes.json — defaultProfile will not be updated"
}

# ---------------------------------------------------------------------------
# Start building result from live settings
# ---------------------------------------------------------------------------

$result = Copy-Hashtable $live

# ---------------------------------------------------------------------------
# Wholesale keys
# ---------------------------------------------------------------------------

foreach ($key in $wholesaleKeys) {
    if ($tracked.ContainsKey($key)) {
        Write-Verbose "Wholesale replace: $key"
        $result[$key] = $tracked[$key]
    }
}

# ---------------------------------------------------------------------------
# Top-level scalar / object keys — tracked wins
# ---------------------------------------------------------------------------

foreach ($key in $tracked.Keys) {
    if ($key -in $topLevelSkip) { continue }
    if ($key -in $wholesaleKeys) { continue }
    Write-Verbose "Top-level merge: $key"
    $result[$key] = $tracked[$key]
}

# ---------------------------------------------------------------------------
# profiles.defaults — wholesale replace from tracked
# ---------------------------------------------------------------------------

if ($tracked.ContainsKey('profiles') -and $tracked['profiles'] -is [hashtable]) {
    $trackedProfiles = $tracked['profiles']

    if (-not $result.ContainsKey('profiles')) { $result['profiles'] = @{} }
    if ($result['profiles'] -isnot [hashtable]) { $result['profiles'] = @{} }

    if ($trackedProfiles.ContainsKey('defaults')) {
        Write-Verbose "Replacing profiles.defaults"
        $result['profiles']['defaults'] = $trackedProfiles['defaults']
    }

    # -----------------------------------------------------------------------
    # profiles.list — upsert managed profiles by name only
    # -----------------------------------------------------------------------

    $liveList = [System.Collections.Generic.List[object]]::new()
    if ($result['profiles'].ContainsKey('list') -and $result['profiles']['list']) {
        foreach ($p in $result['profiles']['list']) { $liveList.Add($p) }
    }

    # Build name -> index map of live profiles
    $liveByName = @{}
    for ($i = 0; $i -lt $liveList.Count; $i++) {
        $name = Get-ProfileValue $liveList[$i] 'name'
        if ($name) { $liveByName[$name.ToLower()] = $i }
    }

    # Build name -> profile map of tracked profiles
    $trackedByName = @{}
    if ($trackedProfiles.ContainsKey('list') -and $trackedProfiles['list']) {
        foreach ($p in $trackedProfiles['list']) {
            $name = Get-ProfileValue $p 'name'
            if ($name) { $trackedByName[$name.ToLower()] = $p }
        }
    }

    foreach ($profileName in $ManagedProfiles) {
        $key = $profileName.ToLower()

        if (-not $trackedByName.ContainsKey($key)) {
            Write-Warning "Managed profile '$profileName' not found in tracked settings — skipping"
            continue
        }

        $trackedProfile = $trackedByName[$key]

        if ($liveByName.ContainsKey($key)) {
            Write-Verbose "Updating profile: $profileName"
            $liveList[$liveByName[$key]] = $trackedProfile
        } else {
            Write-Verbose "Adding profile: $profileName"
            $liveList.Add($trackedProfile)
        }
    }

    $result['profiles']['list'] = $liveList
}

# ---------------------------------------------------------------------------
# profiles.list — reorder to match newTabMenu
# ---------------------------------------------------------------------------

# Collect "profile" entry references (name or guid) in menu order, recursing
# into folders
function Get-MenuProfileRefs($entries) {
    foreach ($entry in $entries) {
        $type = Get-ProfileValue $entry 'type'
        if ($type -eq 'profile') {
            $ref = Get-ProfileValue $entry 'profile'
            if ($ref) { $ref }
        } elseif ($type -eq 'folder') {
            $children = Get-ProfileValue $entry 'entries'
            if ($children) { Get-MenuProfileRefs $children }
        }
    }
}

if ($result.ContainsKey('newTabMenu') -and $result['newTabMenu'] -and
    $result.ContainsKey('profiles') -and $result['profiles'] -is [hashtable] -and
    $result['profiles']['list']) {

    $unsorted = [System.Collections.Generic.List[object]]::new()
    foreach ($p in $result['profiles']['list']) { $unsorted.Add($p) }
    $sorted = [System.Collections.Generic.List[object]]::new()

    foreach ($ref in @(Get-MenuProfileRefs $result['newTabMenu'])) {
        $refKey = $ref.ToLower()
        for ($i = 0; $i -lt $unsorted.Count; $i++) {
            $name = Get-ProfileValue $unsorted[$i] 'name'
            $guid = Get-ProfileValue $unsorted[$i] 'guid'
            if (($name -and $name.ToLower() -eq $refKey) -or
                ($guid -and $guid.ToLower() -eq $refKey)) {
                Write-Verbose "Menu order: $ref"
                $sorted.Add($unsorted[$i])
                $unsorted.RemoveAt($i)
                break
            }
        }
    }

    foreach ($p in $unsorted) { $sorted.Add($p) }
    $result['profiles']['list'] = $sorted
}

# ---------------------------------------------------------------------------
# schemes — merge by name (add/update, never remove)
# ---------------------------------------------------------------------------

if ($tracked.ContainsKey('schemes') -and $tracked['schemes']) {

    $liveSchemes = [System.Collections.Generic.List[object]]::new()
    if ($result.ContainsKey('schemes') -and $result['schemes']) {
        foreach ($s in $result['schemes']) { $liveSchemes.Add($s) }
    }

    $liveSchemesByName = @{}
    for ($i = 0; $i -lt $liveSchemes.Count; $i++) {
        $name = Get-ProfileValue $liveSchemes[$i] 'name'
        if ($name) { $liveSchemesByName[$name.ToLower()] = $i }
    }

    foreach ($scheme in $tracked['schemes']) {
        $name = Get-ProfileValue $scheme 'name'
        if (-not $name) { continue }

        $key = $name.ToLower()
        if ($liveSchemesByName.ContainsKey($key)) {
            Write-Verbose "Updating scheme: $name"
            $liveSchemes[$liveSchemesByName[$key]] = $scheme
        } else {
            Write-Verbose "Adding scheme: $name"
            $liveSchemes.Add($scheme)
        }
    }

    $result['schemes'] = $liveSchemes
}

# ---------------------------------------------------------------------------
# Second pass through changes.json — apply post-merge fixups
# ---------------------------------------------------------------------------

# Rebuild a name->index map of the final merged profile list for fixups
$mergedList = $result['profiles']['list']
$mergedByName = @{}
for ($i = 0; $i -lt $mergedList.Count; $i++) {
    $name = Get-ProfileValue $mergedList[$i] 'name'
    if ($name) { $mergedByName[$name.ToLower()] = $i }
}

foreach ($entry in $changes) {
    $entryName = $entry.name
    if (-not $entryName) { continue }

    $key = $entryName.ToLower()
    if (-not $mergedByName.ContainsKey($key)) {
        Write-Verbose "Fixup: profile '$entryName' not found in merged list — skipping"
        continue
    }

    $idx     = $mergedByName[$key]
    $profile = $mergedList[$idx]

    # getCommand directive
    $getCommandProp = $entry.PSObject.Properties['getCommand']
    if ($null -ne $getCommandProp) {
        $cmd = $getCommandProp.Value
        $resolved = Get-Command $cmd -ErrorAction SilentlyContinue
        if ($resolved) {
            $exePath = $resolved.Source
            Write-Verbose "Fixup '$entryName': resolved '$cmd' -> $exePath"
            Set-ProfileValue $profile 'commandline' $exePath
        } else {
            Write-Verbose "Fixup '$entryName': '$cmd' not found — setting hidden=true"
            Set-ProfileValue $profile 'hidden' $true
            # getCommand failure overrides pass-throughs; skip remainder of this entry
            continue
        }
    }

    # Pass-through keys
    foreach ($prop in $entry.PSObject.Properties) {
        if ($prop.Name -in $directiveKeys) { continue }
        Write-Verbose "Fixup '$entryName': $($prop.Name) = $($prop.Value)"
        Set-ProfileValue $profile $prop.Name $prop.Value
    }
}

# ---------------------------------------------------------------------------
# Resolve defaultProfile — try candidates in ascending priority order and use
# the first one that exists in the merged list. A profile can't be both the
# default and hidden, so if the chosen candidate is hidden (explicitly, or
# via a failed getCommand above), it is un-hidden.
# ---------------------------------------------------------------------------

$defaultGuid = $null
$resolvedDefaultName = $null
foreach ($candidate in ($DefaultCandidates | Sort-Object Priority)) {
    $key = $candidate.Name.ToLower()
    if (-not $mergedByName.ContainsKey($key)) {
        Write-Verbose "Default candidate '$($candidate.Name)' (priority $($candidate.Priority)) not in merged list — skipping"
        continue
    }

    $profile = $mergedList[$mergedByName[$key]]
    $defaultGuid = Get-ProfileValue $profile 'guid'
    $resolvedDefaultName = $candidate.Name

    if (Get-ProfileValue $profile 'hidden') {
        Write-Verbose "Default candidate '$($candidate.Name)' (priority $($candidate.Priority)) was hidden — un-hiding"
        Set-ProfileValue $profile 'hidden' $false
    }
    break
}

if ($defaultGuid) {
    Write-Verbose "Resolved defaultProfile '$resolvedDefaultName' -> $defaultGuid"
    $result['defaultProfile'] = $defaultGuid
} elseif ($DefaultCandidates.Count -gt 0) {
    Write-Warning "Could not resolve defaultProfile: no candidate from changes.json was found in the merged list"
}

# ---------------------------------------------------------------------------
# Serialize and write
# ---------------------------------------------------------------------------

$outputJson = $result | ConvertTo-Json -Depth 20

# Diff summary
$added   = [System.Collections.Generic.List[string]]::new()
$updated = [System.Collections.Generic.List[string]]::new()

$liveProfileNames = @{}
if ($live.ContainsKey('profiles') -and $live['profiles'] -is [hashtable] -and $live['profiles']['list']) {
    foreach ($p in $live['profiles']['list']) {
        $name = Get-ProfileValue $p 'name'
        if ($name) { $liveProfileNames[$name.ToLower()] = $true }
    }
}

foreach ($profileName in $ManagedProfiles) {
    if ($liveProfileNames.ContainsKey($profileName.ToLower())) {
        $updated.Add($profileName)
    } else {
        $added.Add($profileName)
    }
}

Write-Host "Managed profiles to add    : $(if ($added.Count)   { $added   -join ', ' } else { '(none)' })"
Write-Host "Managed profiles to update : $(if ($updated.Count) { $updated -join ', ' } else { '(none)' })"
Write-Host ''

if ($PSCmdlet.ShouldProcess($LiveSettingsPath, 'Write merged settings')) {

    $backupPath = "$LiveSettingsPath.bak"
    Copy-Item $LiveSettingsPath $backupPath -Force
    Write-Host "Backup : $backupPath"

    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllText($LiveSettingsPath, $outputJson, $utf8NoBom)

    Write-Host "Written: $LiveSettingsPath"
} else {
    Write-Host '[WhatIf] No files written.'
    Write-Host ''
    Write-Host '--- Output preview (first 40 lines) ---'
    $outputJson -split "`n" | Select-Object -First 40 | ForEach-Object { Write-Host $_ }
}
