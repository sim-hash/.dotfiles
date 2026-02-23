local M = {}

function M.create_temp_git_repo()
  local tmp_dir = vim.fn.tempname()
  vim.fn.mkdir(tmp_dir, "p")
  vim.fn.system("git -C " .. tmp_dir .. " init")
  vim.fn.system("git -C " .. tmp_dir .. " config user.email 'test@test.com'")
  vim.fn.system("git -C " .. tmp_dir .. " config user.name 'Test'")
  vim.fn.system("git -C " .. tmp_dir .. " commit --allow-empty -m 'init'")
  return tmp_dir
end

function M.cleanup_temp_repo(path)
  if path then
    vim.fn.delete(path, "rf")
  end
end

return M
