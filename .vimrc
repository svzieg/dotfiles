
"{{{ NeoBundle Scripts-----------------------------
" ======================================================================================
if &compatible
    set nocompatible               " Be iMproved
endif


" Required:
set runtimepath^=/home/svzieg/.vim/bundle/neobundle.vim/

" Required:
call neobundle#begin(expand('/home/svzieg/.vim/bundle'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'
"}}}

"{{{ Plugins
"==========================================================================================
"
"
" Add or remove your Bundles here:

" Coding Helper
"NeoBundle 'Shougo/neocomplete.vim'
"NeoBundle 'Valloric/YouCompleteMe', {'build': {'unix': 'sh ./install.sh --tern-completer'}}
NeoBundle 'tomtom/tcomment_vim'
"NeoBundle 'Shougo/neosnippet.vim'
"NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'SirVer/ultisnips'
NeoBundle 'honza/vim-snippets'
NeoBundle 'klen/rope-vim'
NeoBundle 'tpope/vim-surround'
NeoBundle 'godlygeek/tabular'
"NeoBundle 'walm/jshint
"NeoBundle 'vim-syntastic/syntastic'
NeoBundle 'w0rp/ale'
NeoBundle 'tpope/vim-surround'
NeoBundle 'godlygeek/tabular'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-sensible'
NeoBundle 'alvan/vim-closetag'
NeoBundle 'tpope/vim-sexp-mappings-for-regular-people'
NeoBundle 'jiangmiao/auto-pairs'
NeoBundle 'raghur/vim-ghost', {'build': {'unix': 'sh ./install'}}
" Web
"NeoBundleLazy 'jelera/vim-javascript-syntax', {'autoload':{'filetypes':['javascript']}}
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'digitaltoad/vim-jade'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'sidorares/node-vim-debugger'
"NeoBundle 'maksimr/vim-jsbeautify'
NeoBundle 'prettier/vim-prettier', { 'do': 'yarn install' }
NeoBundle 'editorconfig/editorconfig-vim'

" Node
NeoBundle 'moll/vim-node'
NeoBundle 'ternjs/tern_for_vim', {'build': {'unix': 'yarn install'}}

" Navigation
NeoBundle 'scrooloose/nerdtree'
"NeoBundle 'easymotion/vim-easymotion'
"NeoBundle 'wincent/command-t', 
"    \   'build_commands': ['make', 'ruby'],
"    \   'build': {
"    \      'unix': 'cd ruby/command-t/ext/command-t && { make clean; ruby extconf.rb && make }'
"    \   }
"\ }

" ColorSchemes and Style of vim
NeoBundle 'flazz/vim-colorschemes'
"NeoBundle 'vim-airline/vim-airline'
"NeoBundle 'fholgado/minibufexpl.vim'
NeoBundle 'fcpg/vim-farout'

" Bugtracker
NeoBundle 'rafi/vim-unite-issue', {
    \  'directory': 'unite-issue',
    \  'unite_sources': [ 'issue' ],
    \  'depends': [
    \    'mattn/webapi-vim', 'tyru/open-browser.vim', 'Shougo/unite.vim'
    \  ]
    \ }


" Required:
call neobundle#end()


" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
"End NeoBundle Scripts-------------------------
"}}}

"{{{ Vim Einstellungen 
" =======================================================================================
set backspace=indent,eol,start          " allow backspacing over everything in insert mode


syntax on

set shiftwidth=2                        " I like 4 spaces for indenting
set tabstop=2                           " I like 4 stops
set expandtab                           " Spaces instead of tabs
set autoindent                          " Always  set auto indenting on


set path=**
set wildignore+=*/node_modules/*,*/build/*,*/bower_components/*,*/out*/
set wildmenu
set wildmode=list:longest,full

set selectmode=mouse                    " select when using the mouse

set cmdheight=2                         " set the commandheight

" do not keep a backup files 
set nobackup
set nowritebackup

set textwidth=100                     " i like about 80 character width lines
set mouse=a                           " enable use of mouse
" Set 52 lines for the display, 1 for the status line.
" and other display options
if has('gui_running')

    set lines=52                          "  2 for the command line

    set columns=110                       " add columns for the Project plugin
endif
colorscheme farout

set history=50                          " keep 50 lines of command line history
    
set ruler                               " show the cursor position all the time


set showcmd                             " show (partial) commands
set incsearch                           " do incremental searches (annoying but handy);
set list                                " Show  tab characters. Visual Whitespace.
set listchars=tab:>.

set ignorecase                          " Set ignorecase on


set scs                                 " smart search (override 'ic' when pattern has uppers)
set gdefault                            " Set 'g' substitute flag on

set statusline=[%02n]\ %f\ %(\[%M%R%H]%)%=\ %4l,%02c%2V\ %P%*           " Set status line

set laststatus=2                        " Always display a status line at the bottom of the window

set shortmess=a                         " Set vim to use 'short messages'.

set joinspaces                          " I like this as it makes reading texts easier (for me, at least).
set showmatch                           " showmatch: Show the matching bracket for the last ')'?
set notildeop                           " allow tilde (~) to act as an operator -- ~w, etc.

" SWAP/BACKUP
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//

" Vertical Split Theme
hi VertSplit ctermfg=white
set fillchars+=vert:\|

"set autochdir
"}}}

" {{{                        Spell Checking
"=========================================================================
if has("spell")
  " turn spelling on by default
  set spell
  set spelllang=en,de

  " toggle spelling with F4 key
  map <F4> :set spell!<CR><Bar>:echo "Spell Check: " . strpart("OffOn", 3 * &spell, 3)<CR>


  " they were using white on white
  hi clear PmenuSel
  hi clear SpellBad
  hi PmenuSel ctermfg=black ctermbg=lightgray
  hi SpellBad cterm=underline 

  " limit it to just the top 10 items
  set sps=best,10                    

endif
"}}}

" {{{                        Omni Completion
"=========================================================================

autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

"}}}

" {{{                        Folding settings
"=========================================================================

autocmd FileType vim setlocal foldmethod=marker
autocmd FileType html,markdown,javascript,xml setlocal foldmethod=syntax

"}}}

" {{{                        Syntax Highlighting
"=========================================================================

autocmd BufNewFile,BufReadPost *.md set filetype=markdown

"}}}

"{{{Syntastics
"====================================================================================================
set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_html_checkers = ['tidy']
let g:syntastic_json_checkers = ['tidy']

let g:syntastic_javascript_closurecompiler_path = "~/.vim/closure-compiler-v20171023.jar"
let g:syntastic_javascript_eslint_args = ['--fix']

"accordingly to --fix, we had to reread the file after write
" enable autoread to reload any files from files when checktime is called and
" the file is changed
set autoread
" add an autocmd after vim started to execute checktime for *.js files on write
au VimEnter *.js au BufWritePost *.js checktime
" call checktime after systasticscheck
function! SyntasticCheckHook(errors)
  checktime
endfunction
"}}}

" {{{                        Ale-Linting
"=========================================================================


" linter settings
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1

" Put this in vimrc or a plugin file of your own.
" After this is configured, :ALEFix will try and fix your JS code with ESLint.
let g:ale_fixers = {
\   'javascript': ['prettier', 'eslint'],
\}

" Set this setting in vimrc if you want to fix files automatically on save.
" This is off by default.
let g:ale_fix_on_save = 0


" eslint_d statt eslint benutzten da schneller
let g:ale_javascript_eslint_use_global = 1
let g:ale_javascript_eslint_executable = 'eslint_d'

" different signs for warning/error
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '--'

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

let g:ale_open_list = 0

nnoremap <leader>? :ALEDetail<cr>
"}}}

"{{{ JSBeatufiy
if exists('JsBeautify') 
  map <c-f> :call JsBeautify()<cr>
  " or
  autocmd FileType javascript noremap <buffer>  <c-f> :call JsBeautify()<cr>
  " for json
  autocmd FileType json noremap <buffer> <c-f> :call JsonBeautify()<cr>
  " for jsx
  autocmd FileType jsx noremap <buffer> <c-f> :call JsxBeautify()<cr>
  " for html
  autocmd FileType html noremap <buffer> <c-f> :call HtmlBeautify()<cr>
  " for css or scss
  autocmd FileType css noremap <buffer> <c-f> :call CSSBeautify()<cr>


  ".vimrc
  autocmd FileType javascript vnoremap <buffer>  <c-f> :call RangeJsBeautify()<cr>
  autocmd FileType json vnoremap <buffer> <c-f> :call RangeJsonBeautify()<cr>
  autocmd FileType jsx vnoremap <buffer> <c-f> :call RangeJsxBeautify()<cr>
  autocmd FileType html vnoremap <buffer> <c-f> :call RangeHtmlBeautify()<cr>
  autocmd FileType css vnoremap <buffer> <c-f> :call RangeCSSBeautify()<cr>

  let g:EditorConfig_exclude_patterns = ['fugitive://.*']
endif 

"}}}

""{{{ EasyMotion
"map <Leader>l <Plug>(easymotion-lineforward)
"map <Leader>j <Plug>(easymotion-j)
"map <Leader>k <Plug>(easymotion-k)
"map <Leader>h <Plug>(easymotion-linebackward)
"
"let g:EasyMotion_startofline = 0 " keep cursor column when JK motion
"
"" Gif config
"map  / <Plug>(easymotion-sn)
"omap / <Plug>(easymotion-tn)
"
"" These `n` & `N` mappings are options. You do not have to map `n` & `N` to EasyMotion.
"" Without these mappings, `n` & `N` works fine. (These mappings just provide
"" different highlight method and have some other features )
"map  n <Plug>(easymotion-next)
"map  N <Plug>(easymotion-prev)
""}}}

" "{{{ Neocomplete
" "Note: This option must be set in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" " Disable AutoComplPop.
" let g:acp_enableAtStartup = 0
" " Use neocomplete.
" let g:neocomplete#enable_at_startup = 1
" " Use smartcase.
" let g:neocomplete#enable_smart_case = 1
" " Set minimum syntax keyword length.
" let g:neocomplete#sources#syntax#min_keyword_length = 3
"
" " Define dictionary.
" let g:neocomplete#sources#dictionary#dictionaries = {
"     \ 'default' : '',
"     \ 'vimshell' : $HOME.'/.vimshell_hist',
"     \ 'scheme' : $HOME.'/.gosh_completions'
"         \ }
"
" " Define keyword.
" if !exists('g:neocomplete#keyword_patterns')
"     let g:neocomplete#keyword_patterns = {}
" endif
" let g:neocomplete#keyword_patterns['default'] = '\h\w*'
"
" " Plugin key-mappings.
" inoremap <expr><C-g>     neocomplete#undo_completion()
" inoremap <expr><C-l>     neocomplete#complete_common_string()
"
" " Recommended key-mappings.
" " <CR>: close popup and save indent.
" inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
" function! s:my_cr_function()
"   return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
"   " For no inserting <CR> key.
"   "return pumvisible() ? "\<C-y>" : "\<CR>"
" endfunction
" " <TAB>: completion.
" inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" " <C-h>, <BS>: close popup and delete backword char.
" inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
" inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" " Close popup by <Space>.
" "inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"
"
" " AutoComplPop like behavior.
" "let g:neocomplete#enable_auto_select = 1
"
" " Shell like behavior(not recommended).
" "set completeopt+=longest
" "let g:neocomplete#enable_auto_select = 1
" "let g:neocomplete#disable_auto_complete = 1
" "inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"
"
"
"
" " Enable heavy omni completion.
" if !exists('g:neocomplete#sources#omni#input_patterns')
"   let g:neocomplete#sources#omni#input_patterns = {}
" endif
" "let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
" "let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
" "let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
"
" " For perlomni.vim setting.
" " https://github.com/c9s/perlomni.vim
" let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
" "}}}

" "{{{ Neosnippets
" "
" "Plugin key-mappings.
" " Note: It must be "imap" and "smap".  It uses <Plug> mappings.
" imap <C-k>     <Plug>(neosnippet_expand_or_jump)
" smap <C-k>     <Plug>(neosnippet_expand_or_jump)
" xmap <C-k>     <Plug>(neosnippet_expand_target)
"
" " SuperTab like snippets behavior.
" " Note: It must be "imap" and "smap".  It uses <Plug> mappings.
" imap <expr><TAB>
"  \ pumvisible() ? "\<C-n>" :
"  \ neosnippet#expandable_or_jumpable() ?
"  \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
" smap <expr><TAB> neosnippet#expandable_or_jumpable()
"  \ ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
"
"
" " For conceal markers.
" if has('conceal')
"   set conceallevel=2 concealcursor=niv
" endif
"
" " Enable snipMate compatibility feature.
" let g:neosnippet#enable_snipmate_compatibility = 1
"
" " Tell Neosnippet about the other snippets
" let g:neosnippet#snippets_directory='~/Templates/vim/snippets'
" "}}}

"{{{ Ultisnips 
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" Snippets dir
let g:UltiSnipsSnippetDirectories=["/home/svzieg/Templates/vim/snippets", "/home/svzieg/.vim/bundle/vim-snippets/UltiSnips"]


inoremap <Tab> <c-r>=UltiSnips#ExpandSnippet()<cr>
"}}}

"{{{ Vim-Javascript
"=================================================================================================================ff

let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_ngdoc = 1
let g:javascript_plugin_flow = 1

let g:javascript_conceal_function             = "ƒ"
let g:javascript_conceal_null                 = "ø"
let g:javascript_conceal_this                 = "@"
let g:javascript_conceal_return               = "⇚"
let g:javascript_conceal_undefined            = "¿"
let g:javascript_conceal_NaN                  = "ℕ"
let g:javascript_conceal_prototype            = "¶"
let g:javascript_conceal_static               = "•"
let g:javascript_conceal_super                = "Ω"
let g:javascript_conceal_arrow_function       = "⇒"
let g:javascript_conceal_noarg_arrow_function = "🞅"
let g:javascript_conceal_underscore_arrow_function = "🞅"

"}}}

" {{{                        Fast FileType Changes
"=========================================================================
command! Html set filetype=html
command! Js set filetype=javascript
command! Css set filetype=css
command! Md set filetype=markdown
"}}}

" {{{                        Bug Tracker
"=========================================================================
let g:jira_url = 'https://support.e2ebridge.com'
let g:jira_username = 'sziegler'
let g:jira_password = system('secret-tool lookup user sziegler platform support.e2ebridge.com')

" Customize
let g:unite_source_issue_jira_priority_table = {
  \ 10000: '◡', 1: '⚡', 2: 'ᛏ', 3: '●', 4: '○', 5: '▽' }

let g:unite_source_issue_jira_status_table = {
  \ 1: 'plan', 3: 'develop', 4: 'reopened', 5: 'resolved', 6: 'closed',
  \ 10000: 'feedback', 10001: 'staged', 10002: 'waiting',
  \ 10003: 'deployed', 10004: 'pending', 10008: 'review' }

let g:unite_source_issue_jira_type_table = {
  \ 1: 'bug', 2: 'feature', 3: 'task', 4: 'change', 5: 'sub-task',
  \ 6: 'epic', 7: 'story', 8: 'system', 9: 'sub-bug' }
"}}}

" {{{                        Tabularize
"=========================================================================
if exists(":Tabularize")
  nmap <leader>a= :Tabularize /=<CR>
  vmap <leader>a= :Tabularize /=<CR>
  nmap <leader>a: :Tabularize /:\zs<CR>
  vmap <leader>a: :Tabularize /:\zs<CR>
endif

" Tpopes Auto align
inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a

function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction

"}}}


