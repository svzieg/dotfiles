
" set foldmethod=syntax
" set foldnestmax=4

let g:go_imports_autosave=0
let g:go_mod_fmt_autosave=1

call deoplete#custom#option('omni_patterns', {'go': '[^. *\t]\.\w*'})


let g:neomake_go_golangci_lint_exe = "golangci-lint"
let g:neomake_go_golangci_lint_args = [
      \   'run',
      \   '--out-format=line-number', 
      \   '--print-issued-lines=false',
      \   '--tests',
      \   '--fast',
      \   '--concurrency=3',
      \   '--exclude-use-default=false',
      \   '-E', 'gofmt',
      \   '-E', 'golint',
      \   '-E', 'nestif',
      \   '-E', 'nlreturn',
      \   '-E', 'maligned',
      \   '-E', 'goimports',
      \   '-E', 'godox',
      \   '-E', 'godot',
      \   '-E', 'unconvert',
      \   '-E', 'unparam',
      \   '-E', 'whitespace',
      \   '-E', 'tparallel',
      \   '-E', 'wrapcheck',
      \   '-E', 'wsl',
      \   '-E', 'gochecknoinits',
      \   '-E', 'gochecknoglobals',
      \ ]

let g:neomake_go_enabled_makers = [ 'go', 'golangci_lint' ]
