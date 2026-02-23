local M = {}

function M.get_toplevel()
  local result = vim.fn.systemlist("git rev-parse --show-toplevel")
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return result[1]
end

function M.get_diff_files(base, toplevel)
  local cmd = toplevel
    and ("git -C " .. toplevel .. " diff --name-only " .. base)
    or ("git diff --name-only " .. base)
  local files = vim.fn.systemlist(cmd)
  if #files == 0 or (files[1] and files[1]:match("^fatal")) then
    return nil
  end
  return files
end

return M
