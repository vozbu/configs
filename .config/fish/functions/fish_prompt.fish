function fish_prompt --description 'Write out the prompt'
    set laststatus $status

    if set -l git_branch (command git symbolic-ref HEAD 2>/dev/null | string replace refs/heads/ '')

        set -l upstream (git rev-parse --abbrev-ref --symbolic-full-name @{u} 2> /dev/null)

        if set -l count (command git rev-list --count --left-right $upstream...HEAD 2>/dev/null)
            echo $count | read -l behind ahead
            if test "$behind" -gt 0
                set git_status "$git_status"(set_color yellow)"<<"
            end
            if test "$ahead" -gt 0
                set git_status "$git_status"(set_color yellow)">>"
            end
        end

        set LINES (LANG=C git status -sb 2>/dev/null | wc -l)

        #if not command git diff-index --quiet HEAD --
        if test $LINES -gt 1
            set git_branch_line (set_color red)"$git_branch"(set_color white)
        else
            set git_branch_line (set_color green)"$git_branch"(set_color white)
        end

        if set -q git_status
            set git_status " $git_status"
        end

        set git_info "(git: $git_branch_line$git_status"(set_color white)")"
    end

    # Disable PWD shortening by default.
    set -q fish_prompt_pwd_dir_length
    or set -lx fish_prompt_pwd_dir_length 0

    set j (jobs | grep -v 'no jobs' | wc -l)

    set_color -b black
    printf '%s%s%s%s%s%s%s%s%s%s%s%s%s' (set_color -o white) '❰' (set_color green) $USER (set_color white) '❙' (set_color yellow) (prompt_pwd) (set_color white) $git_info (set_color white) '❱' (set_color white)
    if test $j -gt 0
        printf '%s %d%s' (set_color yellow) $j (set_color normal)
    end
    if test $laststatus -eq 0
        printf "%s✔%s≻%s " (set_color -o green) (set_color white) (set_color normal)
    else
        printf "%s✘%s≻%s " (set_color -o red) (set_color white) (set_color normal)
    end
end
