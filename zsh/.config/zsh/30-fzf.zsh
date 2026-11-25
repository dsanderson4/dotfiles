# fzf key bindings (Ctrl-T, Ctrl-R, Alt-C) and ** completion.
# Skipped on machines without fzf. `fzf --zsh` needs fzf 0.48+.
(( $+commands[fzf] )) || return 0
source <(fzf --zsh)

# Prompt at the top, list growing downward (applies to every fzf invocation).
export FZF_DEFAULT_OPTS="--layout=reverse"
