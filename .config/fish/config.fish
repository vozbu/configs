set -gx PATH $HOME/.local/bin $HOME/.cargo/bin $HOME/bin $PATH
set -gx GOPATH "$HOME/programming/go"
set -gx GOFLAGS "-mod=vendor"   # https://github.com/golang/go/issues/41301
set PATH $GOPATH/bin $PATH
set -gx CCACHE_COMPRESS 1
set -gx CCACHE_SLOPPINESS pch_defines,time_macros
set -gx EDITOR "/usr/bin/vim"
set -gx MANPAGER "env MAN_PN=1 vim -M +MANPAGER -"
set -gx MANPATH "$HOME/.local/share/man" "$MANPATH"
set -gx GIT_DISCOVERY_ACROSS_FILESYSTEM 1
set -gx MAKEFLAGS "-j "(nproc)
set -gx TESSDATA_PREFIX /usr/share/tessdata

alias dockviz="docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock nate/dockviz"
alias scp="scp -p -r"
alias lg="lazygit"
