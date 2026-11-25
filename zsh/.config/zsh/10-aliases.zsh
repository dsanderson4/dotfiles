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
