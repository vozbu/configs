# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
    # Shell is non-interactive.  Be done now!
    return
fi

if [[ -d /etc/bash_completion.d ]]; then
    for i in /etc/bash_completion.d/*; do
        source $i
    done
fi

# don't put duplicate lines in the history
export HISTCONTROL=ignoreboth,erasedups
export HISTFILESIZE=3000
# append to the history file, don't overwrite it
shopt -s histappend
# save all lines of a multiple-line command in the same history entry (allows easy re-editing of multi-line commands)
shopt -s cmdhist
# correct minor errors in the spelling of a directory component in a cd command
shopt -s cdspell

export GOPATH="$HOME/programming/go"
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$GOPATH/bin:$HOME/bin:$PATH"
export CCACHE_COMPRESS=1
export CCACHE_SLOPPINESS=pch_defines,time_macros
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export EDITOR="/usr/bin/vim"
export MANPAGER="env MAN_PN=1 vim -M +MANPAGER -"
export MANPATH="$HOME/.local/share/man:$MANPATH"
export GIT_DISCOVERY_ACROSS_FILESYSTEM=1
export GOPATH="$HOME/programming/go"

if [[ `uname` == 'Darwin' ]]; then
    # for MacOS Catalina and further
    #export BASH_SILENCE_DEPRECATION_WARNING=1

    export HOMEBREW_PREFIX="/opt/homebrew"
    export HOMEBREW_CELLAR="${HOMEBREW_PREFIX}/Cellar"
    export HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}"
    export PATH="${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/sbin:${PATH+:$PATH}"
    export MANPATH="${HOMEBREW_PREFIX}/share/man:${MANPATH+:$MANPATH}:"
    export INFOPATH="${HOMEBREW_PREFIX}/share/info:${INFOPATH:-}"

    export PATH="${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin:$PATH"
    export PATH="${HOMEBREW_PREFIX}/opt/gnu-sed/libexec/gnubin:$PATH"
    export MANPATH="${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnuman:$MANPATH"
    export MANPATH="${HOMEBREW_PREFIX}/Cellar/gcc/7.3.0/share/man:$MANPATH"

    export EDITOR="${HOMEBREW_PREFIX}/bin/vim"

    if type brew &>/dev/null; then
        HOMEBREW_PREFIX="$(brew --prefix)"
        if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
            source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
        else
            for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
                [[ -r "$COMPLETION" ]] && source "$COMPLETION"
            done
        fi
    fi

    alias grep='grep --color=auto'
    # for native MacOS ls
    #alias ls='ls -G'
    # for brew coreutil
    alias ls='ls --color=auto'
    alias ldd='otool -L'
fi

alias dockviz="docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock nate/dockviz"
alias scp="scp -p -r"
alias lg="lazygit"

# using nproc after correct PATH setting
export MAKEFLAGS="-j `nproc`"

escape() {
    echo "\[\033[$1\]"
}

# Attributes
c_reset=`escape 0m`     ;
c_bold_on=`escape 1m`   ;       c_bold_off=`escape 22m`
c_blink_on=`escape 5m`  ;       c_blink_off=`escape 25m`
c_reverse_on=`escape 7m`;       c_reverse_off=`escape 27m`
# Foreground colors
cf_default=`escape 39m`
cf_black=`escape 30m`
cf_red=`escape 31m`
cf_green=`escape 32m`
cf_yellow=`escape 33m`
cf_blue=`escape 34m`
cf_magenta=`escape 35m`
cf_cyan=`escape 36m`
cf_white=`escape 37m`
cf_gray=`escape 38m`
# Background colors
cb_default=`escape 49m`
cb_black=`escape 40m`
cb_red=`escape 41m`
cb_green=`escape 42m`
cb_yellow=`escape 43m`
cb_blue=`escape 44m`
cb_magenta=`escape 45m`
cb_cyan=`escape 46m`
cb_white=`escape 47m`

# setup color variables
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    c_is_on=true
    c_off="\[$(/usr/bin/tput sgr0)\]"

    c_error="$(/usr/bin/tput setab 1)$(/usr/bin/tput setaf 7)"
    c_error_off="$(/usr/bin/tput sgr0)"

    # set user color
    case `id -u` in
        0) c_user=$cf_red ;;
        *) c_user=$cf_green ;;
    esac
fi

# some kind of optimization - check if git installed only on config load
PS1_GIT_BIN=$(which git 2>/dev/null)

jobscount() {
    local stopped=$(jobs -sp | wc -l)
    local running=$(jobs -rp | wc -l)
    ((running+stopped)) && echo -n "${cf_yellow}jobs ${running}r/${stopped}s${c_off} "
}
function prompt_command {
    local PS1_GIT=
    local GIT_BRANCH=
    local GIT_DIRTY=
    local GIT_PULL=
    local PWDNAME=$PWD

    # beautify working directory name
    if [[ "${HOME}" == "${PWD}" ]]; then
        PWDNAME="~"
    elif [[ "${HOME}" == "${PWD:0:${#HOME}}" ]]; then
        PWDNAME="~${PWD:${#HOME}}"
    fi

    # parse git status and get git variables
    if [[ ! -z $PS1_GIT_BIN ]]; then
        # check we are in git repo
        local CUR_DIR=$PWD
        while [[ ! -e "${CUR_DIR}/.git" ]] && [[ ! "${CUR_DIR}" == "/" ]] && [[ ! "${CUR_DIR}" == "~" ]] && [[ ! "${CUR_DIR}" == "" ]]; do CUR_DIR=${CUR_DIR%/*}; done
        if [[ -e "${CUR_DIR}/.git" ]]; then
            # 'git repo for dotfiles' fix: show git status only in home dir and other git repos
            if [[ "${CUR_DIR}" != "${HOME}" ]] || [[ "${PWD}" == "${HOME}" ]]; then
                # get git branch
                GIT_BRANCH=$($PS1_GIT_BIN symbolic-ref HEAD 2>/dev/null)
                if [[ ! -z $GIT_BRANCH ]]; then
                    GIT_BRANCH=${GIT_BRANCH#refs/heads/}

                    # get git status
                    local GIT_STATUS=$(LANG=C $PS1_GIT_BIN status -sb 2>/dev/null)
                    local LINES=$(echo "$GIT_STATUS" | wc -l)
                    [ $LINES -gt 1 ] && GIT_DIRTY=1

                    echo "$GIT_STATUS" | grep    -q behind          && GIT_PULL=" ${cf_yellow}<<${c_off}"
                    echo "$GIT_STATUS" | grep    -q ahead           && GIT_PULL=" ${cf_yellow}>>${c_off}"
                    echo "$GIT_STATUS" | grep -E -q "ahead.+behind" && GIT_PULL=" ${cf_yellow}<<>>${c_off}"
                fi
            fi
        fi
    fi

    # build b/w prompt for git
    [[ ! -z $GIT_BRANCH ]] && PS1_GIT=" (git: ${GIT_BRANCH})"

    if $c_is_on; then
        # build git status for prompt
        if [[ ! -z $GIT_BRANCH ]]; then
            if [[ -z $GIT_DIRTY ]]; then
                PS1_GIT=" (git: ${cf_green}${GIT_BRANCH}${c_off}${GIT_PULL})"
            else
                PS1_GIT=" (git: ${cf_red}${GIT_BRANCH}${c_off}${GIT_PULL})"
            fi
        fi
    fi

    # set new color prompt
    PS1="${cb_blue}${cf_white}\t${cb_default} $(jobscount)${c_bold_on}${c_user}\u${cf_white}@${cf_yellow}\h${cf_blue} \w${c_off}${PS1_GIT}\n> "

# eats command which is typed while terminal was thinking :(
#    echo -en "\033[6n" && read -sdR CURPOS
#    [[ ${CURPOS##*;} -gt 1 ]] && echo "${c_error}↵${c_error_off}"

    # set title
    case "$TERM" in
        screen*)
            echo -ne "\033k$HOSTNAME\033\\"
            ;;
        *)
            echo -ne "\033]0;${USER}@${HOSTNAME}:${PWDNAME}"; echo -ne "\007"
            ;;
    esac
}

# set prompt command (title update and color prompt)
PROMPT_COMMAND=prompt_command
# will be overwritten in 'prompt_command' later for color prompt
export PS1="\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] "
