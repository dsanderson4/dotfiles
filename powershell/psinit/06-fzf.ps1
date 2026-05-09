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

function frg {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position = 0)]
        [string]$SearchString = '',

        [Parameter(Mandatory = $false)]
        [switch]$e,

        [Parameter(Mandatory = $false, ValueFromRemainingArguments = $true)]
        [string[]]$RgArgs
    )

    if (-not (Get-Command rg -ErrorAction SilentlyContinue)) {
        Write-Error 'rg (ripgrep) not found in PATH'
        return
    }
    if (-not (Get-Command fzf -ErrorAction SilentlyContinue)) {
        Write-Error 'fzf not found in PATH'
        return
    }
    if (-not (Get-Command bat -ErrorAction SilentlyContinue)) {
        Write-Warning 'bat not found in PATH - preview will fall back to type'
    }

    # Build the rg base command, appending any extra rg args
    $rgExtra = if ($RgArgs) { $RgArgs -join ' ' } else { '' }
    $rgBase  = "rg --column --line-number --no-heading --color=always --smart-case $rgExtra".TrimEnd()

    # Preview command: bat if available, otherwise type
    $previewCmd = if (Get-Command bat -ErrorAction SilentlyContinue) {
        'bat --color=always --highlight-line {2} -- {1}'
    } else {
        'type {1}'
    }

    # Build fzf arguments as an array to avoid quoting nightmares
    $fzfArgs = @(
        '--ansi'
        '--disabled'
        '--reverse'
        '--query', $SearchString
        '--bind', "start:reload:$rgBase {q}"
        '--bind', "change:reload:sleep 0.1 & $rgBase {q} || cd ."   # 'cd .' is a no-op that exits 0 on Windows
        '--bind', "ctrl-f:unbind(change,ctrl-f)+change-prompt(fzf> )+enable-search+clear-query+rebind(ctrl-r)"
        '--bind', "ctrl-r:unbind(ctrl-r)+change-prompt(rg> )+disable-search+reload($rgBase {q})+rebind(change,ctrl-f)"
        '--prompt', 'rg> '
        '--delimiter', ':'
        '--preview', $previewCmd
        '--preview-window', 'down,40%,border-top,+{2}+3/3,~3'
        '--header', 'CTRL-F: fzf filter mode | CTRL-R: ripgrep mode'
    )

    $result = fzf @fzfArgs

    if ($result) {
        # Result format is file:line:col:text
        $parts = $result -split ':', 4
        $file  = $parts[0]
        $line  = $parts[1]

        if ($file) {
            if ($e) {
                # emacsclient uses +LINE syntax before the filename
                $lineArg = if ($line) { "+$line" } else { $null }
                if ($lineArg) {
                    & emacsclient -n $lineArg $file
                } else {
                    & emacsclient -n $file
                }
            } else {
                $editor = if ($env:EDITOR) { $env:EDITOR } else { 'notepad' }
                if ($line) {
                    & $editor "+$line" $file
                } else {
                    & $editor $file
                }
            }
        }
    }
}
