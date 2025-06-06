return {
  {
    "tpope/vim-dispatch",
    "tpope/vim-fugitive",
    "tpope/vim-surround",
    "tpope/vim-repeat",
    "tpope/vim-endwise",
    "tpope/vim-abolish",
  },
  -- gr motion
  {
    "vim-scripts/ReplaceWithRegister",
    keys = {
      {
        -- default is bound to lsp_references
        -- so rebound it to <leader>gr
        "<leader>gr",
        "<Plug>ReplaceWithRegisterOperator",
        desc = "ReplaceWithRegisterOperator",
      },
    },
  },
  -- Looks like these are not compatible
  -- {
  --   "kana/vim-textobj-entire",
  --   "kana/vim-textobj-function",
  --   "kana/vim-textobj-indent",
  --   "kana/vim-textobj-line",
  --   "kana/vim-textobj-user",
  -- },
  {
    "christoomey/vim-sort-motion",
  },
  -- generate html from notation html > body > div
  {
    "rstacruz/sparkup",
  },
  -- move separated values right and left also add argument text object
  {

    "AndrewRadev/sideways.vim",
  },
  {
    "ellisonleao/gruvbox.nvim",
  },
  -- {
  --   "folke/flash.nvim",
  --   keys = {
  --     { "s", false },
  --   }
  -- },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
  {
    "AstroNvim/astrolsp",
    opts = {
      -- set configuration options  as described below
    },
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(
      _,
      opts
    )
      local has_words_before = function()
        unpack = unpack
          or table.unpack
        local line, col =
          unpack(
            vim.api.nvim_win_get_cursor(
              0
            )
          )
        return col
            ~= 0
          and vim.api
              .nvim_buf_get_lines(
                0,
                line
                  - 1,
                line,
                true
              )[1]
              :sub(
                col,
                col
              )
              :match(
                "%s"
              )
            == nil
      end

      local cmp =
        require(
          "cmp"
        )
      opts.mapping =
        {
          ["<C-Space>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          }),
          ["<Tab>"] = function(
            fallback
          )
            if
              not cmp.select_next_item()
            then
              if
                vim.bo.buftype
                  ~= "prompt"
                and has_words_before()
              then
                cmp.complete()
              else
                fallback()
              end
            end
          end,
          ["<S-Tab>"] = function(
            fallback
          )
            if
              not cmp.select_prev_item()
            then
              if
                vim.bo.buftype
                  ~= "prompt"
                and has_words_before()
              then
                cmp.complete()
              else
                fallback()
              end
            end
          end,
        }
    end,
  },
}
