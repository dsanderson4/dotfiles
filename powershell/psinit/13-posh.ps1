#oh-my-posh --init --shell pwsh --config $env:POSH_THEMES_PATH\cobalt2.omp.json | Invoke-Expression
$poshConfig = "$env:POSH_THEMES_PATH\cobalt2.omp.json"

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator
)

if ($isAdmin) {
    $adminConfig = "$env:POSH_THEMES_PATH\cobalt2-red.omp.json"
    if (Test-Path $adminConfig) {
        $poshConfig = $adminConfig
    }
}

oh-my-posh --init --shell pwsh --config $poshConfig | Invoke-Expression

Import-Module posh-git
