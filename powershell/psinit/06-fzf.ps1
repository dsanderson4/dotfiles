Import-Module PSFzf

$env:_PSFZF_FZF_DEFAULT_OPTS="--height 40% --reverse --border"

Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

if ($PSVersionTable.PSVersion.Major -ge  7) {
    Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
}

Set-Alias fgb Invoke-PsFzfGitBranches
Set-Alias fgh Invoke-PsFzfGitHashes
Set-Alias fgt Invoke-PsFzfGitStashes
Set-Alias fkp Invoke-FuzzyKillProcess

# Overrides PSFzf's own Invoke-FuzzyGitStatus (a thin wrapper that just lists
# `git status --short` and returns the selection as text). This version adds a
# lazygit-style layout: a narrow colored status list on the left, a live
# delta-rendered diff preview on the right, and opens the full diff in delta
# on Enter.
function Invoke-FuzzyGitStatus {
    [CmdletBinding()]
    param()

    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        Write-Error 'git not found in PATH'
        return
    }
    if (-not (Get-Command fzf -ErrorAction SilentlyContinue)) {
        Write-Error 'fzf not found in PATH'
        return
    }

    $repoRoot = git rev-parse --show-toplevel 2>$null
    if (-not $repoRoot) {
        Write-Error 'Not inside a git repository'
        return
    }

    $statusLines = git -C $repoRoot status --porcelain=v1 --untracked-files=all
    if (-not $statusLines) {
        Write-Host 'Working tree clean' -ForegroundColor Green
        return
    }

    $esc = [char]27
    $entries = $statusLines | ForEach-Object {
        $xy   = $_.Substring(0, 2)
        $path = $_.Substring(3)
        if ($path -match ' -> (.*)$') { $path = $Matches[1] }

        $color = switch -Regex ($xy) {
            '\?\?'  { 35 }  # untracked - magenta
            'A'     { 32 }  # added - green
            'D'     { 31 }  # deleted - red
            'R'     { 34 }  # renamed - blue
            default { 33 }  # modified etc. - yellow
        }
        "$esc[${color}m$xy$esc[0m`t$path"
    }

    $env:_FGS_REPO_ROOT = $repoRoot
    try {
        $previewScript = Join-Path $PSScriptRoot 'scripts\git-diff-preview.ps1'
        $previewCmd = "pwsh -NoProfile -NoLogo -File $previewScript {2}"

        $fzfArgs = @(
            '--ansi'
            '--height', '100%'
            '--reverse'
            '--border'
            '--multi'
            '--delimiter', "`t"
            '--preview', $previewCmd
            '--preview-window', 'right,70%,border-left'
            '--bind', 'ctrl-f:preview-page-down,ctrl-b:preview-page-up,ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up,ctrl-e:preview-down,ctrl-y:preview-up,home:preview-top,end:preview-bottom'
            '--header', 'Enter: full diff in delta  |  Tab: select  |  ^F/^B page ^D/^U half-page ^E/^Y line Home/End top/bottom (preview)'
        )

        $selected = $entries | fzf @fzfArgs
        if (-not $selected) { return }

        $paths = $selected | ForEach-Object { ($_ -split "`t", 2)[1] }

        $diff = git -C $repoRoot diff --no-ext-diff --color=always HEAD -- $paths
        if (Get-Command delta -ErrorAction SilentlyContinue) {
            $diff | delta
        }
        else {
            $diff | Out-Host -Paging
        }
    }
    finally {
        Remove-Item Env:_FGS_REPO_ROOT -ErrorAction SilentlyContinue
    }
}
Set-Alias fgs Invoke-FuzzyGitStatus

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
