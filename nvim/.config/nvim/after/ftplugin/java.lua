local jdtls = require('jdtls')

-- File types that signify a Java project's root directory. This will be
-- used by eclipse to determine what constitutes a workspace
local root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw', 'pom.xml', 'build.gradle'}, { upward = true })[1])

-- local root_markers = {'gradlew', 'mvnw', '.git', "pom.xml", "build.gradle"}, { upward = true }
-- local root_dir = require('jdtls.setup').find_root(root_markers)

-- eclipse.jdt.ls stores project specific data within a folder. If you are working
-- with multiple different projects, each project must use a dedicated data directory.
-- This variable is used to configure eclipse to use the directory name of the
-- current project found using the root_marker as the folder for project specific data.

-- NOTE: Update these paths to match your Java tooling installation locations
local JDTLS_LOCATION = '/usr/local/jdt-language-server-1.30.1/'
local home = os.getenv('HOME')
local workspace_dir = home .. "/.cache/jdtls/workspace/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

local bundles = {
  vim.fn.glob('/usr/local/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar', 1),
}

vim.list_extend(bundles, vim.split(vim.fn.glob("/usr/local/vscode-java-test/server/*.jar", 1), "\n"))

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local config = {
  flags = {
    debounce_text_changes = 80,
  },
  capabilities = capabilities,
  on_attach = function()
      vim.lsp.codelens.refresh()
      jdtls.setup_dap({ hotcodereplace = "auto" })
      -- NOTE: This function doesn't exist in current nvim-jdtls - keeping commented for reference
      -- jdtls.setup_dap_main_class_configs()
  end,
  init_options = {
      bundles = bundles
  },
  root_dir = root_dir, -- Set the root directory to our found root_marker
  -- Here you can configure eclipse.jdt.ls specific settings
  -- These are defined by the eclipse.jdt.ls project and will be passed to eclipse when starting.
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
        format = {
            settings = {
                -- Use Google Java style guidelines for formatting
                -- To use, make sure to download the file from https://github.com/google/styleguide/blob/gh-pages/eclipse-java-google-style.xml
                -- and place it in the ~/.local/share/eclipse directory
                url = home .. "/.local/share/eclipse/eclipse-java-google-style.xml",
                profile = "GoogleStyle",
            },
        },
      signatureHelp = { enabled = true },
      contentProvider = { preferred = 'fernflower' },  -- Use fernflower to decompile library code
      -- Specify any completion options
      completion = {
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*"
        },
        filteredTypes = {
          "com.sun.*",
          "io.micrometer.shaded.*",
          "java.awt.*",
          "jdk.*", "sun.*",
        },
      },
      -- Specify any options for organizing imports
      sources = {
        organizeImports = {
          starThreshold = 9999;
          staticStarThreshold = 9999;
        },
      },
      -- How code generation should act
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
        },
        hashCodeEquals = {
          useJava7Objects = true,
        },
        useBlocks = true,
      },
      -- If you are developing in projects with different Java versions, you need
      -- to tell eclipse.jdt.ls to use the location of the JDK for your Java version
      -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
      -- And search for `interface RuntimeOption`
      -- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
      configuration = {
          runtimes = {
              {
                  name = "JavaSE-21",
                  -- NOTE: Update this to match your Java installation path
                  path = "/usr/lib/jvm/java-21-openjdk-amd64",
              }
          }
      }
    }
  },
  -- cmd is the command that starts the language server. Whatever is placed
  -- here is what is passed to the command line to execute jdtls.
  -- Note that eclipse.jdt.ls must be started with a Java version of 17 or higher
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  -- for the full list of options
  --
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dosgi.checkConfiguration=true',

    -- The configuration for jdtls is also placed where jdtls was installed. This will
    -- need to be updated depending on your environment
    '-Dosgi.sharedConfiguration.area=/usr/local/jdt-language-server-1.30.1/config_linux',
    '-Dosgi.sharedConfiguration.area.readOnly=true',
    '-Dosgi.configuration.cascaded=true',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    -- If you use lombok, download the lombok jar and place it in ~/.local/share/eclipse
    --"-javaagent:" .. home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar",

    -- The jar file is located where jdtls was installed. This will need to be updated
    -- to the location where you installed jdtls
    '-jar', vim.fn.glob(JDTLS_LOCATION .. '/plugins/org.eclipse.equinox.launcher_*.jar'),

    -- Different way to place the configuration. The configuration for jdtls is also placed where jdtls was installed. This will
    -- need to be updated depending on your environment
    -- '-configuration',
    -- JDTLS_LOCATION .. 'config_linux',
    -- Use the workspace_dir defined above to store data for this project
    '-data',  workspace_dir,
  },
}

-- Finally, start jdtls. This will run the language server using the configuration we specified,
-- setup the keymappings, and attach the LSP client to the current buffer
jdtls.start_or_attach(config)


--local config = {
--    cmd = { "/usr/local/jdt-language-server-1.30.1/bin/jdtls" },
--    root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw', 'pom.xml'}, { upward = true })[1]),
--}
--require('jdtls').start_or_attach(config)
