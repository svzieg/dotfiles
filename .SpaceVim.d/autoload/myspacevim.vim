function! myspacevim#before() abort
  let g:neomake_enabled_html_makers = ['eslint_d']
  noremap τ l
  noremap ρ gk
  noremap ν gj
  noremap σ h





"  inoremap nr <ESC>
endfunction

function! myspacevim#after() abort

  set spell spelllang=en_us,de

  augroup PythonBlack
    autocmd BufWritePre *.py execute ':Black'
  augroup END

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
