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
            profiles named in $ManagedProfiles are upserted by name from the
            tracked file; all other profiles (auto-detected VS dev prompts,
            WSL distros, etc.) are left untouched
      - schemes:
            merged by name — add or update, never remove
      - actions / keybindings:
            replaced wholesale from tracked file
      - $schema:
            always taken from tracked file

.PARAMETER TrackedSettingsPath
    Path to the tracked settings file.
    Default: settings.tracked.json in the same directory as this script.

.PARAMETER LiveSettingsPath
    Path to the live settings.json.
    Default: settings.json in the same directory as this script.

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
    [string] $LiveSettingsPath    = (Join-Path $PSScriptRoot 'settings.json')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ---------------------------------------------------------------------------
# Managed profiles — upserted by name from the tracked file.
# Auto-detected profiles (VS dev prompts, WSL, etc.) are never touched.
# Add names here as needed.
# ---------------------------------------------------------------------------

$ManagedProfiles = @(
    'Neovim'
    'Vifm'
)

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
# Load both files
# ---------------------------------------------------------------------------

if (-not (Test-Path $TrackedSettingsPath)) {
    Write-Error "Tracked settings file not found: $TrackedSettingsPath"
    exit 1
}
if (-not (Test-Path $LiveSettingsPath)) {
    Write-Error "Live settings.json not found: $LiveSettingsPath"
    exit 1
}

Write-Host "Tracked : $TrackedSettingsPath"
Write-Host "Live    : $LiveSettingsPath"
Write-Host ''

$tracked = Get-Content $TrackedSettingsPath -Raw -Encoding UTF8 | ConvertFrom-Json -AsHashtable
$live    = Get-Content $LiveSettingsPath    -Raw -Encoding UTF8 | ConvertFrom-Json -AsHashtable

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
        $p    = $liveList[$i]
        $name = if ($p -is [hashtable]) { $p['name'] } else { $p.name }
        if ($name) { $liveByName[$name.ToLower()] = $i }
    }

    # Build name -> profile map of tracked profiles
    $trackedByName = @{}
    if ($trackedProfiles.ContainsKey('list') -and $trackedProfiles['list']) {
        foreach ($p in $trackedProfiles['list']) {
            $name = if ($p -is [hashtable]) { $p['name'] } else { $p.name }
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
# schemes — merge by name (add/update, never remove)
# ---------------------------------------------------------------------------

if ($tracked.ContainsKey('schemes') -and $tracked['schemes']) {

    $liveSchemes = [System.Collections.Generic.List[object]]::new()
    if ($result.ContainsKey('schemes') -and $result['schemes']) {
        foreach ($s in $result['schemes']) { $liveSchemes.Add($s) }
    }

    $liveSchemesByName = @{}
    for ($i = 0; $i -lt $liveSchemes.Count; $i++) {
        $s    = $liveSchemes[$i]
        $name = if ($s -is [hashtable]) { $s['name'] } else { $s.name }
        if ($name) { $liveSchemesByName[$name.ToLower()] = $i }
    }

    foreach ($scheme in $tracked['schemes']) {
        $name = if ($scheme -is [hashtable]) { $scheme['name'] } else { $scheme.name }
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
# Resolve defaultProfile by name
# ---------------------------------------------------------------------------

$DefaultProfileName = 'Developer PowerShell for VS 18'

$defaultGuid = $null
if ($result.ContainsKey('profiles') -and $result['profiles'] -is [hashtable] -and $result['profiles']['list']) {
    foreach ($p in $result['profiles']['list']) {
        $name = if ($p -is [hashtable]) { $p['name'] } else { $p.name }
        if ($name -and $name.ToLower() -eq $DefaultProfileName.ToLower()) {
            $defaultGuid = if ($p -is [hashtable]) { $p['guid'] } else { $p.guid }
            break
        }
    }
}

if ($defaultGuid) {
    Write-Verbose "Resolved defaultProfile '$DefaultProfileName' -> $defaultGuid"
    $result['defaultProfile'] = $defaultGuid
} else {
    Write-Warning "Could not resolve defaultProfile: no profile named '$DefaultProfileName' found in merged list"
}

# ---------------------------------------------------------------------------
# Serialize and write
# ---------------------------------------------------------------------------

$outputJson = $result | ConvertTo-Json -Depth 20

# Diff summary
$added = [System.Collections.Generic.List[string]]::new()
$updated = [System.Collections.Generic.List[string]]::new()

$liveProfileNames = @{}
if ($live.ContainsKey('profiles') -and $live['profiles'] -is [hashtable] -and $live['profiles']['list']) {
    foreach ($p in $live['profiles']['list']) {
        $name = if ($p -is [hashtable]) { $p['name'] } else { $p.name }
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
