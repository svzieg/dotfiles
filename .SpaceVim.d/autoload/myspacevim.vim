function! myspacevim#before() abort
"  let g:neomake_enabled_html_makers = ['eslint_d']
  noremap τ l
  noremap ρ gk
  noremap ν gj
  noremap σ h


  call SpaceVim#plugins#tasks#reg_provider(funcref('s:make_tasks'))
"  inoremap nr <ESC>
endfunction

function! myspacevim#after() abort

  set spell spelllang=en_us,de
  set conceallevel=2
    
  set foldlevel=1
  set foldenable

  let l:vimwiki_fold_blank_lines = 0  " set to 1 to fold blank lines
  "let l:vimwiki_header_type = '#'     " set to '=' for wiki syntax
  let g:GPGFilePattern = '*.\(gpg\|asc\|pgp\)\(.wiki\)\='
  
  let g:indentLine_concealcursor = ''

  augroup! wiki 
    autocmd BufEnter *.wiki _enterWiki()
  augroup END

  augroup PythonBlack
    autocmd BufWritePre *.py execute ':Black'
  augroup END

endfunction

function! _enterWiki()
    setlocal foldexpr=Fold(v:lnum)
endfunction

function! Fold(lnum)
 let fold_level = strlen(matchstr(getline(a:lnum), '^' . l:vimwiki_header_type . '\+'))
 if (fold_level)
   return '>' . fold_level  " start a fold level
 endif
 if getline(a:lnum) =~? '\v^\s*$'
   if (strlen(matchstr(getline(a:lnum + 1), '^' . l:vimwiki_header_type . '\+')) > 0 && !g:vimwiki_fold_blank_lines)
     return '-1' " don't fold last blank line before header
   endif
 endif
 return '=' " return previous fold level
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
