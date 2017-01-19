" Buttons
" <C-x> - Ctrl+x
" <CR> - Enter
" <Leader> - \

let os = ""
if has("unix")
  let os = substitute(system('uname'), "\n", "", "")
endif

" Vundle options
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'occur.vim'
Plugin 'bling/vim-airline'
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdcommenter'
Plugin 'fatih/vim-go'
Plugin 'vim-jp/vim-go-extra'
Plugin 'majutsushi/tagbar'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'rking/ag.vim'
Plugin 'easymotion/vim-easymotion'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'vim-scripts/mru.vim'
Plugin 'pboettch/vim-cmake-syntax'

if os == "Darwin"
    Plugin 'uarun/vim-protobuf'
endif

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" main options
set bg=dark
" colorscheme manxome
colorscheme wombat256
let leave_my_textwidth_alone='yes'      " убираем автоматический перенос строк в текстовых файлах (Gentoo-specific)
syntax on                               " включаем подсветку синтаксиса
set softtabstop=4 shiftwidth=4 expandtab
set cindent                             " отступы в стиле Си
set autoread
set autowrite                           " сохранить файл перед выполнением команды
set number                              " вывод номеров строк
set ruler                               " показывать текущую строку и столбец справа снизу
set is                                  " incremental search
set hlsearch                            " highlight search
set fencs=ucs-bom,utf-8,default,cp1251  " fileencodings: list of char-encs considered when starting to edit an existing file"
set foldenable                          " сворачивание функций и т.п.
"set foldmethod=syntax                   " клавиши zc, zo, zr
set foldmethod=indent                   " клавиши zc, zm, zr. Быстрее, чем syntax, что заметно на больших файлах
set mouse=a                             " включить мышь везде, где только можно
set list                                " включить отображение непечатных символов на экране
set listchars=tab:>.,trail:.            " отображать табы и пробелы в конце строки
set complete=.,w,b,u,t                  " автодополнять без поиска по включенным файлам
" пути для удобного открытия инклюдов по gf
" set path=.,,**/include/**;/home/vozbu/programming
set path=.,include/**;/home/vozbu/programming
set path+=/usr/include,/usr/local/**/include,/usr/lib/gcc/x86_64-pc-linux-gnu/*/include/**
" autocmd BufNewFile,BufRead *.cpp set syntax=cpp11   " поддержка синтаксиса C++11 в .cpp-файлах
autocmd BufNewFile,BufRead *.cpp set syntax=cpp   " поддержка синтаксиса C++11 в .cpp-файлах
autocmd BufWritePre * :%s/\s\+$//e      " убираем конечные пробелы при сохранении любого типа файла
autocmd VimLeave * :mksession! ~/.vim.lastsession   " автоматически сохраняем сессию перед выходом
let c_no_curly_error=1                  " запрещаем подсветку {} внутри () как ошибку (для c++0x)
set switchbuf+=usetab,newtab            " quickfix открывает новую вкладку или испольует существующую, если там нужный буфер

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
\ if line("'\"") >= 1 && line("'\"") <= line("$") |
\   exe "normal! g`\"" |
\ endif

" fix for using in the screen
if match($TERM, "screen")!=-1
  set term=xterm-256color
endif

if has('gui_running')
    if os == "Darwin"
        set guifont=Meslo\ LG\ M\ for\ Powerline:h14
    else
        set guifont=Terminus\ 10
    endif
endif

" insert date
nnoremap <F5> "=strftime("%Y-%m-%d %H:%M")<CR>P
inoremap <F5> <C-R>=strftime("%Y-%m-%d %H:%M")<CR>

if os == "Darwin"
    " copy to system clipboard
    nmap <F2> :.w !pbcopy<CR><CR>
    vmap <F2> :w !pbcopy<CR><CR>
endif

" Переключение в режим вставки без обработки текста - быстрее вставляет
set pastetoggle=<F3>

" Отменить подсветку последнего поиска
nmap <silent> ,/ :nohlsearch<CR>

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
nmap <F9> :TagbarToggle<CR>

" Clang Format
map <C-K> :!clang-format -style=WebKit<CR>
imap <C-K> <c-o>:!clang-format -style=WebKit<CR>
vmap <C-K> <c-o>:!clang-format -style=WebKit<CR>

" Git integration
"set statusline=%{fugitive#statusline()}
" set statusline=[%n]\ %<%.99f\"%h%w%m%r%{exists('*CapsLockStatusline')?CapsLockStatusline():''}%y%=%-16(\"%l,%c-%v\ %)%P
set laststatus=2

" Airline
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#show_buffers=0
"let g:airline_theme='solarized'

" EasyMotion
map <Leader>s <Plug>(easymotion-s)
map <Leader>w <Plug>(easymotion-w)
map <Leader>e <Plug>(easymotion-e)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

let g:EditorConfig_exclude_patterns = ['fugitive://.*']

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

