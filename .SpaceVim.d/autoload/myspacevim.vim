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
