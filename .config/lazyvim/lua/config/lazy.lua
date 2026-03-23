local lazypath = vim.fn.stdpath(
  "data"
) .. "/lazy/lazy.nvim"
if
  not (
    vim.uv
    or vim.loop
  ).fs_stat(
    lazypath
  )
then
  local lazyrepo =
    "https://github.com/folke/lazy.nvim.git"
  local out =
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "--branch=stable",
      lazyrepo,
      lazypath,
    })
  if
    vim.v.shell_error
    ~= 0
  then
    vim.api.nvim_echo(
      {
        {
          "Failed to clone lazy.nvim:\n",
          "ErrorMsg",
        },
        {
          out,
          "WarningMsg",
        },
        {
          "\nPress any key to exit...",
        },
      },
      true,
      {}
    )
    vim.fn.getchar()
    os.exit(
      1
    )
  end
end
vim.opt.rtp:prepend(
  lazypath
)

require(
  "lazy"
).setup({
  spec = {
    -- add LazyVim and import its plugins
    {
      "LazyVim/LazyVim",
      import = "lazyvim.plugins",
    },
    -- import/override with your plugins
    {
      import = "plugins",
    },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = {
    colorscheme = {
      "tokyonight",
      "habamax",
    },
  },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
  }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

local lspconfig =
  require(
    "lspconfig"
  )
local configs =
  require(
    "lspconfig.configs"
  )
-- Define the OpenCode LSP if not already present
if
  not configs.opencode_lsp
then
  configs.opencode_lsp =
    {
      default_config = {
        cmd = {
          "opencode",
          "lsp",
        },
        filetypes = {
          "typescript",
          "javascript",
          "typescriptreact",
          "javascriptreact",
          "python",
          "rust",
          "go",
        },
        root_dir = lspconfig.util.root_pattern(
          "opencode.json",
          ".git",
          "package.json"
        ),
        settings = {},
      },
    }
end
-- Initialize it
lspconfig.opencode_lsp.setup({
  on_attach = function(
    client,
    bufnr
  )
    -- Your standard LSP mappings (hover, definition, etc.)
    local opts =
      {
        noremap = true,
        silent = true,
        buffer = bufnr,
      }
    vim.keymap.set(
      "n",
      "K",
      vim.lsp.buf.hover,
      opts
    )
    vim.keymap.set(
      "n",
      "gd",
      vim.lsp.buf.definition,
      opts
    )
    vim.keymap.set(
      "n",
      "gr",
      vim.lsp.buf.references,
      opts
    )
    vim.keymap.set(
      "n",
      "<leader>rn",
      vim.lsp.buf.rename,
      opts
    )
    vim.keymap.set(
      "n",
      "<leader>ca",
      vim.lsp.buf.code_action,
      opts
    )
  end,
})
