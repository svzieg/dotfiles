function! myspacevim#before() abort
"  let g:neomake_enabled_html_makers = ['eslint_d']
  noremap τ l
  noremap ρ gk
  noremap ν gj
  noremap σ h


  set conceallevel=2
    
  let g:GPGFilePattern = '*.\(gpg\|asc\|pgp\)\(.wiki\)\='


  let g:vimwiki_filetypes = ['markdown']
  let g:vimwiki_folding = 'custom'
  let g:pandoc#folding#mode = 'stacked'
  let g:pandoc#modules#enabled = ['folding', 'command']

  let g:neoformat_verbose = 1

 let g:vimwiki_list = [{
	\ 'path': '~/vimwiki',
	\ 'template_path': '~/vimwiki/templates/',
	\ 'template_default': 'default',
	\ 'syntax': 'markdown',
	\ 'ext': '.md',
	\ 'path_html': '~/vimwiki/site_html/',
	\ 'custom_wiki2html': 'vimwiki_markdown',
	\ 'template_ext': '.tpl'}] 


  call SpaceVim#plugins#tasks#reg_provider(funcref('s:make_tasks'))

  augroup PythonBlack
    au!
    autocmd BufWritePre *.py execute ':Black'
  augroup END

  augroup TemplateFileType
    au!
    autocmd BufRead,BufNewFile *.template setfiletype template
  augroup END

  let g:neoformat_typescriptreact_prettier = {
        \ 'exe': 'prettier',
        \ 'args': ['--stdin', '--stdin-filepath', '"%:p"', '--parser', 'typescript'],
        \ 'stdin': 1
        \ }
  let g:neoformat_enabled_typescriptreact = ['tsfmt', 'prettier']


  " run low resource heavy autoformatter automatically
  augroup fmt
    autocmd!
    autocmd BufWritePre *.yaml Neoformat
    autocmd BufWritePre *.yml Neoformat
    autocmd BufWritePre *.json undojoin | Neoformat
    autocmd BufWritePre *.py undojoin | Neoformat
    autocmd BufWritePre *.cmd undojoin | Neoformat
    autocmd BufWritePre *.sh undojoin | Neoformat
    autocmd BufWritePre *.bash undojoin | Neoformat
    autocmd BufWritePre *.fish undojoin | Neoformat
    autocmd BufWritePre *.css undojoin | Neoformat
    autocmd BufWritePre *.html undojoin | Neoformat
    autocmd BufWritePre *.js undojoin | Neoformat
    autocmd BufWritePre *.jsx undojoin | Neoformat
    autocmd BufWritePre *.ts undojoin | Neoformat
    autocmd BufWritePre *.tsx undojoin | Neoformat
  augroup END


"  inoremap nr <ESC>

      " deoplete
    " {{{
    let g:deoplete#ignore_sources = {}
    let g:deoplete#ignore_sources._ = ['buffer', 'around']
    " }}}


    " set virtualedit=onemore             " Allow for cursor beyond last character
    " set splitright

    " open a NERDTree automatically when vim starts up if no files were specified
    " autocmd StdinReadPre * let s:std_in=1
    " autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
    " }}}


     let g:neoformat_javascript_jsbeautify = {
         \ 'exe': 'js-beautify',
         \ 'stdin': 1,
         \ }
"
    " let g:neoformat_typescript_tsfmt = {
        " \ 'exe': 'tsfmt',
            " \ 'args': ['--replace', '%:p'],
            " \ 'replace': 1,
            " \ 'stderr': 1,
        " \ }
"
    let g:neoformat_enabled_typescript = ['tsfmt', 'prettier']
    let g:neoformat_enabled_javascript = ['jsbeatify', 'prettier']


    augroup SyntaxSettings
      autocmd!
      autocmd BufNewFile,BufRead *.tsx set filetype=typescript
    augroup END


    " show all uncompliable symbols
    set listchars=tab:>-,trail:~,extends:>,precedes:<
    set list


    " javascript
    let g:tern#command = ["tern"]
    let g:tern#arguments = ["--persistent"]


    " typescript
    let g:tagbar_type_typescript = {
        \ 'ctagstype': 'typescript',
        \ 'kinds': [
          \ 'c:classes',
          \ 'n:modules',
          \ 'f:functions',
          \ 'v:variables',
          \ 'v:varlambdas',
          \ 'm:members',
          \ 'i:interfaces',
          \ 'e:enums',
          \ 's:statics',
        \ ]
    \ }


    " disable ctags
    let g:gutentags_ctags_exclude = [ "*.js", "*.jsx", "*.ts", "*.tsx", "*.css", "build", "vendor", ".git", "node_modules", "*.vim/bundle/*", "out" ]

endfunction

function! myspacevim#after() abort

  set spell spelllang=en_us,de
  set foldlevel=1
  set foldenable

  let l:vimwiki_fold_blank_lines = 0  " set to 1 to fold blank lines
  "let l:vimwiki_header_type = '#'     " set to '=' for wiki syntax
  let g:indentLine_concealcursor = ''

  let g:vimwiki_list = [{'path': '~/vimwiki/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]
  
  let g:vimwiki_ext2syntax = {'.md': 'markdown',
                  \ '.mkd': 'markdown',
                  \ '.wiki': 'media'}


  let g:UltiSnipsSnippetDirectories=['~/.SpaceVim.d/UltiSnips']
  let g:UltiSnipsEnableSnipMate="1"


  " let g:neoformat_typescriptreact_prettier = call neoformat#formatters#reacttypescript#prettier()
  " let g:neoformat_typescriptreact_tsfmt = call neoformat#formatters#reacttypescript#tsfmt()
  " let g:neoformat_typescriptreact_tslint= call neoformat#formatters#reacttypescript#tslint()
  " let g:neoformat_typescriptreact_eslint_d= call neoformat#formatters#reacttypescript#eslint_d()
  " let g:neoformat_typescriptreact_clangformat= call neoformat#formatters#reacttypescript#clangformat()
  " let g:neoformat_enabled_typescriptreact = call neoformat#formatters#reacttypescript#enabled()
endfunction

function! s:make_tasks() abort
    if filereadable('Makefile')
        let subcmd = filter(readfile('Makefile', ''), "v:val=~#'.'")
        if !empty(subcmd)
            let commands = split(subcmd[0])[1:]
            let conf = {}
            for cmd in commands
                call extend(conf, {
                            \ cmd : {
                            \ 'command': 'make',
                            \ 'args' : [cmd],
                            \ 'isDetected' : 1,
                            \ 'detectedName' : 'make:'
                            \ }
                            \ })
            endfor
            return conf
        else
            return {}
        endif
    else
        return {}
    endif
endfunction





" function! neomake#makers#ft#html#eslint() abort
"   return neomake#makers#ft#javascript#eslint()
" endfunction
"
" function! neomake#makers#ft#html#eslint_d() abort
"   return neomake#makers#ft#html#eslint()
" endfunction
"
"
