Import-Module PSFzf

$env:_PSFZF_FZF_DEFAULT_OPTS="--height 40% --reverse"

Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

if ($PSVersionTable.PSVersion.Major -ge  7) {
    Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
}
