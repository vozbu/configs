set PATH /home/vozbu/.local/bin /home/vozbu/.cargo/bin /home/vozbu/programming/go/bin /home/vozbu/bin $PATH
set GOPATH "$HOME/programming/go"
set GOFLAGS "-mod=vendor"   # https://github.com/golang/go/issues/41301
set CCACHE_COMPRESS 1
set CCACHE_SLOPPINESS pch_defines,time_macros
set EDITOR "/usr/bin/vim"
set MANPAGER "env MAN_PN=1 vim -M +MANPAGER -"
set MANPATH "$HOME/.local/share/man" "$MANPATH"
set -gx GIT_DISCOVERY_ACROSS_FILESYSTEM 1
set MAKEFLAGS "-j "(nproc)
set -gx TESSDATA_PREFIX /usr/share/tessdata

alias dockviz="docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock nate/dockviz"
alias scp="scp -p -r"
alias lg="lazygit"
