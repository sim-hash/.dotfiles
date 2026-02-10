local M = {}

local function setup_whichkey()
    local wk = require("which-key")

    -- Setup configuration
    wk.setup({
        preset = "modern",
        win = {
            border = "single",
        },
    })

    -- Normal mode keymaps
    wk.add({
        { "<leader>w", "<cmd>update!<CR>", desc = "Save" },
        { "<leader>q", "<cmd>lua require('utils').quit()<CR>", desc = "Quit" },
        { "<leader>1", "<Cmd>lua require('harpoon.term').gotoTerminal(1)<Cr>", desc = "Terminal 1" },
        { "<leader>2", "<Cmd>lua require('harpoon.term').gotoTerminal(2)<Cr>", desc = "Terminal 2" },
        { "<leader>3", "<Cmd>lua require('harpoon.term').sendCommand(1,1)<Cr>", desc = "Command 1" },
        { "<leader>4", "<Cmd>lua require('harpoon.term').sendCommand(1,2)<Cr>", desc = "Command 2" },

        -- Attempt
        { "<leader>a", group = "Attempt" },
        { "<leader>an", "<Cmd>lua require('attempt').new_select()<Cr>", desc = "New Select" },
        { "<leader>ai", "<Cmd>lua require('attempt').new_input_ext()<Cr>", desc = "New Input Extension" },
        { "<leader>ar", "<Cmd>lua require('attempt').run()<Cr>", desc = "Run" },
        { "<leader>ad", "<Cmd>lua require('attempt').delete_buf()<Cr>", desc = "Delete Buffer" },
        { "<leader>ac", "<Cmd>lua require('attempt').rename_buf()<Cr>", desc = "Rename Buffer" },
        { "<leader>as", "<Cmd>Telescope attempt<Cr>", desc = "Search" },

        -- Buffer
        { "<leader>b", group = "Buffer" },
        { "<leader>bc", "<Cmd>BDelete this<Cr>", desc = "Close Buffer" },
        { "<leader>bf", "<Cmd>bdelete!<Cr>", desc = "Force Close Buffer" },
        { "<leader>bD", "<Cmd>BWipeout other<Cr>", desc = "Delete All Buffers" },
        { "<leader>bb", "<Cmd>BufferLinePick<Cr>", desc = "Pick a Buffer" },
        { "<leader>bp", "<Cmd>BufferLinePickClose<Cr>", desc = "Pick & Close a Buffer" },
        { "<leader>bm", "<Cmd>JABSOpen<Cr>", desc = "Menu" },

        -- Code
        { "<leader>c", group = "Code" },
        { "<leader>cg", "<cmd>Neogen func<Cr>", desc = "Func Doc" },
        { "<leader>cG", "<cmd>Neogen class<Cr>", desc = "Class Doc" },
        { "<leader>cd", "<cmd>DogeGenerate<Cr>", desc = "Generate Doc" },
        { "<leader>co", "<cmd>Telescope aerial<Cr>", desc = "Outline" },
        { "<leader>cT", "<cmd>TodoTelescope<Cr>", desc = "TODO" },
        { "<leader>cx", group = "Swap Next" },
        { "<leader>cxf", desc = "Function" },
        { "<leader>cxp", desc = "Parameter" },
        { "<leader>cxc", desc = "Class" },
        { "<leader>cX", group = "Swap Previous" },
        { "<leader>cXf", desc = "Function" },
        { "<leader>cXp", desc = "Parameter" },
        { "<leader>cXc", desc = "Class" },

        -- DAP
        { "<leader>d", group = "DAP" },
        { "<leader>da", "<cmd>Telescope dap list_breakpoints<cr>", desc = "List breakpoints" },
        { "<leader>dR", "<cmd>lua require'dap'.run_to_cursor()<cr>", desc = "Run to Cursor" },
        { "<leader>dE", "<cmd>lua require'dapui'.eval(vim.fn.input '[Expression] > ')<cr>", desc = "Evaluate Input" },
        { "<leader>dC", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input '[Condition] > ')<cr>", desc = "Conditional Breakpoint" },
        { "<leader>dU", "<cmd>lua require'dapui'.toggle()<cr>", desc = "Toggle UI" },
        { "<leader>db", "<cmd>lua require'dap'.step_back()<cr>", desc = "Step Back" },
        { "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", desc = "Continue" },
        { "<leader>dd", "<cmd>lua require'dap'.disconnect()<cr>", desc = "Disconnect" },
        { "<leader>de", "<cmd>lua require'dapui'.eval()<cr>", desc = "Evaluate" },
        { "<leader>df", "<cmd>Telescope dap frames<cr>", desc = "List frames" },
        { "<leader>dg", "<cmd>lua require'dap'.session()<cr>", desc = "Get Session" },
        { "<leader>dh", "<cmd>lua require'dap.ui.widgets'.hover()<cr>", desc = "Hover Variables" },
        { "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", desc = "Run last" },
        { "<leader>dL", "<cmd>Telescope dap commands<cr>", desc = "List commands" },
        { "<leader>dn", "<cmd>lua require('dap').clear_breakpoints()<cr>", desc = "Clear breakpoints" },
        { "<leader>dS", function() local widgets=require"dap.ui.widgets";widgets.centered_float(widgets.scopes) end, desc = "Scopes" },
        { "<leader>di", "<cmd>lua require'dap'.step_into()<cr>", desc = "Step Into" },
        { "<leader>do", "<cmd>lua require'dap'.step_over()<cr>", desc = "Step Over" },
        { "<leader>dp", "<cmd>lua require'dap'.pause.toggle()<cr>", desc = "Pause" },
        { "<leader>dq", "<cmd>lua require'dap'.close()<cr>", desc = "Quit" },
        { "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", desc = "Open/Toggle Repl" },
        { "<leader>dt", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", desc = "Toggle Breakpoint" },
        { "<leader>dx", "<cmd>lua require'dap'.terminate()<cr>", desc = "Terminate" },
        { "<leader>du", "<cmd>lua require'dap'.step_out()<cr>", desc = "Step Out" },

        -- Database
        { "<leader>D", group = "Database" },
        { "<leader>Du", "<Cmd>DBUIToggle<Cr>", desc = "Toggle UI" },
        { "<leader>Df", "<Cmd>DBUIFindBuffer<Cr>", desc = "Find buffer" },
        { "<leader>Dr", "<Cmd>DBUIRenameBuffer<Cr>", desc = "Rename buffer" },
        { "<leader>Dq", "<Cmd>DBUILastQueryInfo<Cr>", desc = "Last query info" },

        -- Find
        { "<leader>f", group = "Find" },
        { "<leader>ff", "<cmd>lua require('utils.finder').find_files()<cr>", desc = "Files" },
        { "<leader>fd", "<cmd>lua require('utils.finder').find_dotfiles()<cr>", desc = "Dotfiles" },
        { "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>", desc = "Buffers" },
        { "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>", desc = "Help" },
        { "<leader>fm", "<cmd>lua require('telescope.builtin').marks()<cr>", desc = "Marks" },
        { "<leader>fo", "<cmd>lua require('telescope.builtin').oldfiles()<cr>", desc = "Old Files" },
        { "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", desc = "Live Grep" },
        { "<leader>fc", "<cmd>lua require('telescope.builtin').commands()<cr>", desc = "Commands" },
        { "<leader>fr", "<cmd>lua require'telescope'.extensions.file_browser.file_browser()<cr>", desc = "File Browser" },
        { "<leader>fw", "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>", desc = "Current Buffer" },
        { "<leader>fe", "<cmd>NvimTreeToggle<cr>", desc = "Explorer" },

        -- Git
        { "<leader>g", group = "Git" },
        { "<leader>gb", "<cmd>GitBlameToggle<CR>", desc = "Blame" },
        { "<leader>gc", "<cmd>lua require('utils.term').git_commit_toggle()<CR>", desc = "Conventional Commits" },
        { "<leader>gp", "<cmd>Git push<CR>", desc = "Push" },
        { "<leader>gs", "<cmd>lua require('neogit').open()<CR>", desc = "Status - Neogit" },
        { "<leader>gS", "<cmd>Git<CR>", desc = "Status - Fugitive" },
        { "<leader>gy", "<cmd>lua require'gitlinker'.get_buf_range_url('n', {action_callback = require'gitlinker.actions'.open_in_browser})<cr>", desc = "Link" },
        { "<leader>gg", "<cmd>lua require('telescope').extensions.gh.gist()<CR>", desc = "Gist" },
        { "<leader>gz", "<cmd>lua require('utils.term').git_client_toggle()<CR>", desc = "Git TUI" },
        { "<leader>gh", group = "Hunk" },
        { "<leader>gt", group = "Toggle" },
        { "<leader>gx", "<cmd>lua require('telescope.builtin').git_branches()<cr>", desc = "Switch Branch" },

        -- Overseer
        { "<leader>o", group = "Overseer" },
        { "<leader>oC", "<cmd>OverseerClose<cr>", desc = "OverseerClose" },
        { "<leader>oa", "<cmd>OverseerTaskAction<cr>", desc = "OverseerTaskAction" },
        { "<leader>ob", "<cmd>OverseerBuild<cr>", desc = "OverseerBuild" },
        { "<leader>oc", "<cmd>OverseerRunCmd<cr>", desc = "OverseerRunCmd" },
        { "<leader>od", "<cmd>OverseerDeleteBundle<cr>", desc = "OverseerDeleteBundle" },
        { "<leader>ol", "<cmd>OverseerLoadBundle<cr>", desc = "OverseerLoadBundle" },
        { "<leader>oo", "<cmd>OverseerOpen!<cr>", desc = "OverseerOpen" },
        { "<leader>oq", "<cmd>OverseerQuickAction<cr>", desc = "OverseerQuickAction" },
        { "<leader>or", "<cmd>OverseerRun<cr>", desc = "OverseerRun" },
        { "<leader>os", "<cmd>OverseerSaveBundle<cr>", desc = "OverseerSaveBundle" },
        { "<leader>ot", "<cmd>OverseerToggle!<cr>", desc = "OverseerToggle" },

        -- Refactor
        { "<leader>r", group = "Refactor" },
        { "<leader>ri", [[<cmd>lua require('refactoring').refactor('Inline Variable')<cr>]], desc = "Inline Variable" },
        { "<leader>rb", [[<cmd>lua require('refactoring').refactor('Exract Block')<cr>]], desc = "Extract Block" },
        { "<leader>rB", [[<cmd>lua require('refactoring').refactor('Exract Block To File')<cr>]], desc = "Extract Block to File" },
        { "<leader>rP", [[<cmd>lua require('refactoring').debug.printf({below = false})<cr>]], desc = "Debug Print" },
        { "<leader>rp", [[<cmd>lua require('refactoring').debug.print_var({normal = true})<cr>]], desc = "Debug Print Variable" },
        { "<leader>rc", [[<cmd>lua require('refactoring').debug.cleanup({})<cr>]], desc = "Debug Cleanup" },

        -- Search
        { "<leader>s", group = "Search" },
        { "<leader>so", [[ <Esc><Cmd>lua require('spectre').open()<CR>]], desc = "Open" },
        { "<leader>sc", [[ <Esc><Cmd>lua require('utils.cht').cht_input()<CR>]], desc = "cht.sh" },
        { "<leader>sr", [[ <Esc><Cmd>lua require('utils.term').rust_book()<CR>]], desc = "Rust Book" },
        { "<leader>ss", [[ <Esc><Cmd>lua require('utils.term').so()<CR>]], desc = "Stack Overflow" },
        { "<leader>sw", [[ <Esc><Cmd>lua require("telescope").extensions.arecibo.websearch()<CR>]], desc = "Web" },

        -- Test
        { "<leader>t", group = "Test" },
        { "<leader>ta", "<cmd>lua require('neotest').run.attach()<cr>", desc = "Attach" },
        { "<leader>tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", desc = "Run File" },
        { "<leader>tF", "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>", desc = "Debug File" },
        { "<leader>tl", "<cmd>lua require('neotest').run.run_last()<cr>", desc = "Run Last" },
        { "<leader>tL", "<cmd>lua require('neotest').run.run_last({ strategy = 'dap' })<cr>", desc = "Debug Last" },
        { "<leader>tn", "<cmd>lua require('neotest').run.run()<cr>", desc = "Run Nearest" },
        { "<leader>tN", "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", desc = "Debug Nearest" },
        { "<leader>to", "<cmd>lua require('neotest').output.open({ enter = true })<cr>", desc = "Output" },
        { "<leader>tS", "<cmd>lua require('neotest').run.stop()<cr>", desc = "Stop" },
        { "<leader>ts", "<cmd>lua require('neotest').summary.toggle()<cr>", desc = "Summary" },
        { "<leader>tp", "<Plug>PlenaryTestFile", desc = "PlenaryTestFile" },
        { "<leader>tv", "<cmd>TestVisit<cr>", desc = "Visit" },
        { "<leader>tx", "<cmd>TestSuite<cr>", desc = "Suite" },
        { "<leader>tt", group = "Test" },
        { "<leader>ttl", "<cmd>TestLast<cr>", desc = "Run Last" },
        { "<leader>ttn", "<cmd>TestNearest<cr>", desc = "Run Nearest" },

        -- Vimspector
        { "<leader>v", group = "Vimspector" },
        { "<leader>vG", "<cmd>lua require('config.vimspector').generate_debug_profile()<cr>", desc = "Generate Debug Profile" },
        { "<leader>vI", "<cmd>VimspectorInstall<cr>", desc = "Install" },
        { "<leader>vU", "<cmd>VimspectorUpdate<cr>", desc = "Update" },
        { "<leader>vR", "<cmd>call vimspector#RunToCursor()<cr>", desc = "Run to Cursor" },
        { "<leader>vc", "<cmd>call vimspector#Continue()<cr>", desc = "Continue" },
        { "<leader>vi", "<cmd>call vimspector#StepInto()<cr>", desc = "Step Into" },
        { "<leader>vo", "<cmd>call vimspector#StepOver()<cr>", desc = "Step Over" },
        { "<leader>vs", "<cmd>call vimspector#Launch()<cr>", desc = "Start" },
        { "<leader>vt", "<cmd>call vimspector#ToggleBreakpoint()<cr>", desc = "Toggle Breakpoint" },
        { "<leader>vu", "<cmd>call vimspector#StepOut()<cr>", desc = "Step Out" },
        { "<leader>vS", "<cmd>call vimspector#Stop()<cr>", desc = "Stop" },
        { "<leader>vr", "<cmd>call vimspector#Restart()<cr>", desc = "Restart" },
        { "<leader>vx", "<cmd>VimspectorReset<cr>", desc = "Reset" },
        { "<leader>vH", "<cmd>lua require('config.vimspector').toggle_human_mode()<cr>", desc = "Toggle HUMAN mode" },

        -- External
        { "<leader>x", group = "External" },
        { "<leader>xd", "<cmd>lua require('utils.term').docker_client_toggle()<CR>", desc = "Docker" },
        { "<leader>xt", "<cmd>lua require('utils.term').docker_ctop_toggle()<CR>", desc = "Docker - ctop" },
        { "<leader>xy", "<cmd>lua require('utils.term').docker_dockly_toggle()<CR>", desc = "Docker - dockly" },
        { "<leader>xp", "<cmd>lua require('utils.term').project_info_toggle()<CR>", desc = "Project Info" },
        { "<leader>xs", "<cmd>lua require('utils.term').system_info_toggle()<CR>", desc = "System Info" },
        { "<leader>xc", "<cmd>lua require('utils.term').cht()<CR>", desc = "Cheatsheet" },
        { "<leader>xi", "<cmd>lua require('utils.term').interactive_cheatsheet_toggle()<CR>", desc = "Interactive Cheatsheet" },

        -- System
        { "<leader>z", group = "System" },
        { "<leader>zc", "<cmd>Telescope neoclip<cr>", desc = "Clipboard" },
        { "<leader>zd", "<cmd>DiffviewOpen<cr>", desc = "Diff View Open" },
        { "<leader>zD", "<cmd>DiffviewClose<cr>", desc = "Diff View Close" },
        { "<leader>zi", "<cmd>PackerInstall<cr>", desc = "Install" },
        { "<leader>zm", "<cmd>lua require('telescope').extensions.macroscope.default()<cr>", desc = "Macros" },
        { "<leader>zp", "<cmd>PackerProfile<cr>", desc = "Profile" },
        { "<leader>zs", "<cmd>PackerSync<cr>", desc = "Sync" },
        { "<leader>zS", "<cmd>PackerStatus<cr>", desc = "Status" },
        { "<leader>zu", "<cmd>PackerUpdate<cr>", desc = "Update" },
        { "<leader>zx", "<cmd>Telescope cder<cr>", desc = "Change Directory" },
        { "<leader>ze", "!!$SHELL<CR>", desc = "Execute line" },
        { "<leader>zW", "<cmd>lua require('utils.session').toggle_session()<cr>", desc = "Toggle Workspace Saving" },
        { "<leader>zw", "<cmd>lua require('utils.session').list_session()<cr>", desc = "Restore Workspace" },
        { "<leader>zz", "<cmd>lua require'telescope'.extensions.zoxide.list{}<cr>", desc = "Zoxide" },
    })

    -- Visual mode keymaps
    wk.add({
        { "<leader>de", "<cmd>lua require'dapui'.eval()<cr>", desc = "Evaluate", mode = "v" },

        { "<leader>g", group = "Git", mode = "v" },
        { "<leader>gy", "<cmd>lua require'gitlinker'.get_buf_range_url('v', {action_callback = require'gitlinker.actions'.open_in_browser})<cr>", desc = "Link", mode = "v" },

        { "<leader>r", group = "Refactor", mode = "v" },
        { "<leader>rf", [[<cmd>lua require('refactoring').refactor('Extract Function')<cr>]], desc = "Extract Function", mode = "v" },
        { "<leader>rF", [[ <cmd>lua require('refactoring').refactor('Extract Function to File')<cr>]], desc = "Extract Function to File", mode = "v" },
        { "<leader>rv", [[<cmd>lua require('refactoring').refactor('Extract Variable')<cr>]], desc = "Extract Variable", mode = "v" },
        { "<leader>ri", [[<cmd>lua require('refactoring').refactor('Inline Variable')<cr>]], desc = "Inline Variable", mode = "v" },
        { "<leader>rr", [[<cmd>lua require('telescope').extensions.refactoring.refactors()<cr>]], desc = "Refactor", mode = "v" },
        { "<leader>rd", [[<cmd>lua require('refactoring').debug.print_var({})<cr>]], desc = "Debug Print Var", mode = "v" },
    })
end

local function setup_filetype_keymaps()
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function()
            vim.schedule(function()
                local wk = require("which-key")
                local bufnr = vim.api.nvim_get_current_buf()
                local ft = vim.bo[bufnr].filetype
                local fname = vim.fn.expand("%:p:t")

                if ft == "python" then
                    wk.add({
                        { "<leader>c", group = "Code", buffer = bufnr },
                        { "<leader>ci", "<cmd>cexpr system('refurb --quiet ' . shellescape(expand('%'))) | copen<cr>", desc = "Inspect", buffer = bufnr },
                        { "<leader>cr", "<cmd>update<cr><cmd>lua require('utils.term').open_term([[python3 ]] .. vim.fn.shellescape(vim.fn.getreg('%'), 1), {direction = 'float'})<cr>", desc = "Run", buffer = bufnr },
                        { "<leader>cm", "<cmd>TermExec cmd='nodemon -e py %'<cr>", desc = "Monitor", buffer = bufnr },
                    })
                elseif ft == "lua" then
                    wk.add({
                        { "<leader>c", group = "Code", buffer = bufnr },
                        { "<leader>cr", "<cmd>luafile %<cr>", desc = "Run", buffer = bufnr },
                    })
                elseif ft == "rust" then
                    wk.add({
                        { "<leader>c", group = "Code", buffer = bufnr },
                        { "<leader>cr", "<cmd>execute 'Cargo run' | startinsert<cr>", desc = "Run", buffer = bufnr },
                        { "<leader>cD", "<cmd>RustDebuggables<cr>", desc = "Debuggables", buffer = bufnr },
                        { "<leader>ch", "<cmd>RustHoverActions<cr>", desc = "Hover Actions", buffer = bufnr },
                        { "<leader>cR", "<cmd>RustRunnables<cr>", desc = "Runnables", buffer = bufnr },
                    })
                elseif ft == "go" then
                    wk.add({
                        { "<leader>c", group = "Code", buffer = bufnr },
                        { "<leader>cr", "<cmd>GoRun<cr>", desc = "Run", buffer = bufnr },
                    })
                elseif ft == "typescript" or ft == "typescriptreact" or ft == "javascript" or ft == "javascriptreact" then
                    wk.add({
                        { "<leader>c", group = "Code", buffer = bufnr },
                        { "<leader>co", "<cmd>TypescriptOrganizeImports<cr>", desc = "Organize Imports", buffer = bufnr },
                        { "<leader>cr", "<cmd>TypescriptRenameFile<cr>", desc = "Rename File", buffer = bufnr },
                        { "<leader>ci", "<cmd>TypescriptAddMissingImports<cr>", desc = "Import Missing", buffer = bufnr },
                        { "<leader>cF", "<cmd>TypescriptFixAll<cr>", desc = "Fix All", buffer = bufnr },
                        { "<leader>cu", "<cmd>TypescriptRemoveUnused<cr>", desc = "Remove Unused", buffer = bufnr },
                        { "<leader>cR", "<cmd>lua require('config.test').javascript_runner()<cr>", desc = "Choose Test Runner", buffer = bufnr },
                    })
                elseif ft == "java" then
                    wk.add({
                        { "<leader>j", group = "Java", buffer = bufnr },
                        { "<leader>jc", "<cmd>lua require('jdtls').extract_constant()<cr>", desc = "Extract Constant", buffer = bufnr },
                        { "<leader>jo", "<cmd>lua require('jdtls').organize_imports()<cr>", desc = "Organize Imports", buffer = bufnr },
                        { "<leader>jr", "<cmd>lua require('jdtls').test_nearest_method()<cr>", desc = "Test Nearest Method", buffer = bufnr },
                        { "<leader>jt", "<cmd>lua require('jdtls').test_class()<cr>", desc = "Test Class", buffer = bufnr },
                        { "<leader>jv", "<cmd>lua require('jdtls').extract_variable()<cr>", desc = "Extract Variable", buffer = bufnr },
                    })

                    wk.add({
                        { "<leader>j", group = "Java", buffer = bufnr, mode = "v" },
                        { "<leader>jv", "<cmd>lua require('jdtls').extract_variable(true)<cr>", desc = "Extract Variable", buffer = bufnr, mode = "v" },
                        { "<leader>jc", "<cmd>lua require('jdtls').extract_constant(true)<cr>", desc = "Extract Constant", buffer = bufnr, mode = "v" },
                        { "<leader>jm", "<cmd>lua require('jdtls').extract_method(true)<cr>", desc = "Extract Method", buffer = bufnr, mode = "v" },
                    })
                end

                if fname == "package.json" then
                    wk.add({
                        { "<leader>cv", "<cmd>lua require('package-info').show()<cr>", desc = "Show Version", buffer = bufnr },
                        { "<leader>cc", "<cmd>lua require('package-info').change_version()<cr>", desc = "Change Version", buffer = bufnr },
                    })
                end

                if fname == "Cargo.toml" then
                    wk.add({
                        { "<leader>cu", "<cmd>lua require('crates').upgrade_all_crates()<cr>", desc = "Upgrade All Crates", buffer = bufnr },
                    })
                end
            end)
        end,
    })
end

function M.setup()
    setup_whichkey()
    setup_filetype_keymaps()
end

return M
