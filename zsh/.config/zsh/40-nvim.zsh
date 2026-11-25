# Open files in an already-running Neovim, the zsh counterpart of
# powershell/psinit/03-nvim.ps1. The logic (socket path, fallback to a local
# Neovim when none is running) lives in neovim/nvim-remote.sh, shared with
# vifm and Lazygit.
(( $+commands[nvim] )) || return 0

# vr FILE...: open FILE(s) in the running Neovim, or start one here.
function vr() { ~/dotfiles/neovim/nvim-remote.sh "$@" }

# v: same as vr for now. On Windows "v" also switches Windows Terminal to the
# Neovim tab; Ghostty has no CLI/IPC for focusing a tab, so there's no
# equivalent here yet.
function v() { vr "$@" }

# Lazygit can't branch on OS in config.yml (whose os.edit is the Windows
# PowerShell command), so layer the Unix overrides on top of it.
# LG_CONFIG_FILE takes a comma-separated list; later files win.
export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml,$HOME/.config/lazygit/config.unix.yml"
