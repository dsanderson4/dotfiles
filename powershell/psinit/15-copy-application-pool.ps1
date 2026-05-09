function Copy-AppPool {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, Position=0)]
        [string]$Source,
        [Parameter(Mandatory, Position=1)]
        [string]$Destination,
        # Start the destination pool after copying (only applies if it didn't already exist).
        [switch]$StartDestination
    )

    $mwaAssembly = [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.Web.Administration')
    if (-not $mwaAssembly) {
        throw 'Microsoft.Web.Administration assembly not found. Ensure IIS is installed.'
    }

    $mgr = [Microsoft.Web.Administration.ServerManager]::OpenRemote('localhost')
    try {
        $srcPool = $mgr.ApplicationPools[$Source]
        if (-not $srcPool) { throw "Source app pool not found: $Source" }

        if (-not $PSCmdlet.ShouldProcess($Destination, "Create/overwrite app pool from '$Source'")) {
            return
        }

        # Track whether destination already existed (determines post-commit action)
        $dstPool = $mgr.ApplicationPools[$Destination]
        if ($dstPool) {
            $mgr.ApplicationPools.Remove($dstPool)
        }

        $newPool = $mgr.ApplicationPools.Add($Destination)
        Copy-MwaElement -Source $srcPool -Destination $newPool

        # Copy-MwaElement doesn't reliably transfer processModel identity —
        # MWA treats these attributes specially, so set them explicitly.
        $newPool.ProcessModel.IdentityType = $srcPool.ProcessModel.IdentityType
        $newPool.ProcessModel.UserName     = $srcPool.ProcessModel.UserName
        $newPool.ProcessModel.Password     = $srcPool.ProcessModel.Password

        $mgr.CommitChanges()

        # Re-open for post-commit operations — handles are stale after CommitChanges
        $mgr2 = [Microsoft.Web.Administration.ServerManager]::OpenRemote('localhost')
        try {
            $pool2 = $mgr2.ApplicationPools[$Destination]

            if ($dstPool) {
                # Pool existed and was potentially running — recycle to pick up new identity
                if ($PSCmdlet.ShouldProcess($Destination, 'Recycle destination app pool to apply new identity')) {
                    $pool2.Recycle()
                    Write-Host "AppPool '$Source' copied to '$Destination' and recycled."
                }
            }
            elseif ($StartDestination) {
                if ($PSCmdlet.ShouldProcess($Destination, 'Start destination app pool')) {
                    $pool2.Start()
                    Write-Host "AppPool '$Source' copied to '$Destination' and started."
                }
            }
            else {
                Write-Host "AppPool '$Source' copied to '$Destination'."
            }
        }
        finally {
            $mgr2.Dispose()
        }
    }
    finally {
        $mgr.Dispose()
    }
}

function Copy-MwaElement {
    <#
    .SYNOPSIS
        Recursively copies MWA ConfigurationElement attributes and child
        collection elements from $Source to $Destination.
    #>
    param(
        [Microsoft.Web.Administration.ConfigurationElement]$Source,
        [Microsoft.Web.Administration.ConfigurationElement]$Destination
    )

    # Copy scalar attributes (skip 'name' — already set by Add())
    foreach ($attr in $Source.Attributes) {
        if ($attr.Name -eq 'name') { continue }
        try {
            $Destination.Attributes[$attr.Name].Value = $attr.Value
        }
        catch {
            Write-Verbose "Skipped attribute '$($attr.Name)': $_"
        }
    }

    # Recurse into child elements (processModel, recycling, recycling/periodicRestart, etc.)
    foreach ($childSrc in $Source.ChildElements) {
        $childDst = $Destination.ChildElements |
            Where-Object { $_.ElementTagName -eq $childSrc.ElementTagName } |
            Select-Object -First 1
        if ($childDst) {
            Copy-MwaElement -Source $childSrc -Destination $childDst
        }
    }
}
