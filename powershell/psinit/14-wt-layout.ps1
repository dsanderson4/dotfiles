# Opens the rest of the "standard" Windows Terminal tab layout as new tabs
# in the current window: Lazygit, Claude Code, Neovim, and Vifm, in that
# order. Also splits the initial VS 2026 PowerShell tab and the Claude Code
# tab into two panes each, via split-pane's --duplicate flag (wt.exe has no
# CLI command for the tab-level "Duplicate Tab" action, but split-pane -D
# duplicates the active pane within its tab, which is what we actually want
# here). Run this after Windows Terminal has started with its default
# profile (Developer PowerShell for VS 2026) already open as the first tab.
#
# Resulting tab order (0-indexed): 0 VS 2026 PowerShell (2 panes),
# 1 Lazygit, 2 Claude Code (2 panes), 3 Neovim, 4 Vifm. Neovim's index here
# must match the --target in vifm's "o" mapping (vifm/.vifm/vifmrc). Ends
# back on tab 0.
function Open-StandardTabs {
    $wtArgs = @(
        '-w', '0',
        'split-pane', '-D', ';',
        'new-tab', '-p', 'Lazygit', ';',
        'new-tab', '-p', 'Claude Code', ';',
        'split-pane', '-D', ';',
        'new-tab', '-p', 'Neovim', ';',
        'new-tab', '-p', 'Vifm', ';',
        'focus-tab', '-t', '0'
    )
    & wt @wtArgs
}
