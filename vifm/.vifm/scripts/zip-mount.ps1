# Invoked by vifmrc's *.zip filetype handler. Mounts the given zip under
# ~\ZipMount (see powershell/psinit/16-zipmount.ps1) using a name derived
# from the zip's own filename, uniquified if that name is already mounted,
# then tells the invoking vifm instance to cd into it.
param(
    [Parameter(Mandatory, Position = 0)]
    [string]$ZipPath
)

. "$HOME\dotfiles\powershell\psinit\16-zipmount.ps1"

if (-not (Get-ZipMountDaemonProcess)) {
    Start-ZipMountDaemon
}

$resolved = Resolve-Path -LiteralPath $ZipPath -ErrorAction Stop
$baseName = ConvertTo-ZipMountSafeName -Name ([System.IO.Path]::GetFileNameWithoutExtension($resolved.Path))

$name = $baseName
$suffix = 1
while (Test-Path (Join-Path $script:ZipMountRoot $name)) {
    $suffix++
    $name = "$baseName-$suffix"
}

Mount-ZipFile -Path $resolved.Path -Name $name

if ($env:VIFM_SERVER_NAME) {
    $mountPoint = Join-Path $script:ZipMountRoot $name
    & vifm --server-name $env:VIFM_SERVER_NAME --remote "+cd '$mountPoint'"
}
