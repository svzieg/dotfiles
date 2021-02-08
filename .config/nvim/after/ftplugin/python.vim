
" Neoformat
let g:neoformat_python_autopep8 = {
      \ 'exe': 'autopep8',
      \ 'args': ['%s'],
      \ 'replace': 1,
      \ 'stdin': 0, 
      \ 'env': ["DEBUG=1"], 
      \ 'valid_exit_codes': [0, 23],
      \ 'no_append': 1,
      \ }

" let g:neoformat_python_black = {
"       \ 'exe': 'black',
"       \ 'args': ['-q --fast'],
"       \ 'replace': 1,
"       \ 'stdin': 0, 
"       \ 'env': ["DEBUG=1"], 
"       \ 'valid_exit_codes': [0, 1],
"       \ 'no_append': 1,
"       \ }


let g:neoformat_enabled_python = ['black']
