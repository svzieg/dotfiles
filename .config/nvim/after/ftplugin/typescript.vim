let g:ale_linters = {'typescript': ['prettier', 'tslint']}

let g:ale_fixers = {'typescript': ['prettier', 'tslint']}
let g:ale_fix_on_save = 1

let g:projectionist_heuristics = {
      \   "bin/*": {
      \     "bin/*": {
      \        "type": "command",
      \     },
      \   }
      \ }
