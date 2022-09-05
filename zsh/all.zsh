export EDITOR=vim
export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"

function nd()
{
    mkdir -p $1
    cd $1
}

alias c="cp -pv"
alias d="ls -la"
alias e="emacsclient -n"
alias hd="od -A x -t x1z -v"
alias t=cat
alias v="gvim --remote-silent"


