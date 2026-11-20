param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Path
)

$repoRoot = $env:_FGS_REPO_ROOT
if (-not $repoRoot) { $repoRoot = '.' }

# Untracked files have nothing to diff against HEAD - show the file itself.
$status = git -C $repoRoot status --porcelain=v1 -- $Path | Select-Object -First 1

if ($status -match '^\?\?') {
    $fullPath = Join-Path $repoRoot $Path
    if (Get-Command bat -ErrorAction SilentlyContinue) {
        bat --color=always --style=numbers --paging=never -- $fullPath
    }
    else {
        Get-Content -- $fullPath
    }
    return
}

$diff = git -C $repoRoot diff --no-ext-diff --color=always HEAD -- $Path | Select-Object -First 2000

if (Get-Command delta -ErrorAction SilentlyContinue) {
    $diff | delta --paging=never
}
else {
    $diff
}
