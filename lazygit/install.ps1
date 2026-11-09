New-Item -ItemType Directory -Path ~/AppData/Local/lazygit -Force | Out-Null
New-Item -ItemType SymbolicLink -Path ~/AppData/Local/lazygit/config.yml -Target ~/dotfiles/lazygit/.config/lazygit/config.yml
