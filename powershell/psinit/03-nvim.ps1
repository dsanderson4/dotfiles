function Neovim-Remote {
  $path = [System.IO.Path]::GetFullPath($args[0], (Get-Location).Path)
  echo $path
  nvim --server '\\.\pipe\nvim-server' --remote $path
}

function Neovim-Remote-Tab {
  Neovim-Remote @args
  wt -w 0 focus-tab -t 3
}

Set-Alias vr Neovim-Remote
Set-Alias v Neovim-Remote-Tab
