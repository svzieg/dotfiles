function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

function nmap(shortcut, command)
  map('n', shortcut, command)
end

function imap(shortcut, command)
  map('i', shortcut, command)
end


--  Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
--  which is the default
nmap("Y", "y$")
-- nmap("<C-v>", "\"+p")


function ToggleTheme()
  if vim.o.background == "dark" then
    vim.cmd("colorscheme onelight")
  else
    vim.cmd("colorscheme onedark")
  end
end


local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
-- compability to old vim config
vim.keymap.set('n', '<leader><leader>', builtin.find_files, {})
vim.keymap.set('n', '<leader>b', builtin.buffers, {})




-- defx
nmap("<F8>", ":Defx<CR>")
vim.cmd("silent! nunmap <buffer> -")
nmap("-", ":Defx `expand('%:p:h')` -search=`expand('%:p')`<CR>")
vim.cmd("autocmd FileType defx call defx_settings#defx_init()")

-- Coc Explorer
nmap("<space>e", "<Cmd>CocCommand explorer<CR>")
