# Lazygit

`config.yml` is laid out under `.config/lazygit/` so it can be stowed directly
on Linux, where Lazygit reads `~/.config/lazygit/config.yml`.

- **Windows**: delete the existing `~/AppData/Roaming/lazygit` directory first
  (Lazygit creates it on first run, and `New-Item -ItemType SymbolicLink` won't
  replace an existing directory), then run `install.ps1`, which symlinks it to
  `.config/lazygit`.
- **Mac**: Lazygit defaults to `~/Library/Application Support/lazygit`, not
  `~/.config`, so plain `stow` won't land in the right place. Set
  `XDG_CONFIG_HOME=~/.config` (Lazygit honors it on all platforms) before
  running Lazygit, then stow as usual.
