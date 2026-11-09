# Lazygit

`config.yml` is laid out under `.config/lazygit/` so it can be stowed directly
on Linux, where Lazygit reads `~/.config/lazygit/config.yml`.

- **Windows**: Lazygit (as of 0.66.0) reads its config from
  `~/AppData/Local/lazygit/config.yml`, not `~/AppData/Roaming` — verify with
  `lazygit -cd` if a config change doesn't seem to take effect. `install.ps1`
  symlinks only `config.yml` into that directory (not the whole directory),
  since `state.yml` (recent repos, custom command history) lives alongside it
  and is machine-specific runtime state, not something to track in the repo.
- **Mac**: Lazygit defaults to `~/Library/Application Support/lazygit`, not
  `~/.config`, so plain `stow` won't land in the right place. Set
  `XDG_CONFIG_HOME=~/.config` (Lazygit honors it on all platforms) before
  running Lazygit, then stow as usual.
