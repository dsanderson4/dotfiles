function Copy-AppPool {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, Position=0)]
        [string]$Source,

        [Parameter(Mandatory, Position=1)]
        [string]$Destination,

        # If set, do NOT stop/start the source pool (may fail with NullReferenceException).
        [switch]$NoStop,

        # Start the destination pool after copying.
        [switch]$StartDestination
    )

    Import-Module WebAdministration -ErrorAction Stop

    $srcPath = "IIS:\AppPools\$Source"
    $dstPath = "IIS:\AppPools\$Destination"

    if (-not (Test-Path $srcPath)) { throw "Source app pool not found: $Source" }

    $srcState = (Get-WebAppPoolState -Name $Source -ErrorAction Stop).Value

    try {
        if (-not $NoStop -and $srcState -ne 'Stopped') {
            if ($PSCmdlet.ShouldProcess($Source, "Stop source app pool")) {
                Stop-WebAppPool -Name $Source -ErrorAction Stop
            }
        }

        if ($PSCmdlet.ShouldProcess($Destination, "Create/overwrite destination app pool from $Source")) {
            Copy-Item $srcPath $dstPath -Force -ErrorAction Stop
        }

        if (-not $NoStop -and $srcState -ne 'Stopped') {
            if ($PSCmdlet.ShouldProcess($Source, "Restart source app pool")) {
                Start-WebAppPool -Name $Source -ErrorAction Stop
            }
        }

        if ($StartDestination) {
            if ($PSCmdlet.ShouldProcess($Destination, "Start destination app pool")) {
                Start-WebAppPool -Name $Destination -ErrorAction Stop
            }
        }

        Write-Host "AppPool '$Source' copied to '$Destination'."
    }
    catch {
        # Best-effort: if we stopped it, try to bring it back up
        if (-not $NoStop -and $srcState -ne 'Stopped') {
            try { Start-WebAppPool -Name $Source -ErrorAction SilentlyContinue } catch {}
        }
        throw
    }
}
