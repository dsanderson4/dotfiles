$env:EZA_CONFIG_DIR = "$HOME\psinit"
$env:LESSCHARSET = 'utf-8'
$env:LESS        = '-R -N'

function Expand-EzaArgs {
    $args | ForEach-Object {
        if ($_ -match '\*|\?') { (Get-ChildItem $_).Name } else { $_ }
    }
}

function d  { eza -l --icons --group-directories-first -a --width=$($Host.UI.RawUI.WindowSize.Width) @(Expand-EzaArgs @args) }
function dl { eza -l --icons --group-directories-first -a --color=always @(Expand-EzaArgs @args) | less }

Set-Alias dp Get-ChildItem
