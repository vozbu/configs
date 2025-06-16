" apply vim default config
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

" Buttons
" <C-x> - Ctrl+x
" <CR> - Enter
" <Leader> - \

let os = ""
if has("unix")
  let os = substitute(system('uname'), "\n", "", "")
endif

" fix for using in the screen and tmux
" put it really high before applying other options
if match($TERM, "screen")!=-1
  set term=xterm-256color
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
Plugin 'VundleVim/Vundle.vim'

Plugin 'occur.vim'
Plugin 'repeat.vim'
Plugin 'surround.vim'

Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'ctrlpvim/ctrlp.vim'
"Plugin 'easymotion/vim-easymotion'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'godlygeek/tabular'
Plugin 'google/vim-searchindex'
"Plugin 'kshenoy/vim-signature'
Plugin 'lambdalisue/vim-manpager'
Plugin 'majutsushi/tagbar'
Plugin 'preservim/nerdcommenter'
Plugin 'preservim/nerdtree'
Plugin 'rking/ag.vim'
Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-sensible'
Plugin 'tyru/open-browser.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-scripts/mru.vim'

" Markdown
Plugin 'mzlogin/vim-markdown-toc'
Plugin 'plasticboy/vim-markdown'
Plugin 'shime/vim-livedown.git'

" Syntax
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'pboettch/vim-cmake-syntax'

" Languages support
Plugin 'fatih/vim-go'
Plugin 'vim-jp/vim-go-extra'

Plugin 'dense-analysis/ale'
Plugin 'prabirshrestha/vim-lsp'
Plugin 'rhysd/vim-lsp-ale'

Plugin 'mattn/vim-lsp-settings'

" OpenAPI (Swagger)
Plugin 'xavierchow/vim-swagger-preview'

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
if $MAN_PN != 1
    set colorcolumn=+1                      " рисовать вертикальную линию после textdiwth
endif
" рисовать ее серой, а не красной
"highlight ColorColumn ctermbg=lightgrey guibg=lightgrey
syntax on                               " включаем подсветку синтаксиса
set softtabstop=4 shiftwidth=4 expandtab
" set cindent                             " отступы в стиле Си - сильно тормозят на файлах в несколько сот тысяч строк
set autoread                            " автоматически перезагружать файл в буфер при его изменении на диске
set autowrite                           " сохранить файл перед выполнением команды
set number                              " вывод номеров строк
set ruler                               " показывать текущую строку и столбец справа снизу
set showcmd                             " reenable option after vim-airline override - show currently being typed cmd in status bad
set is                                  " incremental search
set hlsearch                            " highlight search
set fencs=ucs-bom,utf-8,default,cp1251  " fileencodings: list of char-encs considered when starting to edit an existing file"
set foldenable                          " сворачивание функций и т.п.
"set foldmethod=syntax                   " клавиши zc, zo, zr
set foldmethod=indent                   " клавиши zc, zm, zr. Быстрее, чем syntax, что заметно на больших файлах
set mouse=a                             " включить мышь везде, где только можно
set list                                " включить отображение непечатных символов на экране
set listchars=tab:>.,trail:.            " отображать табы и пробелы в конце строки
set display+=lastline                   " показывать следующую строку в конце экрана, даже если она обрезана
set linebreak                           " обрезать длинные строки по словам, а не по символам
set complete=.,w,b,u,t                  " автодополнять без поиска по включенным файлам
" пути для удобного открытия инклюдов по gf
set path=.,,
set path+=**
set path+=$HOME/programming/target/**
set path+=/usr/include,/usr/local/**/include,/usr/lib/gcc/x86_64-pc-linux-gnu/*/include/**
autocmd BufNewFile,BufRead *.dox setlocal syntax=doxygen    " поддержка синтаксиса Doxygen в .dox-файлах
autocmd BufNewFile,BufRead *.pp setlocal syntax=ruby
autocmd BufNewFile,BufRead nginx.conf.tmpl setlocal syntax=nginx
autocmd FileType cpp setlocal keywordprg=cppman             " По Shift + K открывать документацию к cpp с использованием cppman
autocmd FileType go setlocal ts=4                           " размер таба 4 символа
autocmd FileType c,cmake,cpp,go,python,sh setlocal textwidth=110 " автоматически переносить строки длиннее 110 символов
autocmd FileType markdown setlocal spell spelllang=en,ru textwidth=110
autocmd BufNewFile,BufRead .vimrc setlocal textwidth=0
autocmd BufWritePre * :%s/\s\+$//e      " убираем конечные пробелы при сохранении любого типа файла
autocmd VimLeave * :mksession! ~/.vim.lastsession   " автоматически сохраняем сессию перед выходом
let c_no_curly_error=1                  " запрещаем подсветку {} внутри () как ошибку (для c++0x)
set switchbuf+=usetab,newtab            " quickfix открывает новую вкладку или испольует существующую, если там нужный буфер
set diffopt+=vertical                   " располагать окна для диффа слева и справа

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
\ if line("'\"") >= 1 && line("'\"") <= line("$") |
\   exe "normal! g`\"" |
\ endif

" вставляем текущие дату и время в конец файла timelog.txt
" делаем это после предыдущей автокоманды, чтобы корректно перейти в конец файла
" и открыть режим ввода
autocmd BufNewFile,BufRead timelog.txt normal! G
autocmd BufNewFile,BufRead timelog.txt :put =strftime('%Y.%m.%d %H:%M ')
autocmd BufNewFile,BufRead timelog.txt normal! $
autocmd BufNewFile,BufRead timelog.txt start!
if has('gui_running')
    if os == "Darwin"
        set guifont=Meslo\ LG\ M\ for\ Powerline:h14
        "set guifont=Meslo\ LG\ S\ for\ Powerline:h14
        "set guifont=Anonymous\ Pro\ for\ Powerline:h16
    else
        set guifont=xos4\ Terminus\ 14
        set guifont=Bitstream\ Vera\ Sans\ Mono\ 8
        set guifont=Hack\ 10
    endif
endif

" Disable Arrow keys in Escape mode
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" insert date
nnoremap <F5> "=strftime("%Y.%m.%d %H:%M")<CR>P
inoremap <F5> <C-R>=strftime("%Y.%m.%d %H:%M")<CR>

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
set tags^=./.git/tags;

" Clang Format
"map <C-K> :!clang-format -i %<CR>
"imap <C-K> <c-o>:!clang-format <CR>
"vmap <C-K> <c-o>:!clang-format <CR>
if os == "Darwin"
    map <C-K> :py3f /usr/local/Cellar/clang-format/12.0.0/share/clang/clang-format.py<cr>
    imap <C-K> <c-o>:py3f /usr/local/Cellar/clang-format/12.0.0/share/clang/clang-format.py<cr>
else
    map <C-K> :py3f /usr/lib/llvm/12/share/clang/clang-format.py<cr>
    imap <C-K> <c-o>:py3f /usr/lib/llvm/12/share/clang/clang-format.py<cr>
endif

" Lsp Server
let g:lsp_ale_auto_config_vim_lsp = 0
let g:lsp_diagnostics_enabled = 0
let g:lsp_settings = {
\   'pyls-all': {
\     'workspace_config': {
\       'pylsp': {
\         'configurationSources': ['flake8'],
\          'plugins': { 'flake8' : { 'maxLineLength' : 120 }}
\       }
\     }
\   },
\}

let g:ale_python_flake8_options = '--max-line-length=120'
let g:ale_python_autopep8_options = '--max-line-length=120'
"let g:ale_python_pylsp_options = '--max-line-length=120'
"let g:ale_linters = {'python': ['pylsp']}
let g:ale_linters = {'python': ['flake8']}
let g:ale_fixers = {'python': ['autopep8']}
"let g:ale_fixers = {'python': ['autopep8', 'pylsp']}
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gc <plug>(lsp-declaration)
    nmap <buffer> gpc <plug>(lsp-peek-declaration)
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gpd <plug>(lsp-peek-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gpi <plug>(lsp-peek-implementation)
    "nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    inoremap <buffer> <expr><c-f> lsp#scroll(+4)
    inoremap <buffer> <expr><c-d> lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" Git integration
set laststatus=2

" Airline
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#show_buffers=1
"let g:airline_theme='solarized'

" leave insert mode quickly
" Powerline makes it sluggish
if ! has('gui_running')
set ttimeoutlen=10
augroup FastEscape
    autocmd!
    au InsertEnter * set timeoutlen=0
    au InsertLeave * set timeoutlen=1000
augroup END
endif

" EasyMotion
map <Leader>s <Plug>(easymotion-s)
map <Leader>w <Plug>(easymotion-w)
map <Leader>e <Plug>(easymotion-e)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

let g:EditorConfig_exclude_patterns = ['fugitive://.*']

"OpenBrowser
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

" настройки форматирования cpp
"let g:cpp_class_scope_highlight = 1
"let g:cpp_member_variable_highlight = 1
"let g:cpp_class_decl_highlight = 1
"let g:cpp_experimental_simple_template_highlight = 1
"let g:cpp_experimental_template_highlight = 1
"let g:cpp_concepts_highlight = 1
"let g:cpp_no_function_highlight = 1

" настройки форматирования go
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_generate_tags = 1

" CtrlP
let g:ctrlp_cmd = 'CtrlPBuffer'

" for markdown syntax
set conceallevel=2

" Swagger preview
nmap <unique> <leader>q <Plug>GenerateDiagram

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
