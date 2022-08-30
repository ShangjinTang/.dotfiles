" # VIM bashrc by shangjin.tang@gmail.com

" ====================================================================
" ====================================================================
" ## General Settings
filetype indent on              " Enable filetype indent.
filetype plugin on              " Enable filetype plugin.
set history=1000                " Sets how many lines of history VIM has to remember.
syntax enable

" ### Indent, tab, and spaces
set autoindent                 " Indent according to previous line.
set expandtab                  " Use spaces instead of tabs.
set smarttab                   " On - tabstop & shiftwidth, off - tabstop.
set softtabstop=4              " Tab key indents by 4 spaces.
set shiftwidth=4               " >> indents by 4 spaces.
set shiftround                 " >> indents to next multiple of 'shiftwidth'.

" ### Display and show
set cursorline                 " Find the current line quickly.
set display=lastline           " Show as much as possible of the last line.
" set list                       " Show non-printable characters.
set matchtime=1                " Tenths of a second to show the matching parent.
set number                     " Show current line number on the left.
set relativenumber             " Show relative line number of above/below lines on the left.
set showmatch                  " Show matching brackets when text indicator is over them.
set so=7                       " Lines padding to bottom/top while moving with j/k.
set synmaxcol=200              " Only highlight the first 200 columns.

" ### Cursor Move
set backspace=indent,eol,start " Allow backspacing over the indent, eol and start in Insert mode.
set whichwrap+=<,>,h,l         " Allow cursor left/right to move to the previous/next line.

" ### Status Line
set laststatus=2               " Always show statusline.

" ### Command Line
set cmdheight=2                " Height of the command line.
set report=0                   " Always report changed lines.
set ruler                      " Always show current position
set showcmd                    " Show {partial} command in the last line of the screen.
set wildmenu                   " Turn on the Wild menu.

" ### Search
set incsearch                  " Highlight while searching with / or ?.
set hlsearch                   " Keep matches highlighted.
set ignorecase                 " Ignore case in search patterns.
set smartcase                  " Override the 'ignorecase' option if the search pattern contains upper case characters.
set wrapscan                   " Searches wrap around end-of-file.

" ### Redraw Performance
set lazyredraw                 " Only redraw when necessary.
set ttyfast                    " Faster redrawing.

" ### Mutli Files & Split Window
set hidden                     " Switch between buffers without having to save first.
set splitbelow                 " Open new windows below the current window for :split.
set splitright                 " Open new windows right of the current window for :vsplit.

" ### Number Formats
set nrformats=bin,hex          " Do not recognize 0.. as octal number for command <C-a> and <C-x>

" ----------------------------------------------------------

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Properly disable sound on errors on MacVim
if has("gui_macvim")
    autocmd GUIEnter * set vb t_vb=
endif

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

" vim patch 7.4.1799 support termguicolors (true color)
if has("termguicolors")
    " set termguicolors
endif

set term=screen-256color



" ====================================================================
" ====================================================================
" ## Plugins
" ## vim-plug from https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/plugged')
    " status bar plugins
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    " git plugins
    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'
    " fzf plugins
    Plug 'junegunn/fzf'
    Plug 'junegunn/fzf.vim'
    " sidebar plugins
    Plug 'preservim/nerdtree'
    Plug 'preservim/tagbar'
    " comment plugin
    Plug 'tpope/vim-commentary'
    " tab completion plugin
    Plug 'ervandew/supertab'
    " use same keys navigate between tmux/vim
    Plug 'christoomey/vim-tmux-navigator'
    " bracket highlighting
    Plug 'luochen1990/rainbow'
    " theme plugin
    Plug 'NLKNguyen/papercolor-theme'
call plug#end()

" ----------------------------------------------------------
" ### airline
" Reference: https://github.com/vim-airline/vim-airline/blob/master/doc/airline.txt
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'  " show filepath on filenames comflict
let g:airline#extensions#tabline#fnamemod = ':t'  " only show filename (if filenames not comflict). use `:help filename-modifiers` to check all available options
let g:airline#extensions#tabline#buffer_nr_show = 1  " show file buffer number (index)
let g:airline#extensions#tabline#buffer_nr_format = '%s '

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.whitespace = ""
let g:airline_symbols.readonly = "[readonly]"
let g:airline_symbols.maxlinenr = ""
let g:airline_symbols.linenr = " L:"
let g:airline_symbols.colnr = " C:"
let g:airline_symbols.branch = "⎇"
let g:airline_symbols.notexists = " ?"
let g:airline_symbols.dirty = " !"

" ----------------------------------------------------------
" ### SuperTab
" Do not create new space after select completion by <Space>
inoremap <expr> <Space> pumvisible() ? "\<C-y>" : " "
" Do not create new line after select completion by <Enter>
let g:SuperTabCrMapping = 1

" ----------------------------------------------------------
" ### NERDTree
" Reference: https://github.com/dmerejkowsky/vim-nerdtree/blob/master/doc/NERD_tree.txt
let NERDTreeShowBookmarks = 1
let NERDTreeBookmarksSort = 1
let NERDTreeQuitOnOpen = 1
let NERDTreeMinimalUI = 1
let NERDTreeCaseSensitiveSort = 1
let NERDTreeChDirMode = 2
let NERDTreeIgnore=['\.git$', '\.idea$', '\.vscode$', 'cscope.*$[[file]]', '^tags$[[file]]']

augroup nerdtree
    autocmd!
    " Disable relative number for NERDTree
    autocmd FileType nerdtree set norelativenumber
    " Exit Vim if NERDTree is the only window remaining in the only tab.
    autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
    " Close the tab if NERDTree is the only window remaining in it.
    autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
    " Open the existing NERDTree on each new tab.
    autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif
augroup end

" ----------------------------------------------------------
" bracket highlighting
let g:rainbow_conf = {'ctermfgs': [162, 166, 28, 24, 91]}
let g:rainbow_active = 1

" ----------------------------------------------------------
" ### ctags / cscope / tagbar

" search current directory first, then search up to home
set tags=./tags,tags;$HOME

" Reference: http://cscope.sourceforge.net/cscope_vim_tutorial.html
if has("cscope")
    set cscopetag
    set csto=1
    if filereadable("cscope.out")
        cs add cscope.out
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif
    set cscopeverbose

    nnoremap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
    nnoremap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
    nnoremap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
    nnoremap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
    nnoremap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
    nnoremap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nnoremap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nnoremap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
endif

" Reference: https://github.com/preservim/tagbar/blob/master/doc/tagbar.txt
let g:tagbar_width = max([25, winwidth(0) / 4])
let g:tagbar_autoclose  = 1
let g:tagbar_autofocus = 1
let g:tagbar_sort = 0
let g:tagbar_compact = 2
let g:tagbar_show_data_type = 1
let g:tagbar_autoshowtag = 1
let g:tagbar_autopreview = 1


" ====================================================================
" ====================================================================
" ## Key Mappings (map & noremap)

let mapleader = "\<space>"

" Set key to toggle paste mode on/off
set pastetoggle=<C-p>
" Set key to toggle number & relativenumber on/off
noremap <silent> <leader>l :set nonumber! norelativenumber!<CR>

" vim buffer
nnoremap <silent> <leader>q :qa!<CR>     " Quit vim (close all buffers)
nnoremap <silent> <leader>w :bd<CR>      " Close current buffer
nnoremap <silent> <leader><Tab> :b#<CR>  " Switch between current buffer and previous buffer
nnoremap <silent> <leader>{ :bf<CR>      " Switch to first buffer
nnoremap <silent> <leader>} :bl<CR>      " Switch to last buffer
nnoremap <silent> <leader>[ :bp<CR>      " Switch to previous buffer
nnoremap <silent> <leader>] :bn<CR>      " Switch to next buffer
nnoremap <silent> <leader>1 :b1<CR>      " Switch to buffer 1
nnoremap <silent> <leader>2 :b2<CR>      " Switch to buffer 2
nnoremap <silent> <leader>3 :b3<CR>      " Switch to buffer 3
nnoremap <silent> <leader>4 :b4<CR>      " Switch to buffer 4
nnoremap <silent> <leader>5 :b5<CR>      " Switch to buffer 5
nnoremap <silent> <leader>6 :b6<CR>      " Switch to buffer 6
nnoremap <silent> <leader>7 :b7<CR>      " Switch to buffer 7
nnoremap <silent> <leader>8 :b8<CR>      " Switch to buffer 8
nnoremap <silent> <leader>9 :b9<CR>      " Switch to buffer 9


" source code plugins
nnoremap <silent> <leader><leader> :NERDTreeToggle<CR>
nnoremap <silent> <leader>t :TagbarToggle<CR>

" fzf
nnoremap <silent> <leader>f :FZF<CR>

" git shortcuts, starts with <leader>g
" fzf
nnoremap <silent> <leader>gc :Commits<CR>
" vim-fugitive
nnoremap <silent> <leader>gb :Git blame<CR>
nnoremap <silent> <leader>gg :.Git blame<CR>
" vim-gitgutter
nnoremap <silent> <leader>g] :GitGutterNextHunk<CR>
nnoremap <silent> <leader>g[ :GitGutterPrevHunk<CR>
nnoremap <silent> <leader>gs :GitGutterStageHunk<CR>
nnoremap <silent> <leader>gu :GitGutterUndoHunk<CR>
nnoremap <silent> <leader>gp :GitGutterPreviewHunk<CR>


" vim-tmux-navigator
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <C-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-j> :TmuxNavigateDown<cr>
nnoremap <silent> <C-k> :TmuxNavigateUp<cr> nnoremap <silent> <C-l> :TmuxNavigateRight<cr>
" nnoremap <silent> <C-\>:TmuxNavigatePrevious<cr>

" ----------------------------------------------------------
" Disable arrow keys, force use hjkl for cursor move
" TODO: remove these after familiar with hjkl
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" ----------------------------------------------------------
" ## Quick Replace
" replace current word from current line to last line (confirm required)
nnoremap <leader>sw :.,$s/\<<C-R>=expand("<cword>")<CR>\>//gc<Left><Left><Left>
nnoremap <leader>sW :.,$s/\<<C-R>=expand("<cWORD>")<CR>\>//gc<Left><Left><Left>
" replace current word from first line to last line (confirm required)
nnoremap <leader>sa :%s/\<<C-R>=expand("<cword>")<CR>\>//gc<Left><Left><Left>
nnoremap <leader>sA :%s/\<<C-R>=expand("<cWORD>")<CR>\>//gc<Left><Left><Left>
" replace current word in last visual selection
nnoremap <leader>sv :%s/\%V\<<C-R>=expand("<cword>")<CR>\>//g<Left><Left>
nnoremap <leader>sV :%s/\%V\<<C-R>=expand("<cWORD>")<CR>\>//g<Left><Left>

" ----------------------------------------------------------
" ## Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-r>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-r>=@/<CR><CR>
function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"
    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")
    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif
    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" ----------------------------------------------------------

augroup cursormovedi
    autocmd!
    " set no highlight search after enter insert mode and move cursor
    autocmd CursorMovedI * set nohlsearch
    nnoremap n :set hlsearch<CR>n
    nnoremap N :set hlsearch<CR>N
    nnoremap / :set hlsearch<CR>/
    nnoremap ? :set hlsearch<CR>?
    nnoremap * :set hlsearch<CR>*
    nnoremap # :set hlsearch<CR>#
augroup end

augroup inserttoggle
    autocmd!
    " disable line numbers in insert mode
    autocmd InsertEnter * set nonumber
    autocmd InsertEnter * set norelativenumber
    autocmd InsertEnter * :GitGutterSignsDisable
    autocmd InsertLeave * set number
    autocmd InsertLeave * set relativenumber
    autocmd InsertLeave * :GitGutterSignsEnable
augroup end

augroup misc
    autocmd!
    autocmd BufReadPost fugitive://* set bufhidden=delete
augroup end


" ====================================================================
" ====================================================================
" ## Terminal Background

if $TERMINAL_COLOR == 'light'
    set background=light
    colorscheme PaperColor
    let g:airline_theme='papercolor'
endif
if $TERMINAL_COLOR == 'dark'
    set background=dark
    colorscheme PaperColor
    let g:airline_theme='onedark'

    let t:is_transparent = 1
    function! Toggle_transparent_background()
        if t:is_transparent == 0
            hi Normal guibg=#111111 ctermbg=black
            let t:is_transparent = 1
        else
            hi Normal guibg=NONE ctermbg=NONE
            let t:is_transparent = 0
        endif
    endfunction
    call Toggle_transparent_background()

    nnoremap <leader>0 :call Toggle_transparent_background()<CR>

    highlight LineNr ctermbg=NONE guibg=NONE
    highlight clear SignColumn
    highlight airline_c  ctermbg=NONE guibg=NONE
    highlight airline_tabfill ctermbg=NONE guibg=NONE
endif

" ====================================================================
" ====================================================================
