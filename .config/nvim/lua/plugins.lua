local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()


return require('packer').startup(function()
    use 'wbthomason/packer.nvim'

--  Make sure you use single quotes
use 'tpope/vim-sensible'

--  Status-Bar
use {
  'nvim-lualine/lualine.nvim',
  requires = { 'kyazdani42/nvim-web-devicons', opt = true }
}

--  Database connection
use 'tpope/vim-dadbod'

--  Project settings

use { 'Shougo/defx.nvim', config = 'vim.cmd [[UpdateRemotePlugins]]'}
use 'tpope/vim-dispatch'
use 'tpope/vim-vinegar'
use 'tpope/vim-dotenv'
use 'tpope/vim-fugitive'
use 'tpope/vim-repeat'
use 'psliwka/vim-smoothie' -- smooth scrooling
use 'mhinz/vim-startify' -- fancy start
-- use 'https://github.com/puremourning/vimspector'
-- use 'neomake/neomake' --  can be removed in favor of coc
use 'sbdchd/neoformat'
use 'preservim/tagbar'

use { 'neoclide/coc.nvim', branch = 'release' }
-- use 'neoclide/coc.nvim', { 'branch': 'master', 'do': 'yarn install --frozen-lockfile' }
-- use 'fatih/vim-go'

-- use 'Shougo/defx.nvim', { 'do': ':UpdateRemoteuseins' }

-- use 'ldelossa/nvim-ide'
use { 'nvim-telescope/telescope.nvim', requires = {
  {'nvim-lua/popup.nvim'}, 
  {'nvim-lua/plenary.nvim'}, 
  {'BurntSushi/ripgrep'}, 
  {'nvim-tree/nvim-web-devicons'},
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			run = "make",
		},
		{ "nvim-telescope/telescope-project.nvim" },
		{ "nvim-telescope/telescope-ui-select.nvim" },
}}

use 'rcarriga/nvim-notify'
use "dnlhc/glance.nvim"

use {
  'lewis6991/gitsigns.nvim',
  config = function()
    require('gitsigns').setup()
  end
}

use 'mfussenegger/nvim-dap'
use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }

--  coc plugins:
--  use 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
--  use 'iamcco/coc-angular', {'do': 'yarn install --frozen-lockfile  --ignore-engines'}
--  use 'neoclide/coc-css', {'do': 'yarn install --frozen-lockfile'}
--  use 'antonk52/coc-cssmodules', {'do': 'npm ci'}
--  use 'neoclide/coc-emmet', {'do': 'yarn install --frozen-lockfile'}
--  use 'neoclide/coc-eslint', {'do': 'yarn install --frozen-lockfile'}
--  use 'weirongxu/coc-explorer', {'do': 'yarn install --frozen-lockfile'}
--  use 'josa42/coc-go', {'do': 'yarn install --frozen-lockfile'}
--  use 'felippepuhle/coc-graphql', {'do': 'yarn install --frozen-lockfile'}
--  use 'neoclide/coc-highlight', {'do': 'yarn install --frozen-lockfile'}
--  use 'neoclide/coc-html', {'do': 'yarn install --frozen-lockfile'}
--  use 'yaegassy/coc-htmlhint', {'do': 'yarn install --frozen-lockfile'}
--   use 'yaegassy/coc-html-css-support', {'do': 'yarn install --frozen-lockfile'}
--  use 'neoclide/coc-java', {'do': 'yarn install --frozen-lockfile'}
--  use 'pappasam/coc-jedi', {'do': 'yarn install --frozen-lockfile'}
--  use 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
--  use 'fannheyward/coc-markdownlint', {'do': 'yarn install --frozen-lockfile'}
--  use 'josa42/coc-sh', {'do': 'yarn install --frozen-lockfile'}
--  use 'neoclide/coc-snippets', {'do': 'yarn install --frozen-lockfile'}
--  use 'neoclide/coc-solargraph', {'do': 'yarn install --frozen-lockfile'}
--  use 'fannheyward/coc-sql', {'do': 'yarn install --frozen-lockfile'}
--  use 'neoclide/coc-yaml', {'do': 'yarn install --frozen-lockfile'}
--  use 'neoclide/coc-prettier', {'do': 'yarn install --frozen-lockfile'}


--  General Text Settings
use 'tpope/vim-surround'
use 'tpope/vim-commentary'

--  css 

--  markdown
--  use 'vimwiki/vimwiki'


--  Golang
--  use 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

--  Typescript and Javascript
use 'HerringtonDarkholme/yats.vim'
use { 'mhartington/nvim-typescript', run = './install.sh' }


--  Syntax Highlight
use "olimorris/onedarkpro.nvim"
use 'skammer/vim-css-color'

end)

