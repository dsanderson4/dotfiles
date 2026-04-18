$global:DirHistoryFile = "$env:USERPROFILE\.dir_history"
$global:DirHistoryMax = 1000

$dirHistoryFile = "$HOME\.dir_history.txt"

# Initialize the file if it doesn't exist
if (-not (Test-Path $dirHistoryFile)) {
    New-Item -ItemType File -Path $dirHistoryFile | Out-Null
}

function Set-LocationWithHistory {
    param([string]$Path)
    Set-Location $Path
    $current = (Get-Location).Path
    if (Test-Path $global:DirHistoryFile) {
        $lines = Get-Content $global:DirHistoryFile | Where-Object { $_ -ne $current }
    } else {
        $lines = @()
    }
    @($current) + $lines |
        Select-Object -First $global:DirHistoryMax |
        Set-Content $global:DirHistoryFile
}

Remove-Item alias:cd -Force

function cd {
    param(
        [ArgumentCompleter({
            param($cmd, $param, $word)
            [System.Management.Automation.CompletionCompleters]::CompleteFilename($word) |
                Where-Object { $_.ResultType -eq 'ProviderContainer' }
        })]
        [string]$Path
    )
    Set-LocationWithHistory $Path
}

function cdh {
    if (-not (Test-Path $global:DirHistoryFile)) { Write-Warning "No directory history"; return }
    $selected = Get-Content $global:DirHistoryFile | fzf --layout=reverse
    if ($selected) { Set-LocationWithHistory $selected }
}

# Add current directory to history
function Add-DirHistory {
    $current = $pwd.Path
    $existing = Get-Content $dirHistoryFile -ErrorAction SilentlyContinue
    if ($existing -notcontains $current) {
        $current | Out-File -Append -FilePath $dirHistoryFile
        Write-Host "Marked: $current" -ForegroundColor Green
    } else {
        Write-Host "Already marked: $current" -ForegroundColor Yellow
    }
}
Set-Alias -Name dm -Value Add-DirHistory

# Jump to a marked directory
function Jump-Dir {
    $dirs = Get-Content $dirHistoryFile | Where-Object { Test-Path $_ } | Select-Object -Unique
    $selected = $dirs | fzf --height 40% --reverse --prompt "Jump to: "
    if ($selected) { 
        Set-LocationWithHistory $selected
        Write-Host "Jumped to: $selected" -ForegroundColor Cyan
    }
}
Set-Alias -Name dj -Value Jump-Dir

function up {
    param([int]$Levels = 0)

    if ($Levels -gt 0) {
        $target = $PWD.Path
        for ($i = 0; $i -lt $Levels; $i++) {
            $target = Split-Path $target -Parent
            if (-not $target) { break }
        }
        if ($target) { Set-LocationWithHistory $target }
        return
    }

    $dirs = @()
    $current = $PWD.Path
    while ($true) {
        $parent = Split-Path $current -Parent
        if (-not $parent -or $parent -eq $current) { break }
        $dirs += $parent
        $current = $parent
    }

    if ($dirs.Count -eq 0) { return }

    $selected = 0
    $width = [Console]::WindowWidth
    $bufferHeight = [Console]::BufferHeight

    # Scroll to make room if needed
    $needed = $dirs.Count
    $current = [Console]::CursorTop
    $available = $bufferHeight - $current
    if ($available -lt $needed) {
        $scrollBy = $needed - $available
        # Emit blank lines to force scroll, then compensate $top
        [Console]::Write("`n" * $scrollBy)
        $current = $bufferHeight - $needed
    }
    $top = $current

    function Render($sel) {
        for ($i = 0; $i -lt $dirs.Count; $i++) {
            [Console]::SetCursorPosition(0, $top + $i)
            $line = if ($i -eq $sel) { "> $($dirs[$i])" } else { "  $($dirs[$i])" }
            $padded = $line.PadRight($width).Substring(0, $width)
            if ($i -eq $sel) {
                [Console]::BackgroundColor = [ConsoleColor]::Cyan
                [Console]::ForegroundColor = [ConsoleColor]::Black
            } else {
                [Console]::ResetColor()
            }
            [Console]::Write($padded)
        }
        [Console]::ResetColor()
    }

    function ClearMenu {
        for ($i = 0; $i -lt $dirs.Count; $i++) {
            [Console]::SetCursorPosition(0, $top + $i)
            [Console]::Write(' ' * $width)
        }
        [Console]::SetCursorPosition(0, $top)
    }

    Render $selected

    while ($true) {
        $key = [Console]::ReadKey($true)
        $isCtrl = $key.Modifiers -band [ConsoleModifiers]::Control

        if ($isCtrl -and $key.Key -eq [ConsoleKey]::J) {
            if ($selected -lt $dirs.Count - 1) { $selected++ }
        } elseif ($isCtrl -and $key.Key -eq [ConsoleKey]::K) {
            if ($selected -gt 0) { $selected-- }
        } elseif ($key.Key -eq [ConsoleKey]::Enter) {
            ClearMenu
            Set-LocationWithHistory $dirs[$selected]
            return
        } elseif ($key.Key -eq [ConsoleKey]::Escape -or
                  ($isCtrl -and $key.Key -eq [ConsoleKey]::C)) {
            ClearMenu
            return
        }

        Render $selected
    }
}

function cdf {
    param([string]$Root = '.')
    $dir = fd --type d --no-ignore --exclude .git --exclude node_modules . $Root |
        fzf --height 40% --reverse
    if ($dir) { Set-LocationWithHistory $dir }
}

function Invoke-DirNavigator {
    param(
        [string]$StartPath = $PWD
    )

    $currentDir = Resolve-Path $StartPath

    while ($true) {
        $entries = @('.') + (
            Get-ChildItem -Path $currentDir -Directory |
                Sort-Object Name |
                ForEach-Object { $_.Name }
        )

        $result = $entries | fzf `
            --no-sort `
            --layout=reverse `
            --expect=ctrl-h,ctrl-l,ctrl-i `
            --header=$currentDir `
            --height=40%

        if ($LASTEXITCODE -eq 130 -or $null -eq $result) { return }

        $key       = $result[0]
        $selection = $result[1]

        switch ($key) {
            'ctrl-h' {
                $parent = Split-Path $currentDir -Parent
                if ($parent) { $currentDir = $parent }
            }
            { $_ -in 'ctrl-l', '' } {
                if ($selection -and $selection -ne '.') {
                    $currentDir = Join-Path $currentDir $selection
                }
            }
            'ctrl-i' {
                $target = if ($selection -eq '.') {
                    $currentDir
                } else {
                    Join-Path $currentDir $selection
                }
                Set-LocatioWithHistory $target
                return
            }
        }
    }
}

Set-Alias dn Invoke-DirNavigator
