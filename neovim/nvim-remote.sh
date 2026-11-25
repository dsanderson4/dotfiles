#!/bin/sh
# Open files in the already-running Neovim on Linux/macOS: the Unix
# counterpart of powershell/psinit/03-nvim.ps1 and lazygit/edit-in-neovim.ps1.
# Used by the zsh "v"/"vr" functions (zsh/.config/zsh/40-nvim.zsh), vifm's
# "o" mapping (vifm/.vifm/vifmrc), and Lazygit's edit command
# (lazygit/.config/lazygit/config.unix.yml).
#
# The first Neovim started claims this socket via serverstart() in
# neovim/.config/nvim/init.lua; the path here must match the one there.
# With no server (or no files), runs Neovim in the current terminal instead,
# and init.lua then makes that instance the server.

dir=${XDG_RUNTIME_DIR:-${TMPDIR:-/tmp}}
sock=${dir%/}/nvim-server.sock

if [ $# -eq 0 ] || [ ! -S "$sock" ]; then
    exec nvim "$@"
fi

# The server's cwd may differ from ours, so send absolute paths.
for f in "$@"; do
    case $f in
        /*) set -- "$@" "$f" ;;
        *)  set -- "$@" "$PWD/$f" ;;
    esac
    shift
done
exec nvim --server "$sock" --remote "$@"
