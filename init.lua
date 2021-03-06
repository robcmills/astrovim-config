local config = {

  -- Configure AstroNvim updates
  updater = {
    remote = "origin", -- remote to use
    channel = "nightly", -- "stable" or "nightly"
    version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
    branch = "main", -- branch name (NIGHTLY ONLY)
    commit = nil, -- commit hash (NIGHTLY ONLY)
    pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
    skip_prompts = false, -- skip prompts about breaking changes
    show_changelog = true, -- show the changelog after performing an update
    -- remotes = { -- easily add new remotes to track
    --   ["remote_name"] = "https://remote_url.come/repo.git", -- full remote url
    --   ["remote2"] = "github_user/repo", -- GitHub user/repo shortcut,
    --   ["remote3"] = "github_user", -- GitHub user assume AstroNvim fork
    -- },
  },

  -- Set colorscheme
  colorscheme = "default_theme",

  -- set vim options here (vim.<first_key>.<second_key> =  value)
  options = {
    opt = {
      relativenumber = false, -- sets vim.opt.relativenumber
      path = vim.opt.path + '**',
      scrolloff = 0,
    },
    g = {
      mapleader = " ", -- sets vim.g.mapleader
    },
  },

  header = {
    "                 ▒▒",
    "       /████████\\▒▒▒▒  /████████\\",
    "       \\████████/▒▒▒▒▒▒\\████████/",
    "        |██████|▒▒▒▒▒▒▒▒/█████/",
    "        |██████|▒▒▒▒▒▒/█████/",
    "       ▒|██████|▒▒▒▒/█████/▒▒",
    "     ▒▒▒|██████|▒▒/█████/▒▒▒▒▒▒",
    "   ▒▒▒▒▒|██████|/█████/▒▒▒▒▒▒▒▒▒▒",
    "     ▒▒▒|███████████/▒▒▒▒▒▒▒▒▒▒",
    "       ▒|█████████/▒▒▒▒▒▒▒▒▒▒",
    "        |███████/▒▒▒▒▒▒▒▒▒▒",
    "        |█████/▒▒▒▒▒▒▒▒▒▒",
    "        |███/▒▒▒▒▒▒▒▒▒▒",
    "        |█/   ▒▒▒▒▒▒▒",
    "                 ▒▒",
  },

  -- Default theme configuration
  default_theme = {
    diagnostics_style = { italic = true },
    -- Modify the color table
    colors = {
      fg = "#abb2bf",
    },
    -- Modify the highlight groups
    highlights = function(highlights)
      local C = require "default_theme.colors"
      highlights.Normal = { fg = C.fg, bg = C.bg }
      highlights.CursorLine = { fg = C.none, bg = C.docker }
      return highlights
    end,
    plugins = { -- enable or disable extra plugin highlighting
      beacon = false,
      bufferline = true,
      dashboard = true,
      highlighturl = true,
      hop = false,
      indent_blankline = true,
      lightspeed = false,
      ["neo-tree"] = true,
      notify = true,
      ["nvim-tree"] = false,
      ["nvim-web-devicons"] = true,
      rainbow = true,
      symbols_outline = false,
      telescope = true,
      vimwiki = false,
      ["which-key"] = true,
    },
  },

  -- Disable AstroNvim ui features
  ui = {
    nui_input = true,
    telescope_select = true,
  },

  -- Configure plugins
  plugins = {
    -- Add plugins, the packer syntax without the "use"
    init = {
      -- You can disable default plugins as follows:
      -- ["goolord/alpha-nvim"] = { disable = true },

      -- You can also add new plugins here as well:
      { "github/copilot.vim" },
      -- { "andweeb/presence.nvim" },
      -- {
      --   "ray-x/lsp_signature.nvim",
      --   event = "BufRead",
      --   config = function()
      --     require("lsp_signature").setup()
      --   end,
      -- },
    },
    -- All other entries override the setup() call for default plugins
    ["bufferline"] = {
      numbers = 'ordinal',
    },
    feline = function(config)
      config.components.active[1][1] = {
        provider = 'vi_mode',
        -- hl = require("core.status").hl.mode(),
        hl = function()
          local modes = require("core.status").modes
          local colors = require "default_theme.colors"
          return {
            name = require('feline.providers.vi_mode').get_mode_highlight_name(),
            -- fg = require('feline.providers.vi_mode').get_mode_color(),
            fg = colors.bg_1,
            bg = modes[vim.fn.mode()][3],
            style = 'bold'
          }
        end,
        left_sep = 'block',
        right_sep = 'block',
        icon = '' -- disable icons for this component and use the mode name instead
      }
      config.components.active[1][5] = {
        provider = {
          name = "file_info",
          opts = { type = 'relative' },
        },
      }
      config.components.active[2][11] = nil
      config.components.active[2][12] = nil
      return config
    end,
    ["neo-tree"] = {
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
        },
      },
      window = {
        width = 50,
      },
    },
    ["null-ls"] = function(config)
      local null_ls = require "null-ls"
      -- Check supported formatters and linters
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
      config.sources = {
        -- Set a formatter
        null_ls.builtins.formatting.rufo,
        -- Set a linter
        null_ls.builtins.diagnostics.rubocop,
      }
      -- set up null-ls's on_attach function
      config.on_attach = function(client)
        -- NOTE: You can remove this on attach function to disable format on save
        if client.resolved_capabilities.document_formatting then
          vim.api.nvim_create_autocmd("BufWritePre", {
            desc = "Auto format before save",
            pattern = "<buffer>",
            callback = vim.lsp.buf.formatting_sync,
          })
        end
      end
      return config -- return final config table
    end,
    telescope = {
      defaults = {
        no_ignore = true,
      },
      pickers = {
        lsp_references = {
          show_line = false
        },
      },
    },
    treesitter = {
      auto_install = true,
      ensure_installed = { "lua" },
      indent = { enable = true },
    },
    ["nvim-lsp-installer"] = {
      ensure_installed = { "sumneko_lua" },
    },
    packer = {
      compile_path = vim.fn.stdpath "config" .. "/lua/packer_compiled.lua",
    },
  },

  -- LuaSnip Options
  luasnip = {
    -- Add paths for including more VS Code style snippets in luasnip
    vscode_snippet_paths = {},
    -- Extend filetypes
    filetype_extend = {
      javascript = { "javascriptreact" },
    },
  },

  -- Modify which-key registration
  ["which-key"] = {
    -- Add bindings
    register_mappings = {
      -- first key is the mode, n == normal mode
      n = {
        -- second key is the prefix, <leader> prefixes
        ["<leader>"] = {
          -- which-key registration table for normal mode, leader prefix
          -- ["N"] = { "<cmd>tabnew<cr>", "New Buffer" },
          ["a"] = { "<cmd>EslintFixAll<cr>", "ESLint Fix all" },
          ["b"] = { "<cmd>BufferLinePick<cr>", "BufferLinePick" },
        },
      },
    },
  },

  -- CMP Source Priorities
  -- modify here the priorities of default cmp sources
  -- higher value == higher priority
  -- The value can also be set to a boolean for disabling default sources:
  -- false == disabled
  -- true == 1000
  cmp = {
    source_priority = {
      nvim_lsp = 1000,
      luasnip = 750,
      buffer = 500,
      path = 250,
    },
  },

  -- Extend LSP configuration
  lsp = {
    -- enable servers that you already have installed without lsp-installer
    servers = {
      "eslint",
      "jsonls",
      "tsserver",
      -- "pyright"
    },

    on_attach = function(client)
      if (client.name == "eslint") then
        -- Stop eslint from attaching to files in node_modules to avoid excessive lint errors
        local is_node_module = false
        for _,workspace_folder in pairs(client.workspace_folders) do
          if (string.find(workspace_folder.name, "node_modules")) then
            is_node_module = true
          end
        end
        if (is_node_module) then
          vim.lsp.stop_client(client.id)
        end
      end
    end,

    -- override the lsp installer server-registration function
    -- server_registration = function(server, opts)
    --   require("lspconfig")[server].setup(opts)
    -- end,

    -- Add overrides for LSP server settings, the keys are the name of the server
    ["server-settings"] = {
      -- example for addings schemas to yamlls
      -- yamlls = {
      --   settings = {
      --     yaml = {
      --       schemas = {
      --         ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}",
      --         ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
      --         ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
      --       },
      --     },
      --   },
      -- },
    },
  },

  -- Diagnostics configuration (for vim.diagnostics.config({}))
  diagnostics = {
    virtual_text = false,
    update_in_insert = false,
  },

  -- This function is run last
  -- good place to configure mappings and vim options
  polish = function()
    -- Set key bindings
    vim.keymap.set("n", "J", "<C-d>")
    vim.keymap.set("n", "K", "<C-u>")
    vim.keymap.set("n", "s", "<cmd>wa<cr>", { desc = "Save" })
    vim.keymap.set("n", "<leader>yf", ":let @+ = expand('%')<cr>", { desc = "Copy filepath" })
    vim.keymap.set("n", "<leader>C", ":%bd<cr>", { desc = "Close all buffers" })

    -- Set autocommands
    vim.api.nvim_create_augroup("packer_conf", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePost", {
      desc = "Sync packer after modifying plugins.lua",
      group = "packer_conf",
      pattern = "plugins.lua",
      command = "source <afile> | PackerSync",
    })

    -- Set up custom filetypes
    -- vim.filetype.add {
    --   extension = {
    --     foo = "fooscript",
    --   },
    --   filename = {
    --     ["Foofile"] = "fooscript",
    --   },
    --   pattern = {
    --     ["~/%.config/foo/.*"] = "fooscript",
    --   },
    -- }

  end,
}

return config
