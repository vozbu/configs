function fish_right_prompt
   if test $status = 0
       echo -n (set_color green)
   else
       echo -n (set_color red)
   end

#   echo $CMD_DURATION (set_color normal)ms (set_color yellow) (__fish_git_prompt "%s") (set_color normal)
   echo $CMD_DURATION (set_color normal)ms
end
