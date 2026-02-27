local M = {}

function M.get_toplevel()
  local result = vim.fn.systemlist("git rev-parse --show-toplevel")
  if #result == 0 or (result[1] and result[1]:match("^fatal")) then
    return nil
  end
  return result[1]
end

function M.get_git_user(toplevel)
  local prefix = toplevel and ("git -C " .. toplevel .. " ") or "git "
  local user = vim.fn.system(prefix .. "config user.name"):gsub("\n", "")
  if user == "" then
    return nil
  end
  return user
end

function M.get_diff_files(base, toplevel, author)
  local prefix = toplevel and ("git -C " .. toplevel .. " ") or "git "

  if author then
    -- Get files changed only in commits by this author
    local cmd = prefix .. "log --author=" .. vim.fn.shellescape(author)
      .. " --no-merges --diff-filter=ACMR --name-only --pretty=format: "
      .. base .. "..HEAD"
    local files = vim.fn.systemlist(cmd)
    -- Filter out empty lines and deduplicate
    local seen = {}
    local result = {}
    for _, f in ipairs(files) do
      if f ~= "" and not f:match("^fatal") and not seen[f] then
        seen[f] = true
        result[#result + 1] = f
      end
    end
    if #result == 0 then
      return nil
    end
    return result
  end

  local cmd = prefix .. "diff --name-only " .. base
  local files = vim.fn.systemlist(cmd)
  if #files == 0 or (files[1] and files[1]:match("^fatal")) then
    return nil
  end
  return files
end

return M
