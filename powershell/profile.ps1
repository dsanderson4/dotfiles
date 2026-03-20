$psInitDir = Join-Path $HOME 'psinit'
if (Test-Path $psInitDir) {
    Get-ChildItem -Path $psInitDir -Filter '*.ps1' |
        Where-Object { $_.Name -match '^\d.*\.ps1$' } |
        Sort-Object Name |
        ForEach-Object {
            $script = $_
            try {
                . $script.FullName
            }
            catch {
                Write-Warning "psinit: error in $($script.Name): $_"
            }
        }
}
