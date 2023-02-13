HOME = os.getenv("HOME")

vim.g.mapleader = '\\'
vim.g.maplocalleader = ','

--  Load the colorscheme
-- vim.o.background = 'dark'
require("onedarkpro").setup({
  colors = {
    dark = {
      bg = "#141419",
    }
  }
})

vim.cmd('colorscheme onedark')
vim.cmd([[
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif
]])

--
--  let ayucolor="light"  " for light version of theme
--  let ayucolor="mirage" " for mirage version of theme
--  let ayucolor="dark"   " for dark version of theme

--  Default Vim Settings for most usecases
--  URL: http://vim.wikia.com/wiki/Example_vimrc
--  Authors: http://vim.wikia.com/wiki/Vim_on_Freenode
--  Description: A minimal, but feature rich, example .vimrc. If you are a
--               newbie, basing your first .vimrc on this file is a good choice.
--               If you're a more advanced user, building your own .vimrc based
--               on this file is still a good idea.

-- ------------------------------------------------------------
--  Features {{{1
-- 
--  These options and commands enable some very useful features in Vim, that
--  no user should have to live without.

--  vim.opt.'nocompatible' to ward off unexpected things that your distro might
--  have made, as well as sanely revim.opt.options when re-sourcing .vimrc
vim.opt.compatible = false

--  Attempt to determine the type of a file based on its name and possibly its
--  contents. Use this to allow intelligent auto-indenting for each filetype,
--  and for plugins that are filetype specific.
vim.cmd("filetype indent plugin on")

--  Enable syntax highlighting
vim.cmd("syntax on")


-- ------------------------------------------------------------
--  Must have options {{{1
-- 
--  These are highly recommended options.

--  Vim with default settings does not allow easy switching between multiple files
--  in the same editor window. Users can use multiple split windows or multiple
--  tab pages to edit multiple files, but it is still best to enable an option to
--  allow easier switching between files.
-- 
--  One such option is the 'hidden' option, which allows you to re-use the same
--  window and switch from an unsaved buffer without saving it first. Also allows
--  you to keep an undo history for multiple files when re-using the same window
--  in this way. Note that using persistent undo also lets you undo in multiple
--  files even in the same window, but is less efficient and is actually designed
--  for keeping undo history after closing Vim entirely. Vim will complain if you
--  try to quit without saving, and swap files will keep you safe if your computer
--  crashes.
vim.opt.hidden = true

--  Note that not everyone likes working this way (with the hidden option).
--  Alternatives include using tabs or split windows instead of re-using the same
--  window as mentioned above, and/or either of the following options:
--  vim.opt.confirm
--  vim.opt.autowriteall

--  Better command-line completion
vim.opt.wildmenu = true

--  Show partial commands in the last line of the screen
vim.opt.showcmd = true

--  Highlight searches (use <C-L> to temporarily turn off highlighting; see the
--  mapping of <C-L> below)
vim.opt.hlsearch = true

--  Modelines have historically been a source of security vulnerabilities. As
--  such, it may be a good idea to disable them and use the securemodelines
--  script, <http://www.vim.org/scripts/script.php?script_id=1876>.
--  vim.opt.nomodeline


-- ------------------------------------------------------------
--  Usability options {{{1
-- 
--  These are options that users frequently vim.opt.in their .vimrc. Some of them
--  change Vim's behaviour in ways which deviate from the true Vi way, but
--  which are considered to add usability. Which, if any, of these options to
--  use is very much a personal preference, but they are harmless.

--  Do not wrap
vim.opt.wrap = false

--  Use case insensitive search, except when using capital letters
vim.opt.ignorecase = true
vim.opt.smartcase = true

--  Allow backspacing over autoindent, line breaks and start of insert action
vim.opt.backspace = "indent,eol,start"

--  When opening a new line and no filetype-specific indenting is enabled, keep
--  the same indent as the line you're currently on. Useful for READMEs, etc.
vim.opt.autoindent = true

--  Stop certain movements from always going to the first character of a line.
--  While this behaviour deviates from that of Vi, it does what most users
--  coming from other editors would expect.
vim.opt.startofline = false
--  Display the cursor position on the last line of the screen or in the status
--  line of a window
vim.opt.ruler = true

--  Always display the status line, even if only one window is displayed
vim.opt.laststatus = 2

--  Instead of failing a command because of unsaved changes, instead raise a
--  dialogue asking if you wish to save changed files.
vim.opt.confirm = true

--  Use visual bell instead of beeping when doing something wrong
vim.opt.visualbell = true

--  And revim.opt.the terminal code for the visual bell. If visualbell is set, and
--  this line is also included, vim will neither flash nor beep. If visualbell
--  is unset, this does nothing.
-- vim.opt.t_vb = ""

--  Enable use of the mouse for all modes
vim.opt.mouse = "a"

--  vim.opt.the command window height to 2 lines, to avoid many cases of having to
--  "press <Enter> to continue"
vim.opt.cmdheight = 2

--  Display line numbers on the left
vim.opt.number = true

--  Quickly time out on keycodes, but never time out on mappings
vim.opt.timeout = false 
vim.opt.ttimeout = true 
vim.opt.ttimeoutlen = 200

--  Use <F11> to toggle between 'paste' and 'nopaste'
vim.opt.pastetoggle = "<F11>"


-- ------------------------------------------------------------
--  Indentation options {{{1
-- 
--  Indentation settings according to personal preference.

--  Indentation settings for using 4 spaces instead of tabs.
--  Do not change 'tabstop' from its default value of 8 with this setup.
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

--  Indentation settings for using hard tabs for indent. Display tabs as
--  four characters wide.
vim.opt.tabstop = 2


-- ------------------------------------------------------------
--  Mappings {{{1
-- 
--  Useful mappings


--  Map <C-L> (redraw screen) to also turn off search highlighting until the
--  next search
--  nnoremap <C-L> :nohl<CR><C-L>

-- ------------------------------------------------------------


-- Only show cursorline in the current window and in normal mode.
vim.cmd([[
  augroup cline
      au!
      au WinLeave * set nocursorline
      au WinEnter * set cursorline
      au InsertEnter * set nocursorline
      au InsertLeave * set cursorline
  augroup END

  function! LightlineGitBlame() abort
    let blame = get(b:, 'coc_git_blame', '')
    return winwidth(0) > 120 ? blame : ''
  endfunction

]])

-- disable Line-Numbers on terminal windows
vim.cmd("autocmd TermOpen * setlocal nonumber norelativenumber")
vim.cmd("set title")

-- Neovide Configuration
if vim.g.neovide then
  vim.g.neovide_cursor_animation_length=0
end

--  Lightline Configuration 
vim.g.lightline = {
       colorscheme = 'tokyonight',
       active =  {
           left= { 
                     { 'mode', 'paste' },
                     { 'issues', 'gitbranch', 'readonly', 'filename', 'modified' },
                     {  'coc_info', 'coc_hints', 'coc_errors', 'coc_warnings', 'coc_ok' }, { 'coc_status'  }
                   },
           right = { 
                     { 'lineinfo', 'percent' },
                     { 'filetype', 'fileencoding'}, 
                     { 'blame' },
                   }
         },
         component_function =  {
             gitbranch = 'FugitiveHead',
             blame =  'LightlineGitBlame',
           },
        }

--  \   'issues' : 'NeomakeIndicator'

--  run low resource heavy autoformatter automatically
-- augroup fmt
--   vim.opt.smartindent
--   autocmd!
--   autocmd BufRead,BufWritePre *.vim  call init#intent()
--   autocmd BufRead,BufWritePre *.yaml Neoformat
--   autocmd BufRead,BufWritePre *.yml Neoformat
--   autocmd BufRead,BufWritePre *.go undojoin | Neoformat
--   autocmd BufRead,BufWritePre *.json undojoin | Neoformat
--   autocmd BufRead,BufWritePre *.py undojoin | Neoformat
--   autocmd BufRead,BufWritePre *.cmd undojoin | Neoformat
--   autocmd BufRead,BufWritePre *.sh undojoin | Neoformat
--   autocmd BufRead,BufWritePre *.bash undojoin | Neoformat
--   autocmd BufRead,BufWritePre *.fish undojoin | Neoformat
--   autocmd BufRead,BufWritePre *.css undojoin | Neoformat
--   "autocmd BufRead,BufWritePre *.html undojoin | Neoformat
--   autocmd BufRead,BufWritePre *.rb undojoin | Neoformat
--   autocmd BufRead,BufWritePre *.js  Neoformat
--   autocmd BufRead,BufWritePre *.jsx  Neoformat
--   autocmd BufRead,BufWritePre *.ts Neoformat
--   autocmd BufRead,BufWritePre *.tsx  Neoformat
-- augroup END



--  helpres for autoclosing
--  inoremap (. (<CR>)<C-c>O
--  inoremap (. (<CR>)<C-c>O
--  inoremap {. {<CR>}<C-c>O
--  inoremap (; (<CR>);<C-c>O
--  inoremap (, (<CR>),<C-c>O
--  inoremap {; {<CR>};<C-c>O
--  inoremap {, {<CR>},<C-c>O
--  inoremap [; [<CR>];<C-c>O
--  inoremap [, [<CR>],<C-c>O

-- auto close {
--  function! s:CloseBracket()
--    let line = getline('.')
--    if line =~# '^\s*\(struct\|class\|enum\) '
--      return "{\<Enter>};\<Esc>O"
--    elseif searchpair('(', '', ')', 'bmn', '', line('.'))
--      " Probably inside a function call. Close it off.
--      return "{\<Enter>});\<Esc>O"
--    else
--      return "{\<Enter>}\<Esc>O"
--    endif
--  endfunction
--  inoremap <expr> {<Enter> <SID>CloseBracket()



--  ==========================================================================
--  Coc Settings
--  ==========================================================================

--  Some servers have issues with backup files, see #649.
vim.opt.backup = false
vim.opt.writebackup = false

--  Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
--  delays and poor user experience.
vim.opt.updatetime = 300

--  Always show the signcolumn, otherwise it would shift the text each time
--  diagnostics appear/become resolved.
vim.opt.signcolumn = "yes"
