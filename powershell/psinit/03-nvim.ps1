function nvr {
  $path = if (Test-Path $args[0]) { (Resolve-Path $args[0]).Path } else { $args[0] }
  echo $path
  nvim --server '\\.\pipe\nvim-server' --remote $path
}
