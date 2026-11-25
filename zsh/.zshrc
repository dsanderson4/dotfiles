# Oh My Zsh setup. The full stock template with all the commented-out options
# is kept in dotfiles/zsh/zshrc-template.txt for reference.

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Load modular config from ~/.config/zsh/*.zsh (stowed from dotfiles/zsh),
# in alphabetical order, after Oh My Zsh so these can override its aliases.
# (N) = nullglob: no error if the directory is empty or missing.
for f in ~/.config/zsh/*.zsh(N); do
    source "$f"
done
unset f
