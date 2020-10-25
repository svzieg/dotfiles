
let g:ale_linters = {'javascript': ['prettier', 'eslint']}

let g:ale_fixers = {'javascript': ['prettier', 'eslint']}
let g:ale_fix_on_save = 1

let g:projectionist_heuristics = {
      \   "bin/*": {
      \     "bin/*": {
      \        "type": "command",
      \     },
      \   }
      \ }
