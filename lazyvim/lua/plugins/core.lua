return {
  {
    "ellisonleao/gruvbox.nvim",
  },
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
    ---@param opts cmp.ConfigSchema
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
