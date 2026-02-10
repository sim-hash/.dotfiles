require('gitsigns').setup({
    on_attach = function(bufnr)
        local gs = require('gitsigns')
        local opts = function(desc)
            return { buffer = bufnr, desc = desc }
        end

        -- Navigation between hunks
        vim.keymap.set('n', ']h', gs.next_hunk, opts("Next hunk"))
        vim.keymap.set('n', '[h', gs.prev_hunk, opts("Previous hunk"))

        -- Preview the hunk inline
        vim.keymap.set('n', '<leader>hp', gs.preview_hunk, opts("Preview hunk"))

        -- Stage / unstage / reset hunks
        vim.keymap.set('n', '<leader>hs', gs.stage_hunk, opts("Stage hunk"))
        vim.keymap.set('n', '<leader>hr', gs.reset_hunk, opts("Reset hunk"))
        vim.keymap.set('n', '<leader>hu', gs.undo_stage_hunk, opts("Undo stage hunk"))
    end
})
