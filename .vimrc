"NeoBundle Scripts-----------------------------
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

" Add or remove your Bundles here:

" Coding Helpers
NeoBundle 'Valloric/YouCompleteMe', {'build': {'unix': 'sh ./install.sh --tern-completer'}}
NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'klen/rope-vim'
NeoBundle 'tpope/vim-surround'
NeoBundle 'godlygeek/tabular'
"NeoBundle 'walm/jshint
NeoBundle 'vim-syntastic/syntastic'
NeoBundle 'mileszs/ack.vim'

" Web
NeoBundleLazy 'jelera/vim-javascript-syntax', {'autoload':{'filetypes':['javascript']}}
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'digitaltoad/vim-jade'
NeoBundle 'wavded/vim-stylus' 
NeoBundleLazy  'groenewege/vim-less'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'sidorares/node-vim-debugger'
NeoBundle 'moll/vim-node'
NeoBundle 'maksimr/vim-jsbeautify'
NeoBundle 'editorconfig/editorconfig-vim'

" Node
NeoBundle 'moll/vim-node'
NeoBundle 'ternjs/tern_for_vim'

" Navigation
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'majutsushi/tagbar' 
NeoBundle 'easymotion/vim-easymotion'
NeoBundle 'wincent/command-t', {
    \   'build_commands': ['make', 'ruby'],
    \   'build': {
    \      'unix': 'cd ruby/command-t/ext/command-t && { make clean; ruby extconf.rb && make }'
    \   }
\ }
NeoBundle 'mileszs/ack.vim'

" ColorSchemes and Style of vim
NeoBundle 'flazz/vim-colorschemes'
NeoBundle 'vim-airline/vim-airline'
NeoBundle 'fholgado/minibufexpl.vim'
NeoBundle 'fcpg/vim-farout'

" Required:
call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
"End NeoBundle Scripts-------------------------

set backspace=indent,eol,start          " allow backspacing over everything in insert mode


syntax on

set shiftwidth=2                        " I like 4 spaces for indenting
set tabstop=2                           " I like 4 stops
set expandtab                           " Spaces instead of tabs
set autoindent                          " Always  set auto indenting on

set selectmode=mouse                    " select when using the mouse

set cmdheight=2                         " set the commandheight

" do not keep a backup files 
set nobackup
set nowritebackup

set textwidth=78                      " i like about 80 character width lines
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

"set statusline=[%02n]\ %f\ %(\[%M%R%H]%)%=\ %4l,%02c%2V\ %P%*           " Set status line


set laststatus=2                        " Always display a status line at the bottom of the window

set shortmess=a                         " Set vim to use 'short messages'.

set joinspaces                          " I like this as it makes reading texts easier (for me, at least).
set showmatch                           " showmatch: Show the matching bracket for the last ')'?
set notildeop                           " allow tilde (~) to act as an operator -- ~w, etc.

let g:Powerline_symbols = 'fancy'

" Command-T
let g:CommandTMaxFiles=200000
let g:CommantTFileScanner='git'
set wildignore=*/.git,*/node_modules,*.swp,*.bak,*.pyc,*.class,*.jar,*.gif,*.png,*.jpg,*.node,*.log

"Syntastics
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_javascript_checkers = ['eslint']

let g:syntastic_javascript_closurecompiler_path = "~/.vim/closure-compiler-v20171023.jar"

" SWAP/BACKUP
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//

set autochdir


".vimrc
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


" Gif config
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)

let g:EasyMotion_startofline = 0 " keep cursor column when JK motion

" Gif config
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

" These `n` & `N` mappings are options. You do not have to map `n` & `N` to EasyMotion.
" Without these mappings, `n` & `N` works fine. (These mappings just provide
" different highlight method and have some other features )
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)

" POLYMER
function! CreatePolymerTemplate(name) 
    sp a:name.".html"
    vsp a:name.".js"

endfunction




