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
"  inoremap nr <ESC>
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

  augroup PythonBlack
    autocmd BufWritePre *.py execute ':Black'
  augroup END

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
