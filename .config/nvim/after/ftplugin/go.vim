
let g:ale_linters = {'go': ['gometalinter', 'gopls', 'revive', 'govet', 'gofmt']}
let g:ale_go_gometalinter_options="--fast"
let g:ale_go_gopls_options="--remote=auto"

let g:ale_fixers = {'go': ['gofmt', 'prettier']}


call deoplete#custom#option('omni_patterns', {'go': '[^. *\t]\.\w*'})

let g:projectionist_heuristics = {
      \   "bin/*": {
      \     "bin/*": {
      \        "type": "command",
      \     },
      \   }
      \ }



let g:neomake_go_golangci_lint_exe = "golangci-lint"
let g:neomake_go_golangci_lint_args = [
      \   'run',
      \   '--out-format=line-number', 
      \   '--print-issued-lines=false',
      \   '--tests',
      \   '--concurrency=3',
      \   '--exclude-use-default=false',
      \   '-E', 'gofmt',
      \   '-E', 'golint',
      \   '-E', 'nestif',
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
