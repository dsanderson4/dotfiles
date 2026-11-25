# WSL-only settings. Safe to source everywhere: returns early outside WSL.
[[ -n "$WSL_DISTRO_NAME" ]] || return 0

alias rr="rofi -width 20 -show run &"
alias rw="rofi -width 20 -show window &"

# WSL 2 kernels report "microsoft-standard-WSL2"; WSL 1 reports "...-Microsoft".
if [[ "$(uname -r)" == *WSL2* ]]; then
    export DISPLAY=$(awk '/^nameserver/ {print $2; exit}' /etc/resolv.conf):0.0
else
    export DISPLAY=:0
fi
