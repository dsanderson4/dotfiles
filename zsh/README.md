# Z Shell Settings

I use Oh My Zsh as a framework for zsh; the ohmy.sh script installs it (with
`--keep-zshrc`, so it won't overwrite the stowed `.zshrc`).

`.zshrc` is a trimmed-down Oh My Zsh setup with the theme set to "agnoster".
The full stock template, with all its commented-out example options, is kept in
`zshrc-template.txt` for reference (not stowed).

## Layout

This directory is a GNU Stow package:

- `.zshrc` → `~/.zshrc`
- `.config/zsh/*.zsh` → `~/.config/zsh/`

After Oh My Zsh loads, `.zshrc` sources every `~/.config/zsh/*.zsh` in
alphabetical order. Environment-specific files check for that environment
themselves and return early elsewhere, so the whole package can be stowed
everywhere:

- 00-init.zsh: Environment variables (`EDITOR`, `PATH`, etc.).
- 10-aliases.zsh: Aliases and small shell functions.
- 20-wsl.zsh: WSL only; sets `DISPLAY` differently for WSL 1 and WSL 2.
- 30-fzf.zsh: fzf key bindings and completion; skipped if fzf isn't installed.
- 40-nvim.zsh: `v`/`vr` open files in the already-running Neovim (via
  `neovim/nvim-remote.sh`), like the PowerShell functions; starts Neovim
  locally if none is running. Also points Lazygit at its Unix config
  overlay. Skipped if nvim isn't installed.

The numeric prefixes set the load order; leave gaps so new files can slot in.

Nothing goes in `~/.oh-my-zsh/custom` any more.

## Install

```sh
./ohmy.sh                         # if Oh My Zsh isn't installed yet
rm ~/.zshrc                       # stow won't replace a real file
cd ~/dotfiles && stow zsh
```
