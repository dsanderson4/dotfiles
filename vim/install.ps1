sudo New-item -ItemType SymbolicLink -Path ~/vimfiles -Target ~/dotfiles/vim/.vim
if (-not (Test-Path ~/vimfiles/pack/minpac/opt/minpac)) {
    git clone https://github.com/k-takata/minpac.git ~/vimfiles/pack/minpac/opt/minpac
}
