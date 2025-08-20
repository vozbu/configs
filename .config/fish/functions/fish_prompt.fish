function fish_prompt --description 'Write out the prompt'
    set laststatus $status

    if test "$cvs_info" = ''
        set cvs_info (git-prompt)
    end

    # Disable PWD shortening by default.
    set -q fish_prompt_pwd_dir_length
    or set -lx fish_prompt_pwd_dir_length 0

    set j (jobs | grep -v 'no jobs' | wc -l)

    set_color -b black
    printf '%s%s%s%s%s%s%s%s%s%s%s%s%s%s' (set_color -o white) '❰' (set_color green) $USER (set_color white) '❙' (set_color yellow) (prompt_pwd) ' ' (set_color white) $cvs_info (set_color white) '❱' (set_color white)
    if test $j -gt 0
        printf '%s %d%s' (set_color yellow) $j (set_color normal)
    end
    if test $laststatus -eq 0
        printf "%s✔%s≻%s " (set_color -o green) (set_color white) (set_color normal)
    else
        printf "%s✘%s≻%s " (set_color -o red) (set_color white) (set_color normal)
    end
end
