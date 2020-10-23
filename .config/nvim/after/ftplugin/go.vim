
let g:ale_linters = {'go': ['gometalinter', 'gopls', 'revive', 'govet', 'gofmt']}
let g:ale_go_gometalinter_options="--fast"
let g:ale_go_gopls_options="--remote=auto"



let g:ale_fixers = {'go': ['gofmt', 'prettier']}
let g:ale_fix_on_save = 1

let g:projectionist_heuristics = {
      \   "bin/*": {
      \     "bin/*": {
      \        "type": "command",
      \     },
      \   }
      \ }
