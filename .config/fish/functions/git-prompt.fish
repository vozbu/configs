function git-prompt
    if set -l git_branch (command git symbolic-ref HEAD 2>/dev/null | string replace refs/heads/ '')
        set -l upstream (command git rev-parse --abbrev-ref --symbolic-full-name @{u} 2> /dev/null)

        if set -l count (command git rev-list --count --left-right $upstream...HEAD 2>/dev/null)
            echo $count | read -l behind ahead
            if test "$behind" -gt 0
                set git_status "$git_status"(set_color yellow)"<<"
            end
            if test "$ahead" -gt 0
                set git_status "$git_status"(set_color yellow)">>"
            end
        end

        set lines (LANG=C command git status -sb 2>/dev/null | wc -l)

        #if not command git diff-index --quiet HEAD --
        if test $lines -gt 1
            set git_branch_line (set_color red)"$git_branch"(set_color white)
        else
            set git_branch_line (set_color green)"$git_branch"(set_color white)
        end

        if set -q git_status
            set git_status " $git_status"
        end

        set git_info (set_color white)"(git: $git_branch_line$git_status"(set_color white)")"
    end
    printf '%s' $git_info
end
