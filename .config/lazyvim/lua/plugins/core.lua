local function prefer_bin_from_venv(
  executable_name
)
  -- Return the path to the executable if $VIRTUAL_ENV is set and the binary exists somewhere beneath the $VIRTUAL_ENV path, otherwise get it from Mason
  if
    vim.env.VIRTUAL_ENV
  then
    local paths =
      vim.fn.glob(
        vim.env.VIRTUAL_ENV
          .. "/**/bin/"
          .. executable_name,
        true,
        true
      )
    local executable_path =
      table.concat(
        paths,
        ", "
      )
    if
      executable_path
      ~= ""
    then
      --vim.api.nvim_echo({ { "Using path for " .. executable_name .. ": " .. executable_path, "None" } }, false, {})
      return executable_path
    end
  end

  -- find poetry.lock file in current directory or parent directories
  local poetry_lock =
    vim.fn.findfile(
      "poetry.lock",
      ".;"
    )
  if
    poetry_lock
    ~= ""
  then
    -- use `poetry env info -p -C <path of folder containing poetry.lock>` to get the virtualenv path
    local poetry_env_path =
      vim.fn.systemlist(
        "poetry env list --full-path -C "
          .. vim.fn.fnamemodify(
            poetry_lock,
            ":h"
          )
      )

    if
      #poetry_env_path
      > 0
    then
      local candidate_paths =
        {}
      for
        _,
        env_path
      in
        ipairs(
          poetry_env_path
        )
      do
        if
          env_path
          ~= ""
        then
          if
            string.sub(
              env_path,
              0,
              1
            )
            == "/"
          then
            table.insert(
              candidate_paths,
              0,
              env_path
            )
          end
        end
      end
      local selected_poetry_env_path =
        candidate_paths[0]
      if
        #poetry_env_path
        > 1
      then
        for
          _,
          env_path
        in
          ipairs(
            candidate_paths
          )
        do
          if
            string.find(
              env_path,
              "Activated"
            )
          then
            print(
              "Multiple virtualenvs found, using Activated "
                .. env_path
            )
            -- Must strip the word "(Activated)" from the string

            selected_poetry_env_path =
              string.gsub(
                env_path,
                " %(Activated%)",
                ""
              )
            selected_poetry_env_path =
              vim.fn.trim(
                selected_poetry_env_path
              )
            break
          end
        end
      end
      local venv_path_to_python = selected_poetry_env_path
        .. "/bin/"
        .. executable_name
      if
        vim.fn.filereadable(
          venv_path_to_python
        )
        == 1
      then
        print(
          "Using path for "
            .. executable_name
            .. ": "
            .. venv_path_to_python
        )
        return venv_path_to_python
      end
    end
  end

  local mason_registry =
    require(
      "mason-registry"
    )
  if
    mason_registry.has_package(
      executable_name
    )
    == false
  then
    return executable_name
  end
  local mason_path = mason_registry
    .get_package(
      executable_name
    )
    :get_install_path() .. "/venv/bin/" .. executable_name
  -- vim.api.nvim_echo({ { "Using path for " .. executable_name .. ": " .. mason_path, "None" } }, false, {})
  return mason_path
end

return {
  {
    -- lsp config
    "nvim-lspconfig",
    opts = {
      setup = {
        pyright = function(
          _,
          opts
        )
          opts.settings =
            {
              python = {
                pythonPath = prefer_bin_from_venv(
                  "python"
                ),
                analysis = {
                  diagnosticMode = "off",
                  typeCheckingMode = "off",
                },
              },
            }
          require(
            "lspconfig"
          ).pyright.setup(
            opts
          )
          return true
        end,
        ruff_lsp = function(
          _,
          opts
        )
          require(
            "lspconfig"
          ).ruff_lsp.setup(
            opts
          )
          return true
        end,
        ["*"] = function(
          server,
          opts
        )
        end,
      },
    },
  },
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
