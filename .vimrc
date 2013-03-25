set bg=dark
" colorscheme manxome
colorscheme wombat256
let leave_my_textwidth_alone='yes'      " убираем автоматический перенос строк в текстовых файлах (Gentoo-specific)
set softtabstop=4 shiftwidth=4 expandtab
set cindent                             " отступы в стиле Си
set autoread
set autowrite                           " сохранить файл перед выполнением команды
set number                              " вывод номеров строк
set is                                  " incremental search
set fencs=ucs-bom,utf-8,default,cp1251  " fileencodings: list of char-encs considered when starting to edit an existing file"
set foldenable                          " сворачивание функций и т.п.
set foldmethod=syntax                   " клавиши zc, zo, zr
set mouse=a                             " включить мышь везде, где только можно
set list                                " включить отображение непечатных символов на экране
set listchars=tab:>.,trail:.            " отображать табы и пробелы в конце строки
" пути для удобного открытия инклюдов по gf
set path=.,include/**;/home/vozbu/programming
set path+=/usr/include,/usr/local/**/include,/usr/lib/gcc/x86_64-pc-linux-gnu/4.7.2/include/**
autocmd BufWritePre * :%s/\s\+$//e      " убираем конечные пробелы при сохранении любого типа файла
autocmd VimLeave * :mksession! ~/.vim.lastsession   " автоматически сохраняем сессию перед выходом
let c_no_curly_error=1                  " запрещаем подсветку {} внутри () как ошибку (для c++0x)

" fix for using in the screen
if match($TERM, "screen")!=-1
  set term=xterm
endif

if has('gui_running')
    set guifont=Terminus\ 10
endif

" insert date
nnoremap <F5> "=strftime("%Y-%m-%d %H:%M")<CR>P
inoremap <F5> <C-R>=strftime("%Y-%m-%d %H:%M")<CR>
map  :w!<CR>:!aspell check %<CR>:e! %<CR>

" чтобы не сохранять в конце файла перевод строки
" set binary
" set noeol

" поиск выделения по *
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

" From an idea by Michael Naumann
function! VisualSearch(direction) range
   let l:saved_reg = @"
   execute "normal! vgvy"

   let l:pattern = escape(@", '\\/.*$^~[]')
   let l:pattern = substitute(l:pattern, "\n$", "", "")

   if a:direction == 'b'
      execute "normal ?" . l:pattern . "^M"
   elseif a:direction == 'gv'
      call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
   elseif a:direction == 'f'
      execute "normal /" . l:pattern . "^M"
   endif

   let @/ = l:pattern
   let @" = l:saved_reg
endfunction


function! CmdLine(str)
   exe "menu Foo.Bar :" . a:str
   emenu Foo.Bar
   unmenu Foo
endfunction

" ctags
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

" маппим русские буквы в английские для управления
map ё `
map й q
map ц w
map у e
map к r
map е t
map н y
map г u
map ш i
map щ o
map з p
map х [
map ъ ]
map ф a
map ы s
map в d
map а f
map п g
map р h
map о j
map л k
map д l
map ж ;
map э '
map я z
map ч x
map с c
map м v
map и b
map т n
map ь m
map б ,
map ю .
map Ё ~
map Й Q
map Ц W
map У E
map К R
map Е T
map Н Y
map Г U
map Ш I
map Щ O
map З P
map Х {
map Ъ }
map Ф A
map Ы S
map В D
map А F
map П G
map Р H
map О J
map Л K
map Д L
map Ж :
map Э "
map Я Z
map Ч X
map С C
map М V
map И B
map Т N
map Ь M
map Б <
map Ю >

