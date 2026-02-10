require("sim-hash.remap")
require("sim-hash.set")
require("sim-hash.util")
require("sim-hash.dap.rust")
require("sim-hash.dap.go")
require("sim-hash.whichkey")
--require("lazy_init")

-- here
--local colorscheme = "marius"
--local ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)


--vim.o.background = "dark" -- or "light" for light mode
--vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
--vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

--
--local augroup = vim.api.nvim_create_augroup
--local ThePrimeagenGroup = augroup('ThePrimeagen', {})
--
--local autocmd = vim.api.nvim_create_autocmd
--local yank_group = augroup('HighlightYank', {})
--
--function R(name)
--    require("plenary.reload").reload_module(name)
--end
--
--autocmd('TextYankPost', {
--    group = yank_group,
--    pattern = '*',
--    callback = function()
--        vim.highlight.on_yank({
--            higroup = 'IncSearch',
--            timeout = 40,
--        })
--    end,
--})
--
--autocmd({"BufWritePre"}, {
--    group = ThePrimeagenGroup,
--    pattern = "*",
--    command = [[%s/\s\+$//e]],
--})
--
--vim.g.netrw_browse_split = 0
--vim.g.netrw_banner = 0
--vim.g.netrw_winsize = 25
--
--
--
--
--
--
--
--
--
--
--
--
--
