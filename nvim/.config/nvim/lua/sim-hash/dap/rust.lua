local M = {}

function M.setup()
    local dap = require "dap"

    local extension_path = vim.env.HOME .. '/.vscode/extensions/vadimcn.vscode-lldb-1.10.0/'
    local codelldb_path = extension_path .. 'adapter/codelldb'
    local liblldb_path = extension_path .. 'lldb/lib/liblldb'

    dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
            command = codelldb_path,
            args = { "--port", "${port}" },
        },
    }
    dap.configurations.cpp = {
        {
            name = "Launch file",
            type = "codelldb",
            request = "launch",
            program = function()
                print("Path: ")
                return vim.fn.input(vim.fn.getcwd() .. "/", "target/release/lisk-vanity")
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
            -- how to pass args
--            arg = {
--                "--gpu",
--                "MAMA"
--            },
        },
    }

    dap.configurations.c = dap.configurations.cpp
    dap.configurations.rust = dap.configurations.cpp


--local dap = require("dap")
--dap.adapters.gdb = {
--    type = "executable",
--    command = "gdb",    
--    args = { "-i", "dap" }
--}
--print("====================================================================")
--print("Inside rust.lua with the adapter")
--print(require('dap') == nil)
--print(require('dap').dap_executable)
--
--dap.configurations.cpp = {
--    {
--        name = "Launch",
--        type = "gdb",
--        request = "launch",
--        program = function()
--            return vim.fn.input(vim.fn.getcwd() .. '/', 'target/debug/guessing_game')
--        end,
--        cwd = "${workspaceFolder}",
--    },
--}
--
--
--dap.configurations.c = dap.configurations.cpp
--dap.configurations.rust = dap.configurations.cpp
end

return M
