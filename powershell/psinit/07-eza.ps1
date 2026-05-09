$env:EZA_CONFIG_DIR = "$HOME\psinit"
$env:LESSCHARSET = 'utf-8'
$env:LESS        = '-R -N'

function Expand-EzaArgs {
    $expanded = @()
    foreach ($arg in $args) {
        if ($arg -match '\*|\?|\[') {
            $matches = Get-ChildItem $arg -ErrorAction SilentlyContinue
            if (-not $matches) {
                # Write-Host "eza: no matches found: $arg" -ForegroundColor Red
                # Write-Error "No match: $arg"
                return  # abort — caller gets nothing, eza won't be invoked
            }
            $expanded += $matches.Name
        } else {
            $expanded += $arg
        }
    }
    $expanded
}

function d {
    $ezaArgs = @(Expand-EzaArgs @args)
    if ($ezaArgs.Count -eq 0 -and $args.Count -gt 0) { return }
    eza -l -h --icons --group-directories-first -a --width=$($Host.UI.RawUI.WindowSize.Width) @ezaArgs
}

function dl {
    $ezaArgs = @(Expand-EzaArgs @args)
    if ($ezaArgs.Count -eq 0 -and $args.Count -gt 0) { return }
    eza -l --icons --group-directories-first -a --color=always @(Expand-EzaArgs @args) | less
}

Set-Alias dp Get-ChildItem
