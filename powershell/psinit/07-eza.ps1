$env:EZA_CONFIG_DIR = "$HOME\psinit"
$env:LESSCHARSET = 'utf-8'
$env:LESS        = '-R -N'

function d { eza -l -h --icons --group-directories-first -a @args }

function dl { eza -l -h --icons --group-directories-first -a --color=always @args  | less}

Set-Alias dp Get-ChildItem
