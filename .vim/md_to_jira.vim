" Converts markdown text to suitable to pasting in JIRA text
" Usage: `:source ~/.vim/md_to_jira.vim` in open buffer with markdown text

" 'silent!' is for not showing errors if nothing was replaced

" change all headings
silent! %s/^######/h6./
silent! %s/^#####/h5./
silent! %s/^####/h4./
silent! %s/^###/h3./
silent! %s/^##/h2./
silent! %s/^#/h1./

" change code blocks
silent! %s/^```\([a-z]\+\)$/{code:\1}/
silent! %s/^```$/{code}/
silent! %s/`\(.\{-}\)`/{{\1}}/g

" remove trailing <br>s
silent! %s/<br>$//

" change text formatting
silent! %s/\*\*/*/g
silent! %s/\[/\\\[/g
silent! %s/\]/\\\]/g
