-- Dev core
-- Things that are just there.

--    Sections:
--       ## TREE SITTER
--       -> nvim-treesitter                [syntax highlight]
--       -> nvim-ts-autotag                [treesitter understand html tags]
--       -> ts-comments.nvim               [treesitter comments]
--       -> markview.nvim                  [markdown highlights]
--       -> nvim-colorizer                 [hex colors]

--       ## LSP
--       -> nvim-java                      [java support]
--       -> mason-lspconfig                [auto start lsp]
--       -> nvim-lspconfig                 [lsp configs]
--       -> mason.nvim                     [lsp package manager]
--       -> SchemaStore.nvim               [mason extra schemas]
--       -> none-ls-autoload.nvim          [mason package loader]
--       -> none-ls                        [lsp code formatting]
--       -> neodev                         [lsp for nvim lua api]
--       -> garbage-day                    [lsp garbage collector]

--       ## AUTO COMPLETION
--       -> nvim-cmp                       [auto completion engine]
--       -> cmp-nvim-buffer                [auto completion buffer]
--       -> cmp-nvim-path                  [auto completion path]
--       -> cmp-nvim-lsp                   [auto completion lsp]
--       -> cmp-luasnip                    [auto completion snippets]

local utils = require("base.utils")
local utils_lsp = require("base.utils.lsp")

return {
  --  TREE SITTER ---------------------------------------------------------
  --  [syntax highlight] + [treesitter understand html tags] + [comments]
  --  https://github.com/nvim-treesitter/nvim-treesitter
  --  https://github.com/windwp/nvim-ts-autotag
  --  https://github.com/windwp/nvim-treesitter-textobjects
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "windwp/nvim-ts-autotag",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    event = "User BaseDefered",
    cmd = {
      "TSBufDisable",
      "TSBufEnable",
      "TSBufToggle",
      "TSDisable",
      "TSEnable",
      "TSToggle",
      "TSInstall",
      "TSInstallInfo",
      "TSInstallSync",
      "TSModuleInfo",
      "TSUninstall",
      "TSUpdate",
      "TSUpdateSync",
    },
    build = ":TSUpdate",
    init = function(plugin)
      -- perf: make treesitter queries available at startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    opts = {
      auto_install = false, -- Currently bugged. Use [:TSInstall all] and [:TSUpdate all]
      autotag = { enable = true },
      highlight = {
        enable = true,
      },
      matchup = {
        enable = true,
        enable_quotes = true,
      },
      incremental_selection = { enable = true },
      indent = { enable = true },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["ak"] = { query = "@block.outer", desc = "around block" },
            ["ik"] = { query = "@block.inner", desc = "inside block" },
            ["ac"] = { query = "@class.outer", desc = "around class" },
            ["ic"] = { query = "@class.inner", desc = "inside class" },
            ["a?"] = { query = "@conditional.outer", desc = "around conditional" },
            ["i?"] = { query = "@conditional.inner", desc = "inside conditional" },
            ["af"] = { query = "@function.outer", desc = "around function " },
            ["if"] = { query = "@function.inner", desc = "inside function " },
            ["al"] = { query = "@loop.outer", desc = "around loop" },
            ["il"] = { query = "@loop.inner", desc = "inside loop" },
            ["aa"] = { query = "@parameter.outer", desc = "around argument" },
            ["ia"] = { query = "@parameter.inner", desc = "inside argument" },
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]k"] = { query = "@block.outer", desc = "Next block start" },
            ["]f"] = { query = "@function.outer", desc = "Next function start" },
            ["]a"] = { query = "@parameter.inner", desc = "Next parameter start" },
          },
          goto_next_end = {
            ["]K"] = { query = "@block.outer", desc = "Next block end" },
            ["]F"] = { query = "@function.outer", desc = "Next function end" },
            ["]A"] = { query = "@parameter.inner", desc = "Next parameter end" },
          },
          goto_previous_start = {
            ["[k"] = { query = "@block.outer", desc = "Previous block start" },
            ["[f"] = { query = "@function.outer", desc = "Previous function start" },
            ["[a"] = { query = "@parameter.inner", desc = "Previous parameter start" },
          },
          goto_previous_end = {
            ["[K"] = { query = "@block.outer", desc = "Previous block end" },
            ["[F"] = { query = "@function.outer", desc = "Previous function end" },
            ["[A"] = { query = "@parameter.inner", desc = "Previous parameter end" },
          },
        },
        swap = {
          enable = true,
          swap_next = {
            [">K"] = { query = "@block.outer", desc = "Swap next block" },
            [">F"] = { query = "@function.outer", desc = "Swap next function" },
            [">A"] = { query = "@parameter.inner", desc = "Swap next parameter" },
          },
          swap_previous = {
            ["<K"] = { query = "@block.outer", desc = "Swap previous block" },
            ["<F"] = { query = "@function.outer", desc = "Swap previous function" },
            ["<A"] = { query = "@parameter.inner", desc = "Swap previous parameter" },
          },
        },
      },
    },
  },

  -- ts-comments.nvim [treesitter comments]
  -- https://github.com/folke/ts-comments.nvim
  -- This plugin can be safely removed after nvim 0.11 is released.
  {
   "folke/ts-comments.nvim",
    event = "User BaseFile",
    enabled = vim.fn.has("nvim-0.10.0") == 1,
    opts = {},
  },

  --  markview.nvim [markdown highlights]
  --  https://github.com/folke/todo-comments.nvim
  --  While on normal mode, markdown files will display highlights.
  {
    "OXY2DEV/markview.nvim",
    ft = { "markdown" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    },
    opts = {
      headings = {
        shift_width = 0,
        heading_1 = {
          style = "label",
          sign = "",
          sign_hl = "MarkviewCol7Fg",
          hl = "MarkviewCol7Fg"
        },
        heading_2 = {
          style = "label",
          sign = "▶",
          sign_hl = "col_2_fg",
        },
        heading_3 = {
          style = "label",
          sign = "󰼑",
          sign_hl = "col_1_fg",
          hl = "MarkviewCol3",
        },
        heading_4 = {
          style = "label",
          sign = "󰎲",
          sign_hl = "col_1_fg",
          hl = "MarkviewCol4",
        },
        heading_5 = {
          style = "label",
          sign = "󰼓",
          sign_hl = "col_1_fg",
          hl = "MarkviewCol5",
        },
        heading_6 = {
          style = "label",
          sign = "󰎴",
          sign_hl = "col_1_fg",
          hl = "MarkviewCol6",
        }
      },
      list_items = {
        marker_minus = {
          add_padding = true,
          text = "",
          hl = "markviewCol2Fg"
        },
        marker_plus = {
          add_padding = true,
          text = "",
          hl = "markviewCol4Fg"
        },
        marker_star = {
          add_padding = true,
          text = "",
          text_hl = "markviewCol6Fg"
        },
        marker_dot = {
          add_padding = true
        },
      },
      block_quotes = {
        enable = true,
        default = { border = "▋", border_hl = "MarkviewCol7Fg" },
        callouts = {
          {
            match_string = "NOTE",
            callout_preview = "󰋽 Note",
            callout_preview_hl = "MarkviewCol4Fg",

            custom_title = true,
            custom_icon = "󰋽 ",

            border = "▋",
            border_hl = "MarkviewCol5Fg"
          },
          {
            match_string = "DESCRIPTION",
            callout_preview = "󰋽 DESCRIPTION",
            callout_preview_hl = "MarkviewCol7Fg",

            custom_title = true,
            custom_icon = "",

            border = "▋",
            border_hl = "MarkviewCol7Fg"
          },
          {
            match_string = "TODO",
            callout_preview = "󰋽 ",
            callout_preview_hl = "MarkviewCol4Fg",

            custom_title = true,
            custom_icon = "󰋽 ",

            border = "▋",
            border_hl = "MarkviewCol5Fg"
          },
          {
            match_string = "BUG",
            callout_preview = " Bug",
            callout_preview_hl = "MarkviewCol1Fg",

            custom_title = true,
            custom_icon = "  ",

            border = "▋",
            border_hl = "MarkviewCol1Fg"
          },
          {
            match_string = "EXAMPLE",
            callout_preview = "󱖫 Example",
            callout_preview_hl = "MarkviewCol6Fg",

            custom_title = true,
            custom_icon = "󱖫 ",

            border = "▋",
            border_hl = "MarkviewCol6Fg"
          },
          {
            match_string = "IMPORTANT",
            callout_preview = " Important",
            callout_preview_hl = "MarkviewCol3Fg",

            custom_title = true,
            custom_icon = " ",

            border = "▋",
            border_hl = "MarkviewCol3Fg"
          },
          {
            match_string = "WARNING",
            callout_preview = " Warning",
            callout_preview_hl = "MarkviewCol2Fg",

            custom_title = true,
            custom_icon = " ",

            border = "▋",
            border_hl = "MarkviewCol2Fg"
          },
        }
      },
      checkboxes = {
        checked = { text = "⚫", hl = "markviewCol4Fg" },
        pending = { text = "⭕", hl = "MarkviewCol2Fg" },
        unchecked = { text = "🟢", hl = "markviewCol1Fg" }
      },
      horizontal_rules = {
        parts = { {
          type = "repeating",
          text = "─",
          repeat_amount = function()
            return vim.o.colorcolumn - 1
          end,
        } },
      },
    }
  },

  --  [hex colors]
  --  https://github.com/NvChad/nvim-colorizer.lua
  {
    "NvChad/nvim-colorizer.lua",
    event = "User BaseFile",
    cmd = {
      "ColorizerToggle",
      "ColorizerAttachToBuffer",
      "ColorizerDetachFromBuffer",
      "ColorizerReloadAllBuffers",
    },
    opts = { user_default_options = { names = false } },
  },

  --  LSP -------------------------------------------------------------------

  -- nvim-java [java support]
  -- https://github.com/nvim-java/nvim-java
  -- Reliable jdtls support. Must go before mason-lspconfig and lsp-config.
  {
    "nvim-java/nvim-java",
    ft = { "java" },
    dependencies = {
      "nvim-java/lua-async-await",
      'nvim-java/nvim-java-refactor',
      "nvim-java/nvim-java-core",
      "nvim-java/nvim-java-test",
      "nvim-java/nvim-java-dap",
      "JavaHello/spring-boot.nvim",
      "MunifTanjim/nui.nvim",
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap",
      "williamboman/mason.nvim",
    },
    opts = {
      notifications = {
        dap = false,
      },
      -- NOTE: One of these files must be in your project root directory.
      --       Otherwise the debugger will end in the wrong directory and fail.
      root_markers = {
        'settings.gradle',
        'settings.gradle.kts',
        'pom.xml',
        'build.gradle',
        'mvnw',
        'gradlew',
        'build.gradle',
        'build.gradle.kts',
        '.git',
      },
    },
  },

  --  nvim-lspconfig [lsp configs]
  --  https://github.com/neovim/nvim-lspconfig
  --  This plugin provide default configs for the lsp servers available on mason.
  {
    "neovim/nvim-lspconfig",
    event = "User BaseFile",
    dependencies = "nvim-java/nvim-java",
  },

  -- mason-lspconfig [auto start lsp]
  -- https://github.com/williamboman/mason-lspconfig.nvim
  -- This plugin auto starts the lsp servers installed by Mason
  -- every time Neovim trigger the event FileType.
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    event = "User BaseFile",
    opts = function(_, opts)
      if not opts.handlers then opts.handlers = {} end
      opts.handlers[1] = function(server) utils_lsp.setup(server) end
    end,
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)
      utils_lsp.apply_default_lsp_settings() -- Apply our default lsp settings.
      utils.trigger_event("FileType")        -- This line starts this plugin.
    end,
  },

  --  mason [lsp package manager]
  --  https://github.com/williamboman/mason.nvim
  --  https://github.com/zeioth/mason-extra-cmds
  {
    "williamboman/mason.nvim",
    dependencies = { "zeioth/mason-extra-cmds", opts = {} },
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
      "MasonUpdate",
      "MasonUpdateAll", -- this cmd is provided by mason-extra-cmds
    },
    opts = {
      registries = {
        "github:nvim-java/mason-registry",
        "github:mason-org/mason-registry",
      },
      ui = {
        icons = {
          package_installed = "✓",
          package_uninstalled = "✗",
          package_pending = "⟳",
        },
      },
    }
  },

  --  Schema Store [mason extra schemas]
  --  https://github.com/b0o/SchemaStore.nvim
  "b0o/SchemaStore.nvim",

  -- none-ls-autoload.nvim [mason package loader]
  -- https://github.com/zeioth/mason-none-ls.nvim
  -- This plugin auto starts the packages installed by Mason
  -- every time Neovim trigger the event FileType ().
  -- By default it will use none-ls builtin sources.
  -- But you can add external sources if a mason package has no builtin support.
  {
    "zeioth/none-ls-autoload.nvim",
    event = "User BaseFile",
    dependencies = {
      "williamboman/mason.nvim",
      "zeioth/none-ls-external-sources.nvim"
    },
    opts = {
      -- Here you can add support for sources not oficially suppored by none-ls.
      external_sources = {
        -- diagnostics
        'none-ls-external-sources.diagnostics.cpplint',
        'none-ls-external-sources.diagnostics.eslint',
        'none-ls-external-sources.diagnostics.eslint_d',
        'none-ls-external-sources.diagnostics.flake8',
        'none-ls-external-sources.diagnostics.luacheck',
        'none-ls-external-sources.diagnostics.psalm',
        'none-ls-external-sources.diagnostics.shellcheck',
        'none-ls-external-sources.diagnostics.yamllint',

        -- formatting
        'none-ls-external-sources.formatting.autopep8',
        'none-ls-external-sources.formatting.beautysh',
        'none-ls-external-sources.formatting.easy-coding-standard',
        'none-ls-external-sources.formatting.eslint',
        'none-ls-external-sources.formatting.eslint_d',
        'none-ls-external-sources.formatting.jq',
        'none-ls-external-sources.formatting.latexindent',
        'none-ls-external-sources.formatting.reformat_gherkin',
        'none-ls-external-sources.formatting.rustfmt',
        'none-ls-external-sources.formatting.standardrb',
        'none-ls-external-sources.formatting.yq',
      },
    },
  },

  -- none-ls [lsp code formatting]
  -- https://github.com/nvimtools/none-ls.nvim
  {
    "nvimtools/none-ls.nvim",
    event = "User BaseFile",
    opts = function()
      local builtin_sources = require("null-ls").builtins

      -- You can customize your 'builtin sources' and 'external sources' here.
      builtin_sources.formatting.shfmt.with({
        command = "shfmt",
        args = { "-i", "2", "-filename", "$FILENAME" },
      })

      -- Attach the user lsp mappings to every none-ls client.
      return { on_attach = utils_lsp.apply_user_lsp_mappings }
    end
  },

  --  neodev.nvim [lsp for nvim lua api]
  --  https://github.com/folke/neodev.nvim
  {
    "folke/neodev.nvim",
    ft = { "lua" },
    opts = {}
  },

  --  garbage-day.nvim [lsp garbage collector]
  --  https://github.com/zeioth/garbage-day.nvim
  {
    "zeioth/garbage-day.nvim",
    event = "User BaseFile",
    opts = {
      aggressive_mode = false,
      excluded_lsp_clients = {
        "null-ls", "jdtls", "marksman"
      },
      grace_period = (60 * 15),
      wakeup_delay = 3000,
      notifications = false,
      retries = 3,
      timeout = 1000,
    }
  },

  --  AUTO COMPLETION --------------------------------------------------------
  --  Auto completion engine [autocompletion engine]
  --  https://github.com/hrsh7th/nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp"
    },
    event = "InsertEnter",
    opts = function()
      -- ensure dependencies exist
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      -- border opts
      local border_opts = {
        border = "rounded",
        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
      }

      -- helper
      local function has_words_before()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
      end

      return {
        enabled = function() -- disable in certain cases on dap.
          local is_prompt = vim.bo.buftype == "prompt"
          local is_dap_prompt = utils.is_available("cmp-dap")
              and vim.tbl_contains(
                { "dap-repl", "dapui_watches", "dapui_hover" }, vim.bo.filetype)
          if is_prompt and not is_dap_prompt then
            return false
          else
            return vim.g.cmp_enabled
          end
        end,
        preselect = cmp.PreselectMode.None,
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = lspkind.cmp_format(utils.get_plugin_opts("lspkind.nvim")),
        },
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        duplicates = {
          nvim_lsp = 1,
          luasnip = 1,
          cmp_tabnine = 1,
          buffer = 1,
          path = 1,
        },
        confirm_opts = {
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        },
        window = {
          completion = cmp.config.window.bordered(border_opts),
          documentation = cmp.config.window.bordered(border_opts),
        },
        mapping = {
          ["<PageUp>"] = cmp.mapping.select_prev_item {
            behavior = cmp.SelectBehavior.Select,
            count = 8,
          },
          ["<PageDown>"] = cmp.mapping.select_next_item {
            behavior = cmp.SelectBehavior.Select,
            count = 8,
          },
          ["<C-PageUp>"] = cmp.mapping.select_prev_item {
            behavior = cmp.SelectBehavior.Select,
            count = 16,
          },
          ["<C-PageDown>"] = cmp.mapping.select_next_item {
            behavior = cmp.SelectBehavior.Select,
            count = 16,
          },
          ["<S-PageUp>"] = cmp.mapping.select_prev_item {
            behavior = cmp.SelectBehavior.Select,
            count = 16,
          },
          ["<S-PageDown>"] = cmp.mapping.select_next_item {
            behavior = cmp.SelectBehavior.Select,
            count = 16,
          },
          ["<Up>"] = cmp.mapping.select_prev_item {
            behavior = cmp.SelectBehavior.Select,
          },
          ["<Down>"] = cmp.mapping.select_next_item {
            behavior = cmp.SelectBehavior.Select,
          },
          ["<C-p>"] = cmp.mapping.select_prev_item {
            behavior = cmp.SelectBehavior.Insert,
          },
          ["<C-n>"] = cmp.mapping.select_next_item {
            behavior = cmp.SelectBehavior.Insert,
          },
          ["<C-k>"] = cmp.mapping.select_prev_item {
            behavior = cmp.SelectBehavior.Insert,
          },
          ["<C-j>"] = cmp.mapping.select_next_item {
            behavior = cmp.SelectBehavior.Insert,
          },
          ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
          ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<C-y>"] = cmp.config.disable,
          ["<C-e>"] = cmp.mapping {
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          },
          ["<CR>"] = cmp.mapping.confirm { select = false },
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = cmp.config.sources {
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip",  priority = 750 },
          { name = "buffer",   priority = 500 },
          { name = "path",     priority = 250 },
        },
      }
    end,
  },

}
