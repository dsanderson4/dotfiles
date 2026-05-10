<#
.SYNOPSIS
    Deploys tracked Windows Terminal settings files to the Terminal LocalState
    directory, then deletes settings.json to trigger regeneration.

.DESCRIPTION
    Run this from your dotfiles repo on initial setup or when you want to
    reset Terminal's auto-detected profiles. After this script completes,
    run MergeSettings.ps1 from the LocalState directory to apply your tracked
    preferences on top of the freshly generated settings.json.

    The existing settings.json is backed up as settings.json.bak before
    deletion.

.EXAMPLE
    .\DeploySettings.ps1
#>

[CmdletBinding(SupportsShouldProcess)]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$localStatePath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
$dotfilesDir    = $PSScriptRoot  # ~/dotfiles/WindowsTerminal

if (-not (Test-Path $localStatePath)) {
    Write-Error "Windows Terminal LocalState directory not found: $localStatePath"
    exit 1
}

$filesToCopy = @(
    'settings.tracked.json'
    'MergeSettings.ps1'
)

foreach ($file in $filesToCopy) {
    $src = Join-Path $dotfilesDir $file
    if (-not (Test-Path $src)) {
        Write-Error "Source file not found: $src"
        exit 1
    }
    $dest = Join-Path $localStatePath $file
    if ($PSCmdlet.ShouldProcess($dest, "Copy $file")) {
        Copy-Item $src $dest -Force
        Write-Host "Copied: $file -> $dest"
    }
}

$settingsPath = Join-Path $localStatePath 'settings.json'
$backupPath   = Join-Path $localStatePath 'settings.json.bak'
Set-Location $localStatePath

if ($PSCmdlet.ShouldProcess($settingsPath, 'Back up and delete settings.json to trigger regeneration')) {
    Copy-Item $settingsPath $backupPath -Force
    Write-Host "Backup : $backupPath"
    Remove-Item $settingsPath -Force
    Write-Host "Deleted: $settingsPath"
    Write-Host "Terminal will regenerate settings.json automatically."
    Write-Host ""
    Write-Host "Next step: run MergeSettings.ps1 from $localStatePath"
}
