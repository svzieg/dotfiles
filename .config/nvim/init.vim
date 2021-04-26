" add Plugin Manager here
packadd! vim-plug

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes
Plug 'tpope/vim-sensible'

" Status-Bar
Plug 'itchyny/lightline.vim'

" Database connection
Plug 'tpope/vim-dadbod'


" Project settings
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-dotenv'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-repeat'
Plug 'psliwka/vim-smoothie' "smooth scrooling
Plug 'mhinz/vim-startify' "fancy start
Plug 'https://github.com/puremourning/vimspector'
Plug 'neomake/neomake'
Plug 'sbdchd/neoformat'
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc.nvim', { 'branch': 'master', 'do': 'yarn install --frozen-lockfile' }


if has('nvim')
  Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }

else
  Plug 'Shougo/denite.nvim'
  Plug 'Shougo/defx.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif


" Snippets
Plug 'SirVer/ultisnips' " Track the engine.
Plug 'honza/vim-snippets' " Snippets are separated from the engine. Add this if you want them:

" General Text Settings
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'

" css 

" markdown
Plug 'vimwiki/vimwiki'


" Golang
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Typescript and Javascript
Plug 'HerringtonDarkholme/yats.vim'
Plug 'mhartington/nvim-typescript', {'do': './install.sh'}


" Syntax Highlight
Plug 'https://github.com/joshdick/onedark.vim'
Plug 'https://github.com/arcticicestudio/nord-vim'
Plug 'https://github.com/ayu-theme/ayu-vim'
Plug 'skammer/vim-css-color'

" Initialize plugin system
call plug#end()





let g:vimwiki_list = [{'path': '~/vimwiki/',
      \ 'syntax': 'markdown', 'ext': '.md',
      \ 'path_html': '~/vimwiki_html'}]
autocmd BufEnter diary.md :VimwikiDiaryGenerateLinks

let s:vimwiki_fold_blank_lines = 0  " set to 1 to fold blank lines
let s:vimwiki_header_type = '#'     " set to '=' for wiki syntax

function! Fold(lnum)
  let fold_level = strlen(matchstr(getline(a:lnum), '^' . s:vimwiki_header_type . '\+'))
  if (fold_level)
    return '>' . fold_level  " start a fold level
  endif
  if getline(a:lnum) =~? '\v^\s*$'
    if (strlen(matchstr(getline(a:lnum + 1), '^' . s:vimwiki_header_type . '\+')) > 0 && !g:vimwiki_fold_blank_lines)
      return '-1' " don't fold last blank line before header
    endif
  endif
  return '=' " return previous fold level
endfunction



set conceallevel=2
set concealcursor=


" VimSpector Settings 
"
" If, like me, you only have 2 hands and 10 fingers, you probably don't like Ctrl-Shift-F keys. 
" Also, if you're running in a terminal, there's a real possibility of terminfo being wrong for shifted-F-keys, particularly if your TERM is screen-256color. 
" If these issues (number of hands, TERM variables) are unfixable, try the following mappings, by adding the following before loading vimspector:
" https://github.com/puremourning/vimspector#human-mode
" Key	Function	API
" F5	When debugging, continue. Otherwise start debugging.	vimspector#Continue()
" F3	Stop debugging.	vimspector#Stop()
" F4	Restart debugging with the same configuration.	vimspector#Restart()
" F6	Pause debuggee.	vimspector#Pause()
" F9	Toggle line breakpoint on the current line.	vimspector#ToggleBreakpoint()
" <leader>F9	Toggle conditional line breakpoint on the current line.	vimspector#ToggleBreakpoint( { trigger expr, hit count expr } )
" F8	Add a function breakpoint for the expression under cursor	vimspector#AddFunctionBreakpoint( '<cexpr>' )
" <leader>F8	Run to Cursor	vimspector#RunToCursor()
" F10	Step Over	vimspector#StepOver()
" F11	Step Into	vimspector#StepInto()
" F12	Step out of current function scope	vimspector#StepOut()
let g:vimspector_enable_mappings = 'HUMAN'

" mnemonic 'di' = 'debug inspect' (pick your own, if you prefer!)

" for normal mode - the word under the cursor
nmap <Leader>di <Plug>VimspectorBalloonEval
" for visual mode, the visually selected text
xmap <Leader>di <Plug>VimspectorBalloonEval


" F7  Eval
nmap F7 VimspectorEval

" change the sign priority so that vim-gitgutter doesn't ovewrite the
" breakpoint sign of vimspector
let g:vimspector_sign_priority = {
      \    'vimspectorBP':         999,
      \    'vimspectorBPCond':     999,
      \    'vimspectorBPDisabled': 999,
      \    'vimspectorPC':         999,
      \    'vimspectorPCBP':       999,
      \ }





let g:projectionist_heuristics = {
      \ "package.json": {
      \   "node_modules/bin/*": {"type": "command"}
      \ },
      \ "package.json&yarn.lock": {
      \   "*": {"make": "yarn"}
      \ },
      \ "package.json&package-json.lock": {
      \   "*": {"make": "yarn"}
      \ },
      \ "lib/heroku/&init.rb": {
      \   "lib/heroku/command/*.rb": {"type": "command"}
      \ },
      \ "etc/rbenv.d/|bin/rbenv-*": {
      \   "bin/rbenv-*": {"type": "command"},
      \   "etc/rbenv.d/*.bash": {"type": "hook"}
      \ }}


packadd! defx.nvim
nmap <F8> :Defx<CR>
silent! nunmap <buffer> -
nmap - :Defx `expand('%:p:h')` -search=`expand('%:p')`<CR>
autocmd FileType defx call defx_settings#defx_init()


packadd! tagbar
nmap <F8> :TagbarToggle<CR>

" Define mappings

" packadd! denite-fzf

autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
        \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d
        \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
        \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q
        \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
        \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
        \ denite#do_map('toggle_select').'j'
endfunction

noremap <leader><leader> :Denite file/rec <cr>
noremap <leader>b :Denite buffer <cr>

syntax on

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

packadd! onedark.vim
packadd! nord-vim
packadd! ayu-vim

colorscheme nord
" let ayucolor="light"  " for light version of theme
" let ayucolor="mirage" " for mirage version of theme
" let ayucolor="dark"   " for dark version of theme

" Default Vim Settings for most usecases
" URL: http://vim.wikia.com/wiki/Example_vimrc
" Authors: http://vim.wikia.com/wiki/Vim_on_Freenode
" Description: A minimal, but feature rich, example .vimrc. If you are a
"              newbie, basing your first .vimrc on this file is a good choice.
"              If you're a more advanced user, building your own .vimrc based
"              on this file is still a good idea.

"------------------------------------------------------------
" Features {{{1
"
" These options and commands enable some very useful features in Vim, that
" no user should have to live without.

" Set 'nocompatible' to ward off unexpected things that your distro might
" have made, as well as sanely reset options when re-sourcing .vimrc
set nocompatible

" Attempt to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
filetype indent plugin on

" Enable syntax highlighting
syntax on


"------------------------------------------------------------
" Must have options {{{1
"
" These are highly recommended options.

" Vim with default settings does not allow easy switching between multiple files
" in the same editor window. Users can use multiple split windows or multiple
" tab pages to edit multiple files, but it is still best to enable an option to
" allow easier switching between files.
"
" One such option is the 'hidden' option, which allows you to re-use the same
" window and switch from an unsaved buffer without saving it first. Also allows
" you to keep an undo history for multiple files when re-using the same window
" in this way. Note that using persistent undo also lets you undo in multiple
" files even in the same window, but is less efficient and is actually designed
" for keeping undo history after closing Vim entirely. Vim will complain if you
" try to quit without saving, and swap files will keep you safe if your computer
" crashes.
set hidden

" Note that not everyone likes working this way (with the hidden option).
" Alternatives include using tabs or split windows instead of re-using the same
" window as mentioned above, and/or either of the following options:
" set confirm
" set autowriteall

" Better command-line completion
set wildmenu

" Show partial commands in the last line of the screen
set showcmd

" Highlight searches (use <C-L> to temporarily turn off highlighting; see the
" mapping of <C-L> below)
set hlsearch

" Modelines have historically been a source of security vulnerabilities. As
" such, it may be a good idea to disable them and use the securemodelines
" script, <http://www.vim.org/scripts/script.php?script_id=1876>.
" set nomodeline


"------------------------------------------------------------
" Usability options {{{1
"
" These are options that users frequently set in their .vimrc. Some of them
" change Vim's behaviour in ways which deviate from the true Vi way, but
" which are considered to add usability. Which, if any, of these options to
" use is very much a personal preference, but they are harmless.

" Do not wrap
set nowrap

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent

" Stop certain movements from always going to the first character of a line.
" While this behaviour deviates from that of Vi, it does what most users
" coming from other editors would expect.
set nostartofline
" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler

" Always display the status line, even if only one window is displayed
set laststatus=2

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

" Use visual bell instead of beeping when doing something wrong
set visualbell

" And reset the terminal code for the visual bell. If visualbell is set, and
" this line is also included, vim will neither flash nor beep. If visualbell
" is unset, this does nothing.
set t_vb=

" Enable use of the mouse for all modes
set mouse=a

" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
set cmdheight=2

" Display line numbers on the left
set number

" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200

" Use <F11> to toggle between 'paste' and 'nopaste'
set pastetoggle=<F11>


"------------------------------------------------------------
" Indentation options {{{1
"
" Indentation settings according to personal preference.

" Indentation settings for using 4 spaces instead of tabs.
" Do not change 'tabstop' from its default value of 8 with this setup.
set shiftwidth=2
set softtabstop=2
set expandtab

" Indentation settings for using hard tabs for indent. Display tabs as
" four characters wide.
set tabstop=2


"------------------------------------------------------------
" Mappings {{{1
"
" Useful mappings

" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
map Y y$

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-L> :nohl<CR><C-L>

"------------------------------------------------------------

" create directory if not exists
augroup BWCCreateDir
  autocmd!
  autocmd BufWritePre * if expand("<afile>")!~#'^\w\+:/' && !isdirectory(expand("%:h")) | execute "silent! !mkdir -p ".shellescape(expand('%:h'), 1) | redraw! | endif
augroup END



function! MyOnBattery()
  if has('macunix')
    return match(system('pmset -g batt'), "Now drawing from 'Battery Power'") != -1
  elseif has('unix')
    if filereadable('/sys/class/power_supply/AC/online')
      return readfile('/sys/class/power_supply/AC/online') == ['0']
    endif
  endif
  return 0
endfunction

if MyOnBattery()
  call neomake#configure#automake('w')
else
  call neomake#configure#automake('nw', 1000)
endif

let g:neomake_open_list = 0

noremap <C-i> :lopen <cr>
noremap <C-n> :lnext <cr>
noremap <C-p> :lprev <cr>



" packadd! ale
" " default ale linter
" let g:ale_lint_on_text_changed = 0
" let g:ale_lint_on_insert_leave = 0
" let g:ale_lint_on_save = 0
" let g:ale_open_list = 0
" let g:ale_fix_on_save = 0



packadd! echodoc.vim
" Or, you could use neovim's virtual virtual text feature.
" let g:echodoc#enable_at_startup = 1
set noshowmode " disable the --INSERT-- --VISUAL-- showmode, lightline will do that
let g:echodoc#type = 'echo'


packadd! deoplete.nvim
packadd! deoplete-docker
" Use auto completion

" <TAB>: completion.
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<TAB>"


" Enable deoplete when InsertEnter.
let g:deoplete#enable_at_startup = 0
augroup aucmpl
  au!
  autocmd InsertEnter * call deoplete#enable()
  autocmd InsertEnter * call echodoc#enable()
augroup END

call deoplete#custom#option({
      \ 'auto_complete_delay': 200,
      \ 'smart_case': v:true,
      \ })
" https://github.com/Shougo/deoplete.nvim/issues/41
set completeopt+=noinsert



" Snippets
" packadd! ultisnips
" packadd! deoppet.nvim
packadd! neosnippet.vim
packadd! neosnippet-snippets
" fix missing syntax 
autocmd BufNewFile,BufRead *.snip,*.snippets set filetype=neosnippet
function! s:edit_snippet() 
  let extension =  expand('%:e')
  execute "vs ~/.config/nvim/neosnippets/" . extension . ".snip"
endfunction

command! SnippetEdit call s:edit_snippet()

" imap <C-k>  <Plug>(deoppet_expand)
" imap <expr><Tab>  deoppet#expandable() ?
"       \ "\<Plug>(deoppet_expand)" : "\<Tab>"
" imap <C-f>  <Plug>(deoppet_jump_forward)
" imap <C-b>  <Plug>(deoppet_jump_backward)
" xmap <C-l>  <Plug>(deoppet_select_text)
" xmap <C-x>  <Plug>(deoppet_cut_text)

" call deoppet#initialize()
" call deoppet#custom#option('snippets_dirs',
"       \ globpath(&runtimepath, 'neosnippets', 1, 1))

" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif


" let g:ale_completion_enabled = 1
" Use ALE and also some plugin 'foobar' as completion sources for all code.
" call deoplete#custom#source('ale', 'dup', v:true)



function NeomakeIndicator() abort
  let stats = []
  let lcounts = neomake#statusline#LoclistCounts()
  for key in sort(keys(lcounts))
    call add(stats, printf("%s: %s", key, lcounts[key]))
  endfor
  return join(stats, "|")
endfunction

" Lightline Configuration 
let g:lightline = {
      \ 'colorscheme': 'nord',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'issues', 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead',
      \   'issues' : 'NeomakeIndicator'
      \ },
      \ }


" run low resource heavy autoformatter automatically
augroup fmt
  set smartindent
  autocmd!
  autocmd BufRead,BufWritePre *.vim  call init#intent()
  autocmd BufRead,BufWritePre *.yaml Neoformat
  autocmd BufRead,BufWritePre *.yml Neoformat
  autocmd BufRead,BufWritePre *.go undojoin | Neoformat
  autocmd BufRead,BufWritePre *.json undojoin | Neoformat
  autocmd BufRead,BufWritePre *.py undojoin | Neoformat
  autocmd BufRead,BufWritePre *.cmd undojoin | Neoformat
  autocmd BufRead,BufWritePre *.sh undojoin | Neoformat
  autocmd BufRead,BufWritePre *.bash undojoin | Neoformat
  autocmd BufRead,BufWritePre *.fish undojoin | Neoformat
  autocmd BufRead,BufWritePre *.css undojoin | Neoformat
  "autocmd BufRead,BufWritePre *.html undojoin | Neoformat
  autocmd BufRead,BufWritePre *.rb undojoin | Neoformat
  autocmd BufRead,BufWritePre *.js  Neoformat
  autocmd BufRead,BufWritePre *.jsx  Neoformat
  autocmd BufRead,BufWritePre *.ts Neoformat
  autocmd BufRead,BufWritePre *.tsx  Neoformat
augroup END

function! init#intent()  
  execute "normal gg=G".line(".")."G" 
endfunction


" helpres for autoclosing
inoremap (. (<CR>)<C-c>O
inoremap (. (<CR>)<C-c>O
inoremap {. {<CR>}<C-c>O
inoremap (; (<CR>);<C-c>O
inoremap (, (<CR>),<C-c>O
inoremap {; {<CR>};<C-c>O
inoremap {, {<CR>},<C-c>O
inoremap [; [<CR>];<C-c>O
inoremap [, [<CR>],<C-c>O

"auto close {
function! s:CloseBracket()
  let line = getline('.')
  if line =~# '^\s*\(struct\|class\|enum\) '
    return "{\<Enter>};\<Esc>O"
  elseif searchpair('(', '', ')', 'bmn', '', line('.'))
    " Probably inside a function call. Close it off.
    return "{\<Enter>});\<Esc>O"
  else
    return "{\<Enter>}\<Esc>O"
  endif
endfunction
inoremap <expr> {<Enter> <SID>CloseBracket()





" Trigger configuration. You need to change this to something other than <tab> if you use one of the following:
" - https://github.com/Valloric/YouCompleteMe
" - https://github.com/nvim-lua/completion-nvim
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-n>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"


call denite#custom#var('file_rec', 'command', ['rg', '--files', '--glob', '!.git'])
call denite#custom#var('grep', 'command', ['rg', '--threads', '1'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'final_opts', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'default_opts', ['--vimgrep', '--no-heading'])  

autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
  imap <silent><buffer> <C-o> <Plug>(denite_filter_quit)
endfunction



" SearchRoot finds the first root directory of the file
function! SearchRoot()
  let l:scm_list = ['.root', '.svn', '.git']
  for l:item in l:scm_list
    let l:dirs = finddir(l:item, '.;', -1)
    if !empty(l:dirs)
      return fnamemodify(l:dirs[-1].'/../', ':p:h')
    endif
  endfor
  return getcwd()
endfunction
let g:root_dir = SearchRoot()
autocmd BufEnter * exe ':cd '.g:root_dir
"



" Put these lines at the very end of your vimrc file.

" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall
" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL
