Import-Module PSFzf

$env:_PSFZF_FZF_DEFAULT_OPTS="--height 40% --reverse --border"

Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

if ($PSVersionTable.PSVersion.Major -ge  7) {
    Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
}

Set-Alias fgs Invoke-FuzzyGitStatus
Set-Alias fgb Invoke-PsFzfGitBranches
Set-Alias fgh Invoke-PsFzfGitHashes
Set-Alias fgt Invoke-PsFzfGitStashes
Set-Alias fkp Invoke-FuzzyKillProcess
