let g:go_gopls_enabled = 0 " use coc for this
let g:go_gopls_options = ['-remote=auto']
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:go_referrers_mode = 'gopls'
" disable all linters as that is taken care of by coc.nvim
let g:go_diagnostics_enabled = 0
let g:go_metalinter_enabled = []

" don't jump to errors after metalinter is invoked
let g:go_jump_to_error = 0

" run go imports on file save
let g:go_fmt_command = "goimports"

" automatically highlight variable your cursor is on
let g:go_auto_sameids = 0


let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_generate_tags = 1

augroup go
  au!
  autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')
  autocmd BufEnter *.go nmap <leader>i  <Plug>(go-info)
  autocmd BufEnter *.go nmap <leader>ii  <Plug>(go-implements)
  autocmd BufEnter *.go nmap <leader>ci  <Plug>(go-describe)
  autocmd BufEnter *.go nmap <leader>cc  <Plug>(go-callers)
  autocmd BufEnter *.go nmap <leader>c  <Plug>(go-coverage-toggle)
  autocmd BufEnter *.go nmap <leader>tt <Plug>(go-test-func)
  autocmd BufEnter *.go nmap <leader>t  <Plug>(go-test)

  autocmd FileType go nmap gtj :CocCommand go.tags.add json<cr>
  autocmd FileType go nmap gty :CocCommand go.tags.add yaml<cr>
  autocmd FileType go nmap gtx :CocCommand go.tags.clear<cr>
augroup END

function! s:GoToDefinition()
  if CocAction('jumpDefinition')
    return v:true
  endif

  let ret = execute("silent! normal \<C-]>")
  if ret =~ "Error" || ret =~ "错误"
    call searchdecl(expand('<cword>'))
  endif
endfunction

nmap <silent> gd :call <SID>GoToDefinition()<CR>


nmap <leader>f :CocFix <cr>
nmap <leader>r <Plug>(coc-rename)
nmap <leader>cr <Plug>(coc-references)


nmap <C-a> <C-o>
nmap <C-d> <Plug>(coc-definition) :e

