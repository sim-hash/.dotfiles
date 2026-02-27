local stub = require("luassert.stub")

local function create_temp_git_repo()
  local tmp_dir = vim.fn.tempname()
  vim.fn.mkdir(tmp_dir, "p")
  vim.fn.system("git -C " .. tmp_dir .. " init")
  vim.fn.system("git -C " .. tmp_dir .. " config user.email 'test@test.com'")
  vim.fn.system("git -C " .. tmp_dir .. " config user.name 'Test'")
  vim.fn.system("git -C " .. tmp_dir .. " commit --allow-empty -m 'init'")
  return tmp_dir
end

local function cleanup_temp_repo(path)
  if path then
    vim.fn.delete(path, "rf")
  end
end

describe("git_diff", function()
  -- Clear cached module before each test
  before_each(function()
    package.loaded["sim-hash.git_diff"] = nil
  end)

  describe("get_diff_files without author filter", function()
    it("returns_file_list_when_diff_exists", function()
      local s = stub(vim.fn, "systemlist")
      s.returns({ "file1.lua", "file2.lua" })

      local git_diff = require("sim-hash.git_diff")
      local result = git_diff.get_diff_files("origin/main", "/tmp/repo")

      assert.is_not_nil(result)
      assert.are.same({ "file1.lua", "file2.lua" }, result)
      s:revert()
    end)

    it("returns_nil_when_no_files_changed", function()
      local s = stub(vim.fn, "systemlist")
      s.returns({})

      local git_diff = require("sim-hash.git_diff")
      local result = git_diff.get_diff_files("origin/main", "/tmp/repo")

      assert.is_nil(result)
      s:revert()
    end)

    it("returns_nil_for_fatal_git_error", function()
      local s = stub(vim.fn, "systemlist")
      s.returns({ "fatal: bad revision 'origin/main'" })

      local git_diff = require("sim-hash.git_diff")
      local result = git_diff.get_diff_files("origin/main", "/tmp/repo")

      assert.is_nil(result)
      s:revert()
    end)

    it("uses_toplevel_when_provided", function()
      local s = stub(vim.fn, "systemlist")
      s.returns({ "file.lua" })

      local git_diff = require("sim-hash.git_diff")
      git_diff.get_diff_files("origin/main", "/my/repo")

      assert.stub(s).was_called_with("git -C /my/repo diff --name-only origin/main")
      s:revert()
    end)

    it("omits_toplevel_when_nil", function()
      local s = stub(vim.fn, "systemlist")
      s.returns({ "file.lua" })

      local git_diff = require("sim-hash.git_diff")
      git_diff.get_diff_files("origin/main", nil)

      assert.stub(s).was_called_with("git diff --name-only origin/main")
      s:revert()
    end)
  end)

  describe("get_diff_files with author filter", function()
    it("returns_only_files_from_author_commits", function()
      local s = stub(vim.fn, "systemlist")
      s.returns({ "", "file1.lua", "", "file2.lua", "" })
      local se = stub(vim.fn, "shellescape")
      se.returns("'sim-hash'")

      local git_diff = require("sim-hash.git_diff")
      local result = git_diff.get_diff_files("origin/main", "/tmp/repo", "sim-hash")

      assert.is_not_nil(result)
      assert.are.same({ "file1.lua", "file2.lua" }, result)
      s:revert()
      se:revert()
    end)

    it("deduplicates_files_across_commits", function()
      local s = stub(vim.fn, "systemlist")
      s.returns({ "", "file1.lua", "", "file1.lua", "file2.lua", "" })
      local se = stub(vim.fn, "shellescape")
      se.returns("'sim-hash'")

      local git_diff = require("sim-hash.git_diff")
      local result = git_diff.get_diff_files("origin/main", "/tmp/repo", "sim-hash")

      assert.are.same({ "file1.lua", "file2.lua" }, result)
      s:revert()
      se:revert()
    end)

    it("returns_nil_when_author_has_no_commits", function()
      local s = stub(vim.fn, "systemlist")
      s.returns({ "" })
      local se = stub(vim.fn, "shellescape")
      se.returns("'Nobody'")

      local git_diff = require("sim-hash.git_diff")
      local result = git_diff.get_diff_files("origin/main", "/tmp/repo", "Nobody")

      assert.is_nil(result)
      s:revert()
      se:revert()
    end)

    it("filters_fatal_errors_from_log_output", function()
      local s = stub(vim.fn, "systemlist")
      s.returns({ "fatal: bad revision" })
      local se = stub(vim.fn, "shellescape")
      se.returns("'sim-hash'")

      local git_diff = require("sim-hash.git_diff")
      local result = git_diff.get_diff_files("origin/main", "/tmp/repo", "sim-hash")

      assert.is_nil(result)
      s:revert()
      se:revert()
    end)
  end)

  describe("get_git_user", function()
    it("returns_user_name", function()
      local s = stub(vim.fn, "system")
      s.returns("sim-hash\n")

      local git_diff = require("sim-hash.git_diff")
      local result = git_diff.get_git_user("/tmp/repo")

      assert.equals("sim-hash", result)
      s:revert()
    end)

    it("returns_nil_when_not_configured", function()
      local s = stub(vim.fn, "system")
      s.returns("\n")

      local git_diff = require("sim-hash.git_diff")
      local result = git_diff.get_git_user("/tmp/repo")

      assert.is_nil(result)
      s:revert()
    end)
  end)

  describe("get_toplevel", function()
    it("returns_path_on_success", function()
      local s = stub(vim.fn, "systemlist")
      s.returns({ "/home/user/project" })

      local git_diff = require("sim-hash.git_diff")
      local result = git_diff.get_toplevel()

      assert.equals("/home/user/project", result)
      s:revert()
    end)

    it("returns_nil_outside_git_repo", function()
      local s = stub(vim.fn, "systemlist")
      s.returns({ "fatal: not a git repository" })

      local git_diff = require("sim-hash.git_diff")
      local result = git_diff.get_toplevel()

      assert.is_nil(result)
      s:revert()
    end)
  end)

  describe("integration", function()
    local tmp_dir

    before_each(function()
      tmp_dir = create_temp_git_repo()
    end)

    after_each(function()
      cleanup_temp_repo(tmp_dir)
    end)

    it("detects_changed_files_in_real_repo", function()
      vim.fn.writefile({ "hello" }, tmp_dir .. "/test.lua")
      vim.fn.system("git -C " .. tmp_dir .. " add .")
      vim.fn.system("git -C " .. tmp_dir .. " commit -m 'add test'")

      local git_diff = require("sim-hash.git_diff")
      local files = git_diff.get_diff_files("HEAD~1", tmp_dir)

      assert.is_not_nil(files)
      assert.are.same({ "test.lua" }, files)
    end)

    it("returns_nil_when_no_changes", function()
      local git_diff = require("sim-hash.git_diff")
      local files = git_diff.get_diff_files("HEAD", tmp_dir)

      assert.is_nil(files)
    end)

    it("filters_by_author_in_real_repo", function()
      -- Commit as "Test" (set in helpers.create_temp_git_repo)
      vim.fn.writefile({ "mine" }, tmp_dir .. "/my_file.lua")
      vim.fn.system("git -C " .. tmp_dir .. " add .")
      vim.fn.system("git -C " .. tmp_dir .. " commit -m 'my commit'")

      -- Commit as a different author
      vim.fn.writefile({ "theirs" }, tmp_dir .. "/their_file.lua")
      vim.fn.system("git -C " .. tmp_dir .. " add .")
      vim.fn.system(
        "git -C " .. tmp_dir
        .. " -c user.name='Other' -c user.email='other@test.com'"
        .. " commit -m 'their commit'"
      )

      local git_diff = require("sim-hash.git_diff")
      local files = git_diff.get_diff_files("HEAD~2", tmp_dir, "Test")

      assert.is_not_nil(files)
      assert.are.same({ "my_file.lua" }, files)
    end)
  end)
end)
