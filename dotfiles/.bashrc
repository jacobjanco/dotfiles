# terminal coloring and ls config
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

function __convert_secs() {
    local d=h=m=s=''

    ((d=${1}/86400))
    ((h=(${1}%86400)/3600))
    ((m=(${1}%3600)/60))
    ((s=${1}%60))

    local time_array=($d $h $m $s)
    local ts=''

    # append days if there
    if [ "${time_array[0]}" -gt '0' ]; then
        ts+=$(printf "%02d:" ${time_array[0]})
    fi
    for i in {1..3}; do
        ts+=$(printf "%02d:" ${time_array[$i]})
    done
    echo "${ts%?}"
}

# PROMPT_COMMAND and PS configs
export PROMPT_COMMAND=__prompt_command
function __prompt_command() {
    local exit_code="$?"

    # catch timings
    local t0="$LASTCMD_EPOCH"
    local t1="$(date +%s)"
    [ -z "$t0" ] && t0="$t1" # first prompt
    local td="$((t1 - t0))"
    local tp="$(__convert_secs "$td")"

    #16
    local gre='\[\033[0;32m\]'
    local red='\[\033[0;31m\]'
    local cya='\[\033[0;36m\]'
    local non='\[\033[0m\]'
    local blu='\[\033[0;34m\]'

    #256
    local bg='\[\033[48;5;'
    local fg='\[\033[38;5;'
    local vio="$fg"'99m\]'
    local ong="$fg"'129m\]'

    local ec=''
    if [ "$exit_code" == "0" ]; then
        ec="$gre$exit_code$non"
    else
        ec="$red$exit_code$non"
    fi

    local git_branch=''
    if [ -d .git ] || git rev-parse --git-dir > /dev/null 2>&1; then
        git_branch="[$gre$(git rev-parse --abbrev-ref HEAD)$non]"
    fi

    local ps1=''
    if [ "$LANG" == "en_US.UTF-8" ]; then
        ps1+="┌─\u@\h:[$cya\w$non]$git_branch\n└[$ec][$tp]─\$ "
    else
        ps1+="\u@\h:[$cya\w$non]$git_branch\n[$ec][\t]\$ "
    fi

    export PS1="$ps1"

    if [ $ITERM_SESSION_ID ]; then
        echo -ne "\033];${PWD/#$HOME/~}\007"
    fi

    export LASTCMD_EPOCH="$(date +%s)"
}

# history tweaks
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=100000
export HISTFILESIZE=100000
export HISTTIMEFORMAT='%F %T '
shopt -s histappend cmdhist

# load aliases
[ -r $HOME/.bash_aliases ] && source $HOME/.bash_aliases

# git auto-completion script off project repo
source ~/.git-completion.bash
