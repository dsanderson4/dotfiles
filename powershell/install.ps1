gsudo { 
    param($prof, $poshThemes)
    New-Item -ItemType SymbolicLink -Path $prof -Target profile.ps1
    New-Item -ItemType SymbolicLink -Path ~/psinit -Target psinit
    if (Test-Path $poshThemes) {
        Copy-Item cobalt2-red.omp.json $poshThemes
    }
} -args $PROFILE, $env:POSH_THEMES_PATH
