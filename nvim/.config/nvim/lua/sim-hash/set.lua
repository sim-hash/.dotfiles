vim.opt.clipboard="unnamedplus"
-- a lot of apps use this, like github prob remove this and try again.....
--vim.opt.scl="no"

vim.opt.guicursor = "a:blinkon100"

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true
vim.opt.scrolloff = 8

vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
vim.opt.statusline = '%F'
--set statusline+=%F


--syntax on               " enable syntax highlighting
--set termguicolors       " enable true colors
--set t_Co=256            " needed to work in the Ubuntu terminal
