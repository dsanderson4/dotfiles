# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

This is a personal, cross-platform dotfiles repository. There is no build/test/lint
pipeline — "correctness" means "the tool that consumes this config parses it and
behaves as intended," so validate changes by opening the relevant tool (Emacs,
Neovim, etc.) rather than by looking for a test suite.

Each top-level directory configures one tool and mirrors the target directory
structure the tool expects (e.g. `emacs/.emacs.d/`, `neovim/.config/nvim/`,
`vim/.vim/`), so files can be symlinked or stowed directly into `$HOME`.
Coverage per platform is documented in the table in `README.org`. Per-directory
`README.org` files (Emacs-org format, not Markdown) hold tool-specific setup notes
— check for one before making non-trivial changes in a given directory.

## Deploying / linking configs

- **Windows**: each tool has an `install.ps1` at the root of its directory that
  creates a symlink from the real config location into this repo (e.g.
  `emacs/install.ps1` → symlinks `~/.emacs.d` to `emacs/.emacs.d`). Most use a
  `sudo` shim backed by gsudo and assume the repo is cloned to `~/dotfiles`.
  See the tool's `README.org` for install-order caveats (e.g. PowerShell's
  requires deleting `$PROFILE` first).
- **Linux/Mac/WSL/Cygwin**: use GNU Stow from the repo root for emacs, vim,
  neovim, kitty, and i3 (each directory is already laid out as a stow package).
  Stow packages that also contain repo-only files (`install.ps1`, etc.) have a
  `.stow-local-ignore` so those aren't linked into `$HOME`. That file replaces
  stow's built-in ignore list, so it repeats the defaults.
- **Plugin managers need a bootstrap step**:
  - Vim uses minpac. On Windows `vim/install.ps1` clones minpac itself; on other
    platforms run `vim/minpac-install.sh` after stow. Then run `:PackUpdate`
    inside Vim to fetch plugins listed in `vim/.vim/vimrc`.
  - Neovim uses lazy.nvim, which self-bootstraps on first launch
    (`neovim/.config/nvim/lua/lazy/bootstrap.lua` clones it if missing).

## Emacs (`emacs/.emacs.d/`)

`init.el` is the entry point: it sets up `package.el`/`use-package`, then
`require`s feature modules from `lisp/init-*.el` (one file per concern — buffers,
dired, org, csharp, javascript, python, evil, etc.). When adding config, prefer
extending or adding an `lisp/init-*.el` module and requiring it from `init.el`
over inlining config there.

LSP backend is switchable via the `dsa/lsp-client` defcustom (`lsp-mode` or
`eglot`), set up in `lisp/init-lsp.el` and `lisp/init-eglot.el` respectively.
Language modules (e.g. `lisp/init-csharp.el`) branch on this variable to decide
whether to call `lsp-deferred` or `eglot-ensure`, so a language-mode hook should
support both backends rather than assuming one.

`custom.el` (referenced via `custom-file` in `init.el`) holds `customize`-generated
settings and is machine-specific in places (fonts, paths like
`c:/ProgramData/chocolatey/lib/omnisharp/tools/OmniSharp.exe`) — check
`system-type` branches (e.g. in `init-eglot.el`) when editing anything path-related.

`elpa/`, `eln-cache/`, `.cache/`, `transient/`, and similar are gitignored
package/runtime state, not source — never hand-edit or worry about files there.

## Neovim (`neovim/.config/nvim/`)

Plugin management is lazy.nvim. `init.lua` loads `lua/settings/settings.lua`,
bootstraps lazy.nvim, then loads `lua/lazy/plugins.lua`, which is the plugin
list. Each plugin gets its own spec file under `lua/plugins/<name>.lua`,
`require`d from `lua/lazy/plugins.lua` — add new plugins the same way rather than
inlining specs in `plugins.lua`.

This config is shared with the VS Code Neovim extension: `lua/lazy/plugins.lua`
splits plugins into a small "shared" list (comment, hop, surround, bufdelete —
things that make sense inside VS Code too) always loaded, and a much larger list
gated on `not vim.g.vscode` (UI/LSP/file-tree plugins that only make sense in a
standalone terminal Neovim). When adding a plugin, decide which bucket it
belongs in.

`lua/plugins/packer/` is a leftover from a previous plugin manager (packer.nvim)
and is not loaded by anything currently — treat it as historical reference, not
live config.

C# support is `roslyn.nvim` (`lua/plugins/roslyn.lua`) plus Mason-managed LSPs
wired up in `lua/plugins/lspconfig.lua`; `after/ftplugin/cs.lua` holds C#-specific
buffer settings. `easy-dotnet.lua` exists but is currently commented out of the
plugin list in `lua/lazy/plugins.lua`.

## Windows Terminal (`windowsterminal/`)

Windows Terminal auto-generates/mutates `settings.json` in place (new profiles
for detected shells, WSL distros, VS dev prompts), which makes it unstowable
like a normal config file. Instead this directory tracks the *intended*
customizations separately and merges them on top of whatever Terminal has
generated:

- `settings.tracked.json` — the source-of-truth settings this repo owns
  (theme, schemes, actions/keybindings, `profiles.defaults`, and any fully
  hand-authored profiles).
- `changes.json` — an array of directives keyed by profile `name`, applied as a
  second pass after merging. Keys: `managed` (upsert this profile from
  `settings.tracked.json` by name), `default` (make this the default profile),
  `getCommand` (resolve an executable via `Get-Command`; on failure the profile
  is hidden instead), and any other key is copied straight onto the live profile
  (e.g. `hidden`, `startingDirectory`).
- `DeploySettings.ps1` — run from this repo directory. Copies
  `settings.tracked.json`/`changes.json`/`MergeSettings.ps1` into the Terminal
  LocalState directory, backs up and deletes the live `settings.json` so Terminal
  regenerates it from scratch on next launch.
- `MergeSettings.ps1` — run from the LocalState directory after Terminal has
  regenerated `settings.json`. Applies the merge rules documented in its own
  header comment (wholesale-replace for `$schema`/`actions`/`keybindings`;
  tracked-wins for other top-level keys; name-based upsert for managed profiles;
  name-based add/update-never-remove for `schemes`); always backs up
  `settings.json` before writing, and supports `-WhatIf`.

When changing Windows Terminal behavior, edit `settings.tracked.json`/
`changes.json`, not a live `settings.json` on disk — the merge script is what
turns those into the real file.

## Other tools

- `vim/.vim/`: plain `vimrc`/`gvimrc`, plugins via minpac under
  `.vim/pack/minpac/{start,opt}/`.
- `vifm/.vifm/`: colorschemes under `colors/`, helper scripts under `scripts/`
  (see that directory's `README` for what each does).
- `i3/`, `kitty/`, `wezterm/`: single main config file per tool
  (`i3/config`, `kitty.conf`, `wezterm.lua`) plus, for i3, `rofi` menu configs
  and an `i3exit.sh` power-menu script.
- `zsh/`: Oh My Zsh-based; `.zsh` files here are meant to be selectively copied
  (not symlinked wholesale) into `~/.oh-my-zsh/custom` depending on environment
  (`all.zsh` everywhere, `wsl*.zsh` for WSL variants) — see `zsh/README.org`.
