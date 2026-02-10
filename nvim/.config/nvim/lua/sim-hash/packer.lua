---- This file can be loaded by calling `lua require('plugins')` from your init.vim
return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.4',
	  -- or                            , branch = '0.1.x',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }
--  use {'nvim-telescope/telescope-ui-select.nvim' }
  use {'nvim-telescope/telescope-dap.nvim' }

-- Themes.....
--
--  use({
--	  'gruvbox-community/gruvbox',
--	  config = function()
--		  vim.cmd('let g:nvcode_termcolors=256')
--		  vim.cmd('let g:gruvbox_contrast_dark="soft"')
--		  vim.cmd('colorscheme gruvbox')
--	  end
--
--  })

-- From primegen....garbage theme...
-- use({ 'rose-pine/neovim', as = 'rose-pine' })
--


-- This is the most correct intellj light version theme, you might like this....
--use({
--    'chiendo97/intellij.vim',
--    config = function()
--        vim.cmd('set background=light')
--        vim.cmd('colorscheme intellij')
--    end
--})

--
-- This is the second  most correct intellj light version theme.
--    use({
--        'devsjc/vim-jb',
--        config = function()
--            --I didn't figure out how to do this.
--            --vim.cmd('let g:jb_color_overrides={"keyword": {"gui": "#ff00ff", "cterm": "16"}}')
--            vim.cmd('let g:jb_style="light"')
--            vim.cmd('colorscheme jb')
--        end
--
--    })

use {
  'rmagatti/auto-session',
  config = function()
    require("auto-session").setup {
      suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/"},
    }
  end
}

use({
    "AlexvZyl/nordic.nvim",
    config = function()
        vim.cmd('colorscheme nordic')
    end
})

use({
    "folke/trouble.nvim",
    config = function()
        require("trouble").setup {
            icons = false,
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    end
})

use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate'})
use('nvim-treesitter/playground')

-- make this work...
-- use("nvim-treesitter/nvim-treesitter-context")

use('theprimeagen/harpoon')
use('mbbill/undotree')
use('tpope/vim-fugitive')
use('lewis6991/gitsigns.nvim')
use('williamboman/mason.nvim')
use('williamboman/mason-lspconfig.nvim')

use{'hrsh7th/nvim-cmp'}
use('hrsh7th/cmp-nvim-lsp')
use('hrsh7th/cmp-buffer')
use('hrsh7th/cmp-path')
use('saadparwaiz1/cmp_luasnip')
use('hrsh7th/cmp-nvim-lua')
use('L3MON4D3/LuaSnip')
use('rafamadriz/friendly-snippets')

use {
    "folke/which-key.nvim",
    config = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
        require("sim-hash.whichkey").setup()
    end
}
use("folke/zen-mode.nvim")
use("eandrju/cellular-automaton.nvim")
use("laytan/cloak.nvim")

-- Debugging
use("nvim-neotest/nvim-nio")

use {
    "mfussenegger/nvim-dap",
    opt = true,
    module = { "dap" },
    requires = {
        { "rcarriga/nvim-dap-ui", module = { "dapui" } },
        "nvim-telescope/telescope-dap.nvim",
    },
    config = function()
        require("sim-hash.dap").setup()
    end,
}

use("mfussenegger/nvim-jdtls")
end)
