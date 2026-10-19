function Neovim-Remote {
  $path = if (Test-Path $args[0]) { (Resolve-Path $args[0]).Path } else { $args[0] }
  echo $path
  nvim --server '\\.\pipe\nvim-server' --remote $path
}

function Neovim-Remote-Tab {
  Neovim-Remote @args
  wt -w 0 focus-tab -t 3
}

Set-Alias vr Neovim-Remote
Set-Alias v Neovim-Remote-Tab
