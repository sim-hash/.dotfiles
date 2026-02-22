local ignore_filetypes_list = {
  "venv",
  "target",
  "__pycache__",
  "%.xlsx",
  "%.pdf",
  "%.odt",
}

local telescope = require('telescope')
local builtin = require('telescope.builtin')

telescope.setup({
  defaults = {
    file_ignore_patterns = ignore_filetypes_list,
  },
})


vim.keymap.set('n', '<leader>pf', builtin.find_files, {desc = "Find files"})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fs', function()
	builtin.git_status({ initial_mode = "normal" })
end, {desc = "Git status"})

vim.keymap.set('n', '<leader>gd', function()
  local base = "origin/main"
  local toplevel = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  local files = vim.fn.systemlist("git -C " .. toplevel .. " diff --name-only " .. base)
  if #files == 0 or (files[1] and files[1]:match("^fatal")) then
    vim.notify("No diff against " .. base, vim.log.levels.INFO)
    return
  end

  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')

  require('telescope.pickers').new({}, {
    prompt_title = "Diff vs " .. base,
    finder = require('telescope.finders').new_table({ results = files }),
    sorter = require('telescope.config').values.file_sorter({}),
    previewer = require('telescope.previewers').new_buffer_previewer({
      title = "Diff vs " .. base,
      get_buffer_by_name = function(_, entry)
        return entry.value
      end,
      define_preview = function(self, entry)
        require('telescope.previewers.utils').job_maker(
          { "git", "--no-pager", "diff", base, "--", entry.value },
          self.state.bufnr, {
            value = entry.value,
            bufname = self.state.bufname,
            cwd = toplevel,
            callback = function(bufnr)
              if vim.api.nvim_buf_is_valid(bufnr) then
                require('telescope.previewers.utils').regex_highlighter(bufnr, "diff")
              end
            end,
          }
        )
      end,
    }),
    attach_mappings = function(_, map)
      map({ 'n', 'i' }, '<CR>', function(prompt_bufnr)
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.cmd("DiffviewOpen " .. base .. " -- " .. entry.value)
      end)
      return true
    end,
    initial_mode = "normal",
  }):find()
end, { desc = "Diff Origin" })

--require('telescope').setup({
--  defaults = {
--    path_display = {
--      shorten = {
--        len = 3, exclude = {1, -1}
--      },
--      truncate = true
--    },
--    dynamic_preview_title = true,
--    mappings = {
--      n = {
--    	  ['<c-d>'] = require('telescope.actions').delete_buffer
--      },
--      i = {
--        ['<c-d>'] = require('telescope.actions').delete_buffer
--      },
--    },
--  },
--  extensions = {
--    fzf = {
--      fuzzy = true,                    -- false will only do exact matching
--      override_generic_sorter = true,  -- override the generic sorter
--      override_file_sorter = true,     -- override the file sorter
--      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
--                                       -- the default case_mode is "smart_case"
--    },
--  }
--})

-- require('telescope').load_extension('fzf')
-- require('telescope').load_extension('ui-select')
require('telescope').load_extension('dap')
