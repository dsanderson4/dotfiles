# Mounts zip files as browsable folders under ~\ZipMount, backed by rclone's
# "archive" backend (read-only) and its rc daemon for mount management.
# Requires rclone and WinFsp (e.g. `choco install rclone winfsp`).

$script:ZipMountRoot = Join-Path $HOME 'ZipMount'
$script:ZipMountRcAddr = '127.0.0.1:5572'
$script:ZipMountRcUrl = "http://$script:ZipMountRcAddr/"
$script:ZipMountPidFile = Join-Path $script:ZipMountRoot '.daemon.pid'
$script:ZipMountCredFile = Join-Path $script:ZipMountRoot '.daemon.cred.json'
$script:ZipMountLogFile = Join-Path $script:ZipMountRoot '.daemon.log'
$script:ZipMountRemotePrefix = 'zipmount_'

function Test-ZipMountRcloneAvailable {
    if (-not (Get-Command rclone -ErrorAction SilentlyContinue)) {
        throw "rclone not found on PATH. Install it (and WinFsp, which it needs to mount on Windows), e.g. 'choco install rclone winfsp'."
    }
}

function ConvertTo-ZipMountSafeName {
    param([Parameter(Mandatory, Position = 0)][string]$Name)
    $invalidChars = [System.IO.Path]::GetInvalidFileNameChars()
    -join ($Name.ToCharArray() | ForEach-Object { if ($invalidChars -contains $_) { '_' } else { $_ } })
}

function Stop-ZipMountProcessTree {
    # The 'rclone' on PATH is often a Chocolatey shim that launches the real
    # rclone.exe as a child process, so stopping just the recorded PID leaves
    # the actual daemon running and orphaned.
    param([Parameter(Mandatory)][int]$ProcessId)

    Get-CimInstance Win32_Process -Filter "ParentProcessId=$ProcessId" -ErrorAction SilentlyContinue |
        ForEach-Object { Stop-ZipMountProcessTree -ProcessId $_.ProcessId }
    Stop-Process -Id $ProcessId -Force -ErrorAction SilentlyContinue
}

function Get-ZipMountDaemonProcess {
    if (-not (Test-Path $script:ZipMountPidFile)) { return $null }
    $procId = Get-Content -LiteralPath $script:ZipMountPidFile -ErrorAction SilentlyContinue
    if (-not $procId) { return $null }
    return Get-Process -Id $procId -ErrorAction SilentlyContinue
}

function Invoke-ZipMountRc {
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Command,
        [Parameter(Position = 1)]
        [string[]]$Params = @()
    )

    Test-ZipMountRcloneAvailable
    if (-not (Test-Path $script:ZipMountCredFile)) {
        throw "ZipMount daemon is not running. Run Start-ZipMountDaemon first."
    }
    $cred = Get-Content -LiteralPath $script:ZipMountCredFile -Raw | ConvertFrom-Json

    $output = & rclone rc --url $script:ZipMountRcUrl --user $cred.User --pass $cred.Pass $Command @Params 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "rclone rc $Command failed: $output"
    }
    if ([string]::IsNullOrWhiteSpace("$output")) { return $null }
    return $output | ConvertFrom-Json
}

function Start-ZipMountDaemon {
    [CmdletBinding()]
    param()

    Test-ZipMountRcloneAvailable

    if (Get-ZipMountDaemonProcess) {
        Write-Host "ZipMount daemon is already running."
        return
    }

    if (-not (Test-Path $script:ZipMountRoot)) {
        New-Item -ItemType Directory -Path $script:ZipMountRoot | Out-Null
    }

    $user = 'zipmount'
    $pass = [System.Guid]::NewGuid().ToString('N') + [System.Guid]::NewGuid().ToString('N')
    [PSCustomObject]@{ User = $user; Pass = $pass } |
        ConvertTo-Json | Set-Content -LiteralPath $script:ZipMountCredFile

    # The rc interface grants full filesystem/backend access to anyone who can
    # authenticate to it, so lock the credential file to the current user
    # rather than running with --rc-no-auth (see CVE-2026-41179).
    icacls $script:ZipMountCredFile /inheritance:r | Out-Null
    icacls $script:ZipMountCredFile /grant:r "$([Security.Principal.WindowsIdentity]::GetCurrent().Name):(R,W)" | Out-Null

    $proc = Start-Process -FilePath rclone `
        -ArgumentList @(
            'rcd',
            "--rc-addr=$script:ZipMountRcAddr",
            "--rc-user=$user",
            "--rc-pass=$pass"
        ) `
        -WindowStyle Hidden `
        -RedirectStandardOutput $script:ZipMountLogFile `
        -RedirectStandardError "$script:ZipMountLogFile.err" `
        -PassThru

    $proc.Id | Set-Content -LiteralPath $script:ZipMountPidFile

    Start-Sleep -Milliseconds 500
    Write-Host "ZipMount daemon started (PID $($proc.Id))."
}

function Stop-ZipMountDaemon {
    [CmdletBinding(SupportsShouldProcess)]
    param()

    $proc = Get-ZipMountDaemonProcess
    if (-not $proc) {
        Write-Host "ZipMount daemon is not running."
        Remove-Item $script:ZipMountPidFile, $script:ZipMountCredFile -ErrorAction SilentlyContinue
        return
    }

    if (-not $PSCmdlet.ShouldProcess('ZipMount daemon', 'Stop')) { return }

    try {
        Invoke-ZipMountRc 'mount/unmountall' | Out-Null
    } catch {
        Write-Warning "Failed to cleanly unmount active mounts: $_"
    }

    Stop-ZipMountProcessTree -ProcessId $proc.Id
    Remove-Item $script:ZipMountPidFile, $script:ZipMountCredFile -ErrorAction SilentlyContinue
    Write-Host "ZipMount daemon stopped."
}

function Get-ZipMount {
    [CmdletBinding()]
    param()

    if (-not (Get-ZipMountDaemonProcess)) {
        Write-Warning "ZipMount daemon is not running."
        return
    }

    $result = Invoke-ZipMountRc 'mount/listmounts'
    foreach ($m in $result.mountPoints) {
        [PSCustomObject]@{
            Name       = Split-Path $m.MountPoint -Leaf
            MountPoint = $m.MountPoint
            Remote     = $m.Fs
            MountedOn  = $m.MountedOn
        }
    }
}

function Mount-ZipFile {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Path,
        [Parameter(Position = 1)]
        [string]$Name
    )

    if (-not (Get-ZipMountDaemonProcess)) {
        throw "ZipMount daemon is not running. Run Start-ZipMountDaemon first."
    }

    $resolved = Resolve-Path -LiteralPath $Path -ErrorAction Stop
    if ($resolved.Path -notlike '*.zip') {
        throw "Only .zip files are supported: $Path"
    }

    if (-not $Name) {
        $Name = [System.IO.Path]::GetFileNameWithoutExtension($resolved.Path)
    }
    $safeName = ConvertTo-ZipMountSafeName -Name $Name

    $mountPoint = Join-Path $script:ZipMountRoot $safeName
    if (Test-Path $mountPoint) {
        throw "Mount point already exists: $mountPoint (choose a different -Name, or dismount first)"
    }

    if (-not (Test-Path $script:ZipMountRoot)) {
        New-Item -ItemType Directory -Path $script:ZipMountRoot | Out-Null
    }

    if (-not $PSCmdlet.ShouldProcess($resolved.Path, "Mount at $mountPoint")) { return }

    $remoteName = "$script:ZipMountRemotePrefix$safeName"
    & rclone config create $remoteName archive "remote=$($resolved.Path)" --non-interactive | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to create rclone archive remote for $($resolved.Path)"
    }

    try {
        Invoke-ZipMountRc 'mount/mount' @("fs=${remoteName}:", "mountPoint=$mountPoint") | Out-Null
    } catch {
        & rclone config delete $remoteName | Out-Null
        throw
    }

    Write-Host "Mounted '$($resolved.Path)' at $mountPoint"
}

function Dismount-ZipFile {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Name
    )

    if (-not (Get-ZipMountDaemonProcess)) {
        throw "ZipMount daemon is not running."
    }

    $match = Get-ZipMount | Where-Object { $_.Name -eq $Name -or $_.MountPoint -eq $Name }
    if (-not $match) {
        throw "No active ZipMount found matching '$Name'."
    }

    if (-not $PSCmdlet.ShouldProcess($match.MountPoint, 'Dismount')) { return }

    Invoke-ZipMountRc 'mount/unmount' @("mountPoint=$($match.MountPoint)") | Out-Null

    # mount/listmounts reports the archive backend's resolved underlying path
    # as Fs, not the configured remote name, so recompute it the same way
    # Mount-ZipFile derived it rather than trying to parse $match.Remote.
    $remoteName = "$script:ZipMountRemotePrefix$($match.Name)"
    & rclone config delete $remoteName | Out-Null
    Remove-Item -LiteralPath $match.MountPoint -ErrorAction SilentlyContinue

    Write-Host "Dismounted $($match.MountPoint)"
}

Set-Alias zms Start-ZipMountDaemon
Set-Alias zmk Stop-ZipMountDaemon
Set-Alias zmm Mount-ZipFile
Set-Alias zmu Dismount-ZipFile
Set-Alias zml Get-ZipMount
