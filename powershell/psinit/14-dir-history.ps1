$dirHistoryFile = "$HOME\.dir_history.txt"

# Initialize the file if it doesn't exist
if (-not (Test-Path $dirHistoryFile)) {
    New-Item -ItemType File -Path $dirHistoryFile | Out-Null
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
        Set-Location $selected
        Write-Host "Jumped to: $selected" -ForegroundColor Cyan
    }
}
Set-Alias -Name dj -Value Jump-Dir
