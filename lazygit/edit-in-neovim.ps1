param(
    [Parameter(Mandatory = $true)]
    [string]$Path,
    [switch]$Detached
)

# Used as Lazygit's os.edit command (lazygit/.config/lazygit/config.yml).
#
# nvim's own "--remote" falls back to executing locally when the server pipe
# is missing (see :help --remote), which hangs forever here: Lazygit runs
# this script with no real console attached, so a locally-started Neovim TUI
# waits on input it can never receive. Checking for the pipe first avoids
# ever taking that path. cmd.exe's "if exist" can't detect named pipes at
# all (always reports missing), so this needs to be PowerShell.
if (-not (Test-Path '\\.\pipe\nvim-server')) {
    Start-Process nvim -ArgumentList "`"$Path`""
    return
}

# "nvim --remote"'s RPC round trip is unpredictable in practice - measured
# anywhere from ~200ms to 1.2s+ for the exact same call, for reasons not
# fully pinned down (not file-dependent, not config-load time - ruled both
# out). Lazygit blocks its whole input loop on this command regardless of
# os.editInTerminal, so relaunching ourselves detached keeps that block to
# a fixed, small (~100-150ms) window no matter how slow the remote call
# turns out to be on any given run.
if (-not $Detached) {
    Start-Process powershell -ArgumentList '-NoProfile', '-File', "`"$PSCommandPath`"", "`"$Path`"", '-Detached' -WindowStyle Hidden
    return
}

nvim --server '\\.\pipe\nvim-server' --remote $Path
Start-Process wt -ArgumentList '-w', '0', 'focus-tab', '--target', '3' -WindowStyle Hidden
