if &compatible
	set nocompatible
endif

" Set main configuration directory, and where cache is stored.
let $VIMPATH = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')
" Set data/cache directory as $XDG_CACHE_HOME/vim
let $DATA_PATH =
	\ expand(($XDG_CACHE_HOME ? $XDG_CACHE_HOME : '~/.cache') . '/vim')

if isdirectory($DATA_PATH . '/venv/neovim3')
	let g:python3_host_prog = $DATA_PATH . '/venv/neovim3/bin/python'
endif

if filereadable('~/.node_modules/bin/neovim-node-host')
	let g:node_host_prog    = '~/.node_modules/bin/neovim-node-host'
endif

if isdirectory($DATA_PATH)
	set packpath+=$DATA_PATH
endif

" Ensure cache directory
if ! isdirectory(expand($DATA_PATH))
	" Create missing dirs i.e. cache/{undo,backup}
	call mkdir(expand('$DATA_PATH/undo'), 'p')
	call mkdir(expand('$DATA_PATH/backup'))
endif

" Ensure custom spelling directory
if ! isdirectory(expand('$VIMPATH/spell'))
	call mkdir(expand('$VIMPATH/spell'))
endif

" Load vault settings
if filereadable(expand('$VIMPATH/.vault.vim'))
	execute 'source' expand('$VIMPATH/.vault.vim')
endif

function! s:source_file(path, ...) abort
	let use_global = get(a:000, 0, ! has('vim_starting'))
	let abspath = resolve(expand($VIMPATH.'/config/'.a:path))
	if ! use_global
		execute 'source' fnameescape(abspath)
		return
	endif
	let content = map(readfile(abspath),
		\ "substitute(v:val, '^\\W*\\zsset\\ze\\W', 'setglobal', '')")
	let tempfile = tempname()
	try
		call writefile(content, tempfile)
		execute printf('source %s', fnameescape(tempfile))
	finally
		if filereadable(tempfile)
			call delete(tempfile)
		endif
	endtry
endfunction

" Rather than having loads of comments above my mappings I
" try to make well named functions
source ~/.config/nvim/functions.vim

" Disable vim distribution plugins
let g:loaded_getscript = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_gzip = 1
let g:loaded_logiPat = 1
let g:loaded_matchit = 1
let g:loaded_matchparen = 1
let g:netrw_nogx = 1 " disable netrw's gx mapping.
let g:loaded_rrhelper = 1  " ?
let g:loaded_shada_plugin = 1  " ?
let g:loaded_tar = 1
let g:loaded_tarPlugin = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_2html_plugin = 1
let g:loaded_vimball = 1
let g:loaded_vimballPlugin = 1
let g:loaded_zip = 1
let g:loaded_zipPlugin = 1

" If sudo, disable vim swap/backup/undo/shada/viminfo writing
if $SUDO_USER !=# '' && $USER !=# $SUDO_USER
		\ && $HOME !=# expand('~'.$USER)
		\ && $HOME ==# expand('~'.$SUDO_USER)
endif

set noswapfile
set nobackup
set nowritebackup
set noundofile
set shada="NONE"

set secure
filetype plugin indent on
syntax enable

set modeline                 " automatically setting options from modelines
set report=0                 " Don't report on line changes
set errorbells               " Trigger bell on error
set visualbell               " Use visual bell instead of beeping
set hidden                   " hide buffers when abandoned instead of unload
set fileformats=unix,dos,mac " Use Unix as the standard file type
set magic                    " For regular expressions turn magic on
set path=.,**                " Directories to search when using gf
set virtualedit=block        " Position cursor anywhere in visual block
set synmaxcol=1000           " Don't syntax highlight long lines
set formatoptions+=1         " Don't break lines after a one-letter word
set formatoptions-=t         " Don't auto-wrap text
set guioptions=M
set lazyredraw                " Don't redraw screen while running macros

" What to save for views:
set viewoptions-=options
set viewoptions+=slash,unix

" What to save in sessions:
set sessionoptions-=blank
set sessionoptions-=options
set sessionoptions-=globals
set sessionoptions-=folds
set sessionoptions-=help
set sessionoptions-=buffers
set sessionoptions+=tabpages

if has('clipboard')
	set clipboard& clipboard+=unnamedplus
endif
"""""""""""""""""""""""""""""
" Wildmenu
"""""""""""""""""""""""""""""
if has('wildmenu')
	set nowildmenu
	set wildmode=list:longest,full
	set wildoptions=tagfile
	set wildignorecase
	set wildignore+=*.so,.git,.hg,.svn,.stversions,*.pyc,*.spl,*.o,*.out,*~,%*
	set wildignore+=*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store
	set wildignore+=**/node_modules/**,**/bower_modules/**,*/.sass-cache/*
	set wildignore+=application/vendor/**,**/vendor/ckeditor/**,media/vendor/**
	set wildignore+=__pycache__,*.egg-info
endif
"""""""""""""""""""""""""""""
" Vim Directories
"""""""""""""""""""""""""""""
set undofile swapfile nobackup
set directory=$DATA_PATH/swap//,$DATA_PATH,~/tmp,/var/tmp,/tmp
set undodir=$DATA_PATH/undo//,$DATA_PATH,~/tmp,/var/tmp,/tmp
set backupdir=$DATA_PATH/backup/,$DATA_PATH,~/tmp,/var/tmp,/tmp
set viewdir=$DATA_PATH/view/
set undolevels=1000           " How many steps of undo history Vim should remember
set nospell spelllang=en_us   "spellfile=$VIMPATH/spell/en.utf-8.add

" History saving
set history=2000
"  ShaDa/viminfo:
"   ' - Maximum number of previously edited files marks
"   < - Maximum number of lines saved for each register
"   @ - Maximum number of items in the input-line history to be
"   s - Maximum size of an item contents in KiB
"   h - Disable the effect of 'hlsearch' when loading the shada
set shada='300,<50,@100,s10,h
"""""""""""""""""""""""""""""
" Tabs and Indents
"""""""""""""""""""""""""""""
set textwidth=100   " Text width maximum chars before wrapping
set noexpandtab     " Don't expand tabs to spaces.
set tabstop=2       " The number of spaces a tab is
set softtabstop=2   " While performing editing operations
set shiftwidth=2    " Number of spaces to use in auto(indent)
set smarttab        " Tab insert blanks according to 'shiftwidth'
set autoindent      " Use same indenting on new lines
set smartindent     " Smart autoindenting on new lines
set shiftround      " Round indent to multiple of 'shiftwidth'
"""""""""""""""""""""""""""""
" Timing
"""""""""""""""""""""""""""""
set timeout ttimeout
set timeoutlen=500  " Time out on mappings
set ttimeoutlen=10  " Time out on key codes
set updatetime=100  " Idle time to write swap and trigger CursorHold
"""""""""""""""""""""""""""""
"         Searching         "
"""""""""""""""""""""""""""""
set ignorecase      " Search ignoring case
set smartcase       " Keep case when searching with *
set infercase       " Adjust case in insert completion mode
set incsearch       " Incremental search
set hlsearch        " Highlight search results
set wrapscan        " Searches wrap around the end of the file
set showmatch       " Jump to matching bracket
set matchpairs+=<:> " Add HTML brackets to pair matching
set matchtime=1     " Tenths of a second to show the matching paren
set cpoptions-=m    " showmatch will wait 0.5s or until a char is typed
if executable('rg')
	set grepformat=%f:%l:%m
	let &grepprg = 'rg --vimgrep' . (&smartcase ? ' --smart-case' : '')
endif
""""""""""""""""""""""""""""""
"          Behavior          "
""""""""""""""""""""""""""""""
set nowrap                      " No wrap by default
set linebreak                   " Break long lines at 'breakat'
set breakat=\ \	;:,!?           " Long lines break chars
set nostartofline               " Cursor in same column for few commands
set whichwrap+=h,l,<,>,[,],~    " Move to following line on certain keys
set splitbelow splitright       " Splits open bottom right
set shell=/bin/zsh
set switchbuf=useopen,usetab    " Jump to the first open window in any tab
set switchbuf+=vsplit           " Switch buffer behavior to vsplit
set backspace=2
set backspace=indent,eol,start  " Intuitive backspacing in insert mode
set diffopt=filler,iwhite       " Diff mode: show fillers, ignore whitespace
set showfulltag                 " Show tag and tidy search in completion
set complete=.                  " No wins, buffs, tags, include scanning
set completeopt=menuone         " Show menu even for one item
set completeopt+=noselect       " Do not select a match in the menu
set nojoinspaces                " Insert only one space when joining lines that contain sentence-terminating punctuation like `.`.
"""""""""""""""""""""""""""""""""
" Editor UI Appearance
"""""""""""""""""""""""""""""""""
set noshowmode             " Don't show mode in cmd window
set shortmess=aoOTI        " Shorten messages and don't show intro
set scrolljump=5           " Scroll more than one line
set scrolloff=3            " Keep at least 3 lines above/below
set sidescrolloff=5        " Keep at least 5 lines left/right
set number                 " Show line numbers
set numberwidth=4          " The width of the number column
"set ruler                  " Disable default status ruler
set list                   " Show hidden characters
set listchars=tab:▸\       " Char representing a tab
set listchars+=extends:❯   " Char representing an extending line
set listchars+=nbsp:␣      " Non breaking space
set listchars+=precedes:❮  " Char representing an extending line in the other direction
set listchars+=trail:·     " Show trailing spaces as dots
set nocursorcolumn         " Don't highlight the current column
set cursorline             " Highlight the current line

set signcolumn=yes		" Always show signcolumns
set laststatus=2        " Always show a status line
set showtabline=2       " Always show the tabs line
set winwidth=84         " Minimum width for active window
set winheight=7         " Minimum height for active window
try
	set winminwidth=20      " Minimum width for inactive windows
	set winminheight=7      " Minimum height for inactive windows
catch 
endtry
set pumheight=15        " Pop-up menu's line height
set helpheight=12       " Minimum help window height
set previewheight=12    " Completion preview height

set noshowcmd           " Don't show command in status line
set cmdheight=1         " Height of the command line
set cmdwinheight=5      " Command-line lines
set noequalalways       " Don't resize windows on split or close
set colorcolumn=100     " Highlight the 100th character limit

set guifont=JetBrains\ Mono:h12       " Set GUI font

" Specify the behavior when switching between buffers 
try
	set switchbuf=useopen,usetab,newtab
	set stal=2
catch
endtry

" Enables 24-bit RGB color in the TUI
if has('termguicolors')
	set termguicolors
endif
"""""""""""""""""""""""""""""
" Install Coc Extenstions
"""""""""""""""""""""""""""""
let g:coc_global_extensions = [
	\ 'coc-tag',
	\ 'coc-word',
	\ 'coc-utils',
	\ 'coc-marketplace',
	\ 'coc-diagnostic',
	\ 'coc-git',
	\ 'coc-pairs',
	\ 'coc-snippets',
	\ 'coc-yank',
	\ 'coc-highlight',
	\ 'coc-explorer',
	\ 'coc-python',
	\ 'coc-markdownlint',
	\ 'coc-sh',
	\ 'coc-emmet',
	\ 'coc-html',
	\ 'coc-json',
	\ 'coc-css',
	\ 'coc-yaml',
	\ 'coc-svg',
	\ 'coc-vimlsp',
	\ 'coc-eslint',
	\ 'coc-actions',
	\ 'coc-tasks',
	\ 'coc-browser',
	\ 'coc-rust-analyzer',
	\ 'coc-tsserver'
	\]

if executable('clangd')
	let g:coc_global_extensions += ['coc-clangd']
endif
if executable('docker')
	let g:coc_global_extensions += ['coc-docker']
endif
if executable('elixir') && executable('mix')
	let g:coc_global_extensions += ['coc-elixir']
endif
if executable('erlang_ls')
	let g:coc_global_extensions += ['coc-erlang_ls']
endif
if executable('flutter')
	let g:coc_global_extensions += ['coc-flutter']
endif
if executable('php')
	let g:coc_global_extensions += ['coc-phpls']
endif
if executable('r')
	let g:coc_global_extensions += ['coc-r-lsp']
endif
if executable('ruby')
	let g:coc_global_extensions += ['coc-solargraph']
endif
if executable('texlab')
	let g:coc_global_extensions += ['coc-texlab']
endif
if executable('vls')
	let g:coc_global_extensions += ['coc-vetur']
endif

"""""""""""""""""""""""""""""
" Auto Commands
"""""""""""""""""""""""""""""
" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
" Close vista if it is the only open window
autocmd bufenter * if winnr("$") == 1 && vista#sidebar#IsOpen() | execute "normal! :q!\<CR>" | endif
augroup MyAutoCmd
	autocmd!
	autocmd Syntax * if line('$') > 5000 | syntax sync minlines=300 | endif

	" Highlight current line only on focused window
	autocmd WinEnter,InsertLeave * set cursorline
	autocmd WinLeave,InsertEnter * set nocursorline

	" Automatically set read-only for files being edited elsewhere
	autocmd SwapExists * nested let v:swapchoice = 'o'

	" Equalize window dimensions when resizing vim window
	autocmd VimResized * tabdo wincmd =

		" Force write shada on leaving nvim
	autocmd VimLeave * if has('nvim') | wshada! | else | wviminfo! | endif

	" Check if file changed when its window is focus, more eager than 'autoread'
	autocmd WinEnter,FocusGained * checktime

	" Update filetype on save if empty
	autocmd BufWritePost * nested
		\ if &l:filetype ==# '' || exists('b:ftdetect')
		\ |   unlet! b:ftdetect
		\ |   filetype detect
		\ | endif

	" Reload Vim script automatically if setlocal autoread
	autocmd BufWritePost,FileWritePost *.vim nested
		\ if &l:autoread > 0 | source <afile> |
		\   echo 'source '.bufname('%') |
		\ endif

	" When editing a file, always jump to the last known cursor position.
	" Don't do it when the position is invalid or when inside an event handler
	autocmd BufReadPost *
		\ if &ft !~# 'commit' && ! &diff &&
		\      line("'\"") >= 1 && line("'\"") <= line("$")
		\|   execute 'normal! g`"zvzz'
		\| endif
augroup END

augroup configureFoldsAndSpelling
	autocmd!
	autocmd FileType mkd       setlocal spell nofoldenable
	autocmd FileType markdown  setlocal spell nofoldenable
	autocmd FileType text      setlocal spell nofoldenable
	autocmd FileType gitcommit setlocal spell
	autocmd FileType vim       setlocal foldmethod=marker
augroup END

augroup resumeCursorPosition
	autocmd!
	autocmd BufReadPost *
	\ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
augroup END

augroup miscGroup
	autocmd!

	" somehow this is required to move the gray color of the sign column
	autocmd FileType * highlight clear SignColumn

	" when in a git commit buffer go the beginning
	autocmd FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

	" save files when focus is lost
	autocmd BufLeave * silent! update

	" always have quickfix window take up all the horizontal space
	autocmd FileType qf wincmd J

	" configure indentation for python
	autocmd FileType python set expandtab tabstop=4 softtabstop=4 shiftwidth=4

	" configure indentation for python
	autocmd FileType rust set expandtab tabstop=4 softtabstop=4 shiftwidth=4

	" Disable spell checking in vim help files
	autocmd FileType help set nospell

	" Fasto setup
	autocmd BufNewFile,BufRead *.fo setlocal ft=fasto

	" Janus setup
	autocmd BufNewFile,BufRead *.ja setlocal ft=janus

	" C setup, Vim thinks .h is C++
	autocmd BufNewFile,BufRead *.h setlocal ft=c

	" Pow setup
	autocmd BufNewFile,BufRead *.pow setlocal ft=pow
	autocmd BufNewFile,BufRead */playbooks/*.{yml,yaml} setfiletype yaml.ansible
	autocmd BufNewFile,BufRead */inventory/*            setfiletype ansible_hosts
	autocmd BufNewFile,BufRead */templates/*.{yaml,tpl} setfiletype yaml.gotexttmpl
	autocmd BufNewFile,BufRead yarn.lock                setfiletype yaml
	autocmd BufNewFile,BufRead */.kube/config           setfiletype yaml
	autocmd BufNewFile,BufRead *.postman_collection     setfiletype json
	autocmd BufNewFile,BufRead .tern-{project,port}     setfiletype json
	autocmd BufNewFile,BufRead *.lock                   setfiletype json
	autocmd BufNewFile,BufRead *.js.map                 setfiletype json
	autocmd BufNewFile,BufRead .jsbeautifyrc            setfiletype json
	autocmd BufNewFile,BufRead .eslintrc                setfiletype json
	autocmd BufNewFile,BufRead .jscsrc                  setfiletype json
	autocmd BufNewFile,BufRead .babelrc                 setfiletype json
	autocmd BufNewFile,BufRead .watchmanconfig          setfiletype json
	autocmd BufNewFile,BufRead .buckconfig              setfiletype toml
	autocmd BufNewFile,BufRead .flowconfig              setfiletype ini
	autocmd BufNewFile,BufRead *.{feature,story}        setfiletype cucumber
	autocmd BufNewFile,BufRead Jenkinsfile              setfiletype groovy
	autocmd BufNewFile,BufRead Tmuxfile,tmux/config     setfiletype tmux
	autocmd BufNewFile,BufRead Brewfile                 setfiletype ruby
	autocmd BufNewFile,BufRead Justfile,justfile        setfiletype make
	autocmd BufNewFile,BufRead *.ion                    setfiletype ion
	autocmd FileType pow set commentstring={{\ %s\ }}
	autocmd BufWinEnter,WinEnter term://* startinsert
	autocmd BufLeave term://* stopinsert
	autocmd! BufWritePost *.tex call CompileLatex()
	autocmd FileType haskell set colorcolumn=80
	autocmd FileType haskell let &makeprg='hdevtools check %'
	autocmd FileType rust set colorcolumn=9999
	autocmd FileType markdown let &makeprg='proselint %'
	autocmd BufEnter,FocusGained * checktime
	autocmd BufRead *.rs :setlocal tags=./rusty-tags.vi;/
	autocmd FileType rust nnoremap <buffer> <cr> :w<cr>:RustFmt<cr>:w<cr>
	" https://webpack.github.io/docs/webpack-dev-server.html#working-with-editors-ides-supporting-safe-write
	autocmd FileType css,javascript,javascriptreact setlocal backupcopy=yes
augroup END

augroup cocNvim
	autocmd!
	" Setup formatexpr specified filetype(s).
	autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
	" Update signature help on jump placeholder.
	autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
	" Remove unused coc extension
	autocmd User CocNvimInit call UninstallUnusedCocExtensions()
augroup end
augroup rainbow_lisp
	autocmd!
	autocmd FileType * RainbowParentheses 
augroup END
"""""""""""""""""""""""""""""
" Mapping
"""""""""""""""""""""""""""""
" Toggle terminal on/off (neovim)
nnoremap <A-t> :call TermToggle(10)<CR>
inoremap <A-t> <Esc>:call TermToggle(10)<CR>
tnoremap <A-t> <C-\><C-n>:call TermToggle(10)<CR>

" Terminal go back to normal mode
tnoremap <Esc> <C-\><C-n>
tnoremap :q! <C-\><C-n>:q!<CR>

" Start an external command with a single bang
nnoremap ! :!

" Allow misspellings
cnoreabbrev Qa qa
cnoreabbrev Bd bd
cnoreabbrev bD bd
cnoreabbrev qw wq
cnoreabbrev Wq wq
cnoreabbrev WQ wq
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!

" Start new line from any cursor position
inoremap <S-Return> <C-o>o

" Improve scroll, credits: https://github.com/Shougo
nnoremap <expr> zz (winline() == (winheight(0)+1) / 2) ?
	\ 'zt' : (winline() == 1) ? 'zb' : 'zz'
noremap <expr> <C-f> max([winheight(0) - 2, 1])
	\ ."\<C-d>".(line('w$') >= line('$') ? "L" : "M")
noremap <expr> <C-b> max([winheight(0) - 2, 1])
	\ ."\<C-u>".(line('w0') <= 1 ? "H" : "M")
noremap <expr> <C-e> (line("w$") >= line('$') ? "j" : "3\<C-e>")
noremap <expr> <C-y> (line("w0") <= 1         ? "k" : "3\<C-y>")

" Window control
nnoremap <C-q> <C-w>
nnoremap <C-x>  :bd<CR>   " delete buffer
nnoremap <silent><C-w>z :vert resize<CR>:resize<CR>:normal! ze<CR>

"switch windw
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

"smart move
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" Select blocks after indenting
xnoremap < <gv
xnoremap > >gv|

" Use tab for indenting
"vnoremap <Tab> >gv|
"vnoremap <S-Tab> <gv
"nmap <Tab>   >>_
"nmap <S-Tab> <<_

"""""""""""""""""""""""""""""
" Leader Mappings
"""""""""""""""""""""""""""""
let mapleader = "\<Space>"

nnoremap <leader>T :call <SID>run_rust_tests()<cr>
nnoremap <leader>D :w<cr>:Dispatch cargo doc<cr>

function! s:run_rust_tests()
	if &modified
		write
	end
	call SmartRun("cargo test --all -- --test-threads=1 && echo DONE 🎉")
endfunction
"""""""""""""""""""""""""""""
" Plugin Configs
"""""""""""""""""""""""""""""
let g:coc_snippet_next = '<tab>'

" How each level is indented and what to prepend.
" This could make the display more compact or more spacious.
" e.g., more compact: ["▸ ", ""]
" Note: this option only works the LSP executives, doesn't work for `:Vista ctags`.
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]

" Executive used when opening vista sidebar without specifying it.
" See all the avaliable executives via `:echo g:vista#executives`.
let g:vista_default_executive = 'ctags'

" To enable fzf's preview window set g:vista_fzf_preview.
" The elements of g:vista_fzf_preview will be passed as arguments to fzf#vim#with_preview()
" For example:
let g:vista_fzf_preview = ['right:50%']

" Ensure you have installed some decent font to show these pretty symbols, then you can enable icon for the kind.
let g:vista#renderer#enable_icon = 1

" The default icons can't be suitable for all the filetypes, you can extend it as you wish.
let g:vista#renderer#icons = {
\   "function": "\uf794",
\   "variable": "\uf71b",
\  }

let g:rainbow#max_level = 16
let g:rainbow#pairs = [['(', ')'], ['[', ']']]
"""""""""""""""""""""""""""""
" Plugin Mappings
"""""""""""""""""""""""""""""

"""" Conqueror of Completion """"

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Use <C-j> and <C-kta> to navigate the completion list:
inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"

" Close the preview window when completion is done.
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

inoremap <silent><expr> <TAB>
	\ pumvisible() ? coc#_select_confirm() :
	\ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
	\ CheckBackSpace() ? "\<TAB>" :
	\ coc#refresh()

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

"""""""""""""""""""""""""""""
" Lightline
"""""""""""""""""""""""""""""


function MyGitStatus() abort
	let branch = gina#component#repo#branch()
	let unstaged = gina#component#status#unstaged()
	let conflicted = gina#component#status#conflicted()
	return printf(
		\ '%s, u: %s, c: %s',
		\ branch,
		\ unstaged,
		\ conflicted,
		\)
endfunction