local helpers = require("tests.helpers")
local stub = require("luassert.stub")

describe("git_diff", function()
  -- Clear cached module before each test
  before_each(function()
    package.loaded["sim-hash.git_diff"] = nil
  end)

  describe("get_diff_files", function()
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

  describe("get_toplevel", function()
    it("returns_path_on_success", function()
      local s = stub(vim.fn, "systemlist")
      s.returns({ "/home/user/project" })
      vim.v.shell_error = 0

      local git_diff = require("sim-hash.git_diff")
      local result = git_diff.get_toplevel()

      assert.equals("/home/user/project", result)
      s:revert()
    end)

    it("returns_nil_outside_git_repo", function()
      local s = stub(vim.fn, "systemlist")
      s.returns({ "fatal: not a git repository" })
      vim.v.shell_error = 128

      local git_diff = require("sim-hash.git_diff")
      local result = git_diff.get_toplevel()

      assert.is_nil(result)
      s:revert()
    end)
  end)

  describe("integration", function()
    local tmp_dir

    before_each(function()
      tmp_dir = helpers.create_temp_git_repo()
    end)

    after_each(function()
      helpers.cleanup_temp_repo(tmp_dir)
    end)

    it("detects_changed_files_in_real_repo", function()
      -- Add a file and commit
      vim.fn.writefile({ "hello" }, tmp_dir .. "/test.lua")
      vim.fn.system("git -C " .. tmp_dir .. " add .")
      vim.fn.system("git -C " .. tmp_dir .. " commit -m 'add test'")

      -- Diff against first commit
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
  end)
end)
