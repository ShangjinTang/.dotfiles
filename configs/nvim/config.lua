--[[
 THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT
 `lvim` is the global options object
]]
----------------------------------------------------------------------
-- General Settings

-- vim options
-- specify the python3 we use as nvim python
vim.g.python3_host_prog = os.getenv("PYTHON3_HOST_PROG")
-- save "TERMINAL_THEME" ('light' / 'dark')
vim.opt.background = os.getenv("TERMINAL_THEME")

lvim.log.level = "info"
lvim.leader = "space"

-- themes
lvim.colorscheme = "catppuccin"
lvim.transparent_window = os.getenv("TERMINAL_TRANSPARENT")

-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false

----------------------------------------------------------------------
-- Simple builtin configs

-- Dashboard (based on alpha.nvim)
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"

-- Git Blame Virtual Text at Current Line
lvim.builtin.gitsigns.opts.current_line_blame = true
lvim.builtin.gitsigns.opts.current_line_blame_formatter =
    "  <abbrev_sha>  <author>, <author_time:%Y-%m-%d> - <summary>"

-- Disable lir for oil.nvim
lvim.builtin.lir.active = false

-- Nvim Tree
lvim.builtin.nvimtree.setup.disable_netrw = true
lvim.builtin.nvimtree.setup.view = {
    adaptive_size = true,
    side = "left",
}
lvim.builtin.nvimtree.setup.actions.open_file.quit_on_open = false
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

-- Project Settings
lvim.builtin.project.manual_mode = false
lvim.builtin.project.silent_chdir = false
lvim.builtin.project.patterns = {
    ".git",
    ".root",
    ".project",
    ".workspace",
    "WORKSPACE",
    "Cargo.toml",
    "compile_commands.json",
    "cscope.out",
}

----------------------------------------------------------------------
-- lualine

local lualine_components = require("lvim.core.lualine.components")
lvim.builtin.lualine = {
    style = "lvim",
    options = {
        theme = "catppuccin",
        section_separators = {
            left = lvim.icons.ui.BoldDividerRight,
            right = lvim.icons.ui.BoldDividerLeft,
        },
        component_separators = {
            -- left = lvim.icons.ui.DividerRight,
            -- right = lvim.icons.ui.DividerLeft,
        },
    },
    sections = {
        lualine_a = {
            -- "mode",
            lualine_components.mode,
        },
        lualine_b = {
            lualine_components.treesitter,
            { "filename", path = 1 },
            { "filetype", icon_only = true },
        },
        lualine_c = {
            lualine_components.branch,
            lualine_components.diff,
        },
        lualine_x = {
            lualine_components.diagnostics,
            lualine_components.lsp,
        },
        lualine_y = {
            function()
                return lvim.icons.ui.Project .. " " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
            end,
        },
        lualine_z = {
            "progress",
        },
    },
}

----------------------------------------------------------------------
-- treesitter

-- Automatically install missing parsers when entering buffer
lvim.builtin.treesitter.auto_install = true

-- lvim.builtin.treesitter.ignore_install = { "haskell" }

-- -- always installed on startup, useful for parsers without a strict filetype
-- lvim.builtin.treesitter.ensure_installed = { "comment", "markdown_inline", "regex" }
lvim.builtin.treesitter.ensure_installed = {
    "bash",
    "c",
    "cmake",
    "comment",
    "css",
    "cuda",
    "diff",
    "dockerfile",
    "git_config",
    "gitcommit",
    "gitignore",
    "html",
    "ini",
    "java",
    "javascript",
    "json",
    "lua",
    "luadoc",
    "make",
    "markdown",
    "markdown_inline",
    "meson",
    "ninja",
    "proto",
    "regex",
    "rust",
    "toml",
    "vim",
    "vimdoc",
    "yaml",
}

-- -- generic LSP settings <https://www.lunarvim.org/docs/configuration/language-features/language-servers>

-- --- disable automatic installation of servers
-- lvim.lsp.installer.setup.automatic_installation = false

-- LSP: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- Core Programming Lanugages

-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. IMPORTANT: Requires `:LvimCacheReset` to take effect
-- ---`:LvimInfo` lists which server(s) are skipped for the current filetype
-- lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
--   return server ~= "emmet_ls"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

----------------------------------------------------------------------
-- null-ls

-- linters, formatters and code actions <https://www.lunarvim.org/docs/configuration/language-features/linting-and-formatting>
if os.getenv("FORMAT_ON_SAVE") == "true" then
    lvim.format_on_save = {
        enabled = true,
        -- pattern = "*.lua",
        timeout = 1000,
    }
else
    lvim.format_on_save.enabled = false
end
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
    { command = "trim_whitespace" },
    -- [BINARY] | cargo install stylua
    { command = "stylua", filetypes = { "lua" } },
    -- sudo pacman -Sy clang | sudo apt install -y clang-format
    { command = "clang_format", filetypes = { "c", "cpp", "cuda" } },
    -- npm install --global google-java-format
    { command = "google_java_format", extra_args = { "--aosp" }, filetypes = { "java" } },
    -- sudo pacman -Sy python-black | sudo apt install -y black
    { command = "black", filetypes = { "python" } },
    -- [BINARY] | sudo pacman -Sy shfmt | sudo apt install -y shfmt
    { command = "shfmt", extra_args = { "-sr", "-ci", "-i", "4" }, filetypes = { "sh", "bash" } },
    -- pip install beautysh
    { command = "beautysh", extra_args = { "-i", "4" }, filetypes = { "csh", "ksh", "zsh" } },
    -- rustup component add rustfmt
    { command = "rustfmt", filetypes = { "rust" } },
    -- [BINARY] | go install github.com/bazelbuild/buildtools/buildifier@latest | npm install --global @bazel/buildifier
    { command = "buildifier", filetypes = { "bzl" } },
    -- [BINARY] | cargo install cbfmt
    { command = "cbfmt", filetypes = { "markdown" } },
    -- [BINARY] | npm install --global @bufbuild/buf
    { command = "buf", filetypes = { "proto" } },
    -- pip install cmakelang
    { command = "cmake-format", filetypes = { "cmake" } },
    -- [BINARY] | npm install --global prettier
    {
        command = "prettier",
        -- extra_args = { "--print-width", "120", "tabWidth", "4" },
        extra_args = { "--print-width", "120" },
        filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "vue",
            "css",
            "scss",
            "less",
            "html",
            "json",
            "jsonc",
            "yaml",
            "markdown",
            "markdown.mdx",
            "graphql",
            "handlebars",
        },
    },
})

local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
    -- [BINARY] | go install github.com/bazelbuild/buildtools/buildifier@latest | npm install --global @bazel/buildifier
    { command = "buildifier", filetypes = { "bzl" } },
    -- [BINARY] | npm install --global @bufbuild/buf
    { command = "buf", filetypes = { "proto" } },
    -- pip install cmakelang
    { command = "cmake-lint", filetypes = { "cmake" } },
    -- [BINARY] | sudo pacman -Sy shellcheck | sudo apt install -y shellcheck
    { command = "shellcheck", filetypes = { "sh", "bash" }, args = { "--severity", "warning" } },
    -- zsh
    { command = "zsh", filetypes = { "zsh" } },
})

-- local code_actions = require("lvim.lsp.null-ls.code_actions")
-- code_actions.setup({
--     {
--         command = "eslint",
--         filetypes = { "typescript", "typescriptreact" },
--     },
-- })

----------------------------------------------------------------------
-- telescope

-- Telescope window width & height
lvim.builtin.telescope = {
    defaults = {
        layout_config = {
            width = { 0.8, max = 180 },
        },
        layout_strategy = "vertical",
    },
    pickers = {},
}
lvim.lsp.buffer_mappings = {
    normal_mode = {},
    insert_mode = {},
    visual_mode = {},
}

----------------------------------------------------------------------
-- plugins

-- Additional Plugins <https://www.lunarvim.org/docs/configuration/plugins/user-plugins>
lvim.plugins = {

    -- Plugins will be lazy-loaded when one of the following is true:
    --   - The plugin only exists as a dependency in your spec
    --   - It has an event, cmd, ft or keys key
    --   - Otherwise please specify 'lazy = true'

    -- The one and the only theme: catppuccin
    -- Reference: https://github.com/catppuccin/nvim
    -- Color Palette: https://github.com/catppuccin/nvim/blob/main/lua/catppuccin/palettes/frappe.lua
    -- Color API (lua): 'require("catppuccin.palettes").get_palette().<COLOR>'
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        dependencies = {
            "nvim-lualine/lualine.nvim",
            "rcarriga/nvim-dap-ui",
        },
        config = function()
            require("catppuccin").setup({
                -- flavour = "frappe", -- latte, frappe, macchiato, mocha
                background = {
                    -- :h background
                    light = "latte",
                    dark = "frappe",
                },
                transparent_background = os.getenv("TERMINAL_TRANSPARENT"),
                show_end_of_buffer = false, -- show the '~' characters after the end of buffers
                term_colors = false,
                dim_inactive = {
                    enabled = false,
                    shade = "dark",
                    percentage = 0.15,
                },
                no_italic = false, -- Force no italic
                no_bold = false, -- Force no bold
                styles = {
                    comments = { "italic" },
                    conditionals = { "italic" },
                    loops = {},
                    functions = {},
                    keywords = {},
                    strings = {},
                    variables = {},
                    numbers = {},
                    booleans = {},
                    properties = {},
                    types = {},
                    operators = {},
                },
                color_overrides = {},
                custom_highlights = {},
                integrations = {
                    alpha = true,
                    flash = true,
                    gitsigns = true,
                    indent_blankline = {
                        enabled = true,
                        colored_indent_levels = false,
                    },
                    nvimtree = true,
                    markdown = true,
                    mason = true,
                    neogit = true,
                    neotest = true,
                    noice = true,
                    cmp = true,
                    dap = {
                        enabled = true,
                        enable_ui = true, -- enable nvim-dap-ui
                    },
                    native_lsp = {
                        enabled = true,
                        virtual_text = {
                            errors = { "italic" },
                            hints = { "italic" },
                            warnings = { "italic" },
                            information = { "italic" },
                        },
                        underlines = {
                            errors = { "underline" },
                            hints = { "underline" },
                            warnings = { "underline" },
                            information = { "underline" },
                        },
                        inlay_hints = {
                            background = true,
                        },
                    },
                    navic = {
                        enabled = true,
                        custom_bg = "NONE",
                    },
                    notify = true,
                    treesitter_context = true,
                    treesitter = true,
                    overseer = true,
                    symbols_outline = true,
                    telekasten = true,
                    telescope = {
                        enabled = true,
                    },
                    lsp_trouble = true,
                    gitgutter = true,
                    illuminate = true,
                    which_key = true,
                },
            })
            require("notify").setup({
                background_colour = require("catppuccin.palettes").get_palette().base,
            })
            require("bufferline").setup({
                highlights = require("catppuccin.groups.integrations.bufferline").get(),
            })
            require("dap")
            local sign = vim.fn.sign_define
            sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
            sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
            sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
        end,
    },

    -----------------------------------------------------------------
    -- NOTE: AsyncRun & AsyncTasks

    -- Reference: https://github.com/skywind3000/asyncrun.vim
    {
        "skywind3000/asyncrun.vim",
        event = "VeryLazy",
        cmd = "AsyncRun",
    },

    -- Reference: https://github.com/skywind3000/asynctasks.vim
    {
        "skywind3000/asynctasks.vim",
        event = "VeryLazy",
        cmd = {
            "AsyncTask",
            "AsyncTaskList",
            "AsyncTaskLast",
            "AsyncTaskEdit",
            "AsyncTaskMacro",
            "AsyncTaskEnviron",
            "AsyncTaskProfile",
        },
        dependencies = {
            "skywind3000/asyncrun.vim",
        },
    },

    -- Reference: https://github.com/GustavoKatel/telescope-asynctasks.nvim
    {
        "GustavoKatel/telescope-asynctasks.nvim",
        event = "VeryLazy",
        dependencies = {
            "skywind3000/asynctasks.vim",
        },
    },

    -----------------------------------------------------------------
    -- NOTE: AI tools: ChatGPT & Copilot

    -- Reference: https://github.com/jackMort/ChatGPT.nvim
    {
        "jackMort/ChatGPT.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require("chatgpt").setup({
                api_key_cmd = "echo -n $OPENAI_API_KEY",
                openai_params = {
                    model = "gpt-3.5-turbo",
                    frequency_penalty = 0,
                    presence_penalty = 0,
                    max_tokens = 2048,
                    temperature = 0,
                    top_p = 1,
                    n = 1,
                },
            })
        end,
    },

    -- Reference: https://github.com/dpayne/CodeGPT.nvim
    {
        "dpayne/CodeGPT.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("codegpt.config")
        end,
    },

    -- Reference: https://github.com/zbirenbaum/copilot-cmp
    {
        "zbirenbaum/copilot-cmp",
        dependencies = {
            "zbirenbaum/copilot.lua",
        },
        event = "VeryLazy",
        config = function()
            require("copilot_cmp").setup()
        end,
    },
    -- Reference: https://github.com/zbirenbaum/copilot.lua
    -- Note: Use `:Copilot auth` to authenticate
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup()
        end,
    },

    -----------------------------------------------------------------
    -- NOTE: legacy code completion tools

    -- Reference: https://github.com/danymat/neogen
    {
        "danymat/neogen",
        event = "VeryLazy",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            local neogen = require("neogen")
            neogen.setup({
                snippet_engine = "luasnip",
            })
        end,
    },

    -- Reference: https://github.com/SirVer/ultisnips
    {
        "honza/vim-snippets",
        event = "VeryLazy",
        dependencies = {
            "SirVer/ultisnips",
        },
    },

    -----------------------------------------------------------------
    -- NOTE: file edit enhancement

    -- Reference: https://github.com/monaqa/dial.nvim
    {
        "monaqa/dial.nvim",
        event = "VeryLazy",
        config = function()
            local augend = require("dial.augend")
            require("dial.config").augends:register_group({
                default = {
                    augend.integer.alias.decimal_int,
                    augend.integer.alias.hex,
                    augend.date.alias["%Y/%m/%d"],
                    augend.date.alias["%Y-%m-%d"],
                    augend.date.alias["%m/%d"],
                    augend.date.alias["%H:%M"],
                    augend.constant.alias.bool,
                    -- augend.constant.new({
                    --     elements = { "and", "or" },
                    --     word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
                    --     cyclic = true, -- "or" is incremented into "and".
                    -- }),
                    -- augend.constant.new({
                    --     elements = { "&&", "||" },
                    --     word = false,
                    --     cyclic = true,
                    -- }),
                },
            })
            vim.keymap.set("n", "<C-a>", require("dial.map").inc_normal(), { noremap = true })
            vim.keymap.set("n", "<C-x>", require("dial.map").dec_normal(), { noremap = true })
            vim.keymap.set("n", "g<C-a>", require("dial.map").inc_gnormal(), { noremap = true })
            vim.keymap.set("n", "g<C-x>", require("dial.map").dec_gnormal(), { noremap = true })
            vim.keymap.set("v", "<C-a>", require("dial.map").inc_visual(), { noremap = true })
            vim.keymap.set("v", "<C-x>", require("dial.map").dec_visual(), { noremap = true })
            vim.keymap.set("v", "g<C-a>", require("dial.map").inc_gvisual(), { noremap = true })
            vim.keymap.set("v", "g<C-x>", require("dial.map").dec_gvisual(), { noremap = true })
        end,
    },

    -- Reference: https://github.com/nvim-pack/nvim-spectre
    {
        "nvim-pack/nvim-spectre",
        event = "VeryLazy",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("spectre").setup({
                live_update = true,
                default = {
                    find = {
                        cmd = "rg",
                        options = {},
                    },
                    replace = {
                        cmd = "sed",
                    },
                },
            })
        end,
    },

    -- Reference: https://github.com/kylechui/nvim-surround
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({})
        end,
    },

    -- Reference: https://github.com/windwp/nvim-ts-autotag
    {
        "windwp/nvim-ts-autotag",
        config = function()
            require("nvim-ts-autotag").setup({})
        end,
    },

    -- Reference: https://github.com/gbprod/substitute.nvim
    {
        "gbprod/substitute.nvim",
        lazy = true,
        config = function()
            require("substitute").setup({})
        end,
    },

    -- Reference: https://github.com/stevearc/oil.nvim
    {
        "stevearc/oil.nvim",
        -- event = "VeryLazy",
        config = function()
            require("oil").setup({
                columns = {
                    "icon",
                    -- "permissions",
                    -- "size",
                    -- "mtime",
                },
                buf_options = {
                    buflisted = true,
                    bufhidden = "hide",
                },
                default_file_explorer = true,
                keymaps = {
                    ["<CR>"] = "actions.select",
                    ["<BS>"] = "actions.parent",
                    ["<leader>-"] = "actions.select_split",
                    ["<leader>|"] = "actions.select_vsplit",
                    ["<C-t>"] = "actions.select_tab",
                    ["<C-p>"] = "actions.preview",
                    ["<C-c>"] = "actions.close",
                    ["<C-l>"] = "actions.refresh",
                    ["`"] = "actions.cd",
                    ["~"] = "actions.tcd",
                    ["<leader><leader>"] = "actions.open_cwd",
                    ["<leader>?"] = "actions.show_help",
                    ["<leader>."] = "actions.toggle_hidden",
                },
            })
        end,
    },

    -- Reference: https://github.com/Pocco81/auto-save.nvim
    {
        "Pocco81/auto-save.nvim",
        event = "VeryLazy",
        config = function()
            require("auto-save").setup({
                enable = true,
                execution_message = {
                    message = function() -- message to print on save
                        -- return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
                        return ""
                    end,
                },
                trigger_events = { "InsertLeave" },
            })
        end,
    },

    -----------------------------------------------------------------
    -- NOTE: file non-edit enhancement: move, highlight, show

    -- Reference: https://github.com/folke/flash.nvim
    {
        "folke/flash.nvim",
        event = "VeryLazy",
    },

    -- Reference: https://github.com/kevinhwang91/nvim-ufo
    {
        "kevinhwang91/nvim-ufo",
        event = "VeryLazy",
        dependencies = {
            "kevinhwang91/promise-async",
        },
        init = function()
            vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
            vim.o.foldcolumn = "1"
            vim.o.foldlevel = 99
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true
        end,
        config = function(_, opts)
            local handler = function(virtText, lnum, endLnum, width, truncate)
                local newVirtText = {}
                local totalLines = vim.api.nvim_buf_line_count(0)
                local foldedLines = endLnum - lnum
                local suffix = (" ↙️ %d %d%%"):format(foldedLines, foldedLines / totalLines * 100)
                local sufWidth = vim.fn.strdisplaywidth(suffix)
                local targetWidth = width - sufWidth
                local curWidth = 0
                for _, chunk in ipairs(virtText) do
                    local chunkText = chunk[1]
                    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    if targetWidth > curWidth + chunkWidth then
                        table.insert(newVirtText, chunk)
                    else
                        chunkText = truncate(chunkText, targetWidth - curWidth)
                        local hlGroup = chunk[2]
                        table.insert(newVirtText, { chunkText, hlGroup })
                        chunkWidth = vim.fn.strdisplaywidth(chunkText)
                        -- str width returned from truncate() may less than 2nd argument, need padding
                        if curWidth + chunkWidth < targetWidth then
                            suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
                        end
                        break
                    end
                    curWidth = curWidth + chunkWidth
                end
                local rAlignAppndx = math.max(math.min(vim.opt.textwidth["_value"], width - 1) - curWidth - sufWidth, 0)
                suffix = (" "):rep(rAlignAppndx) .. suffix
                table.insert(newVirtText, { suffix, "MoreMsg" })
                return newVirtText
            end
            require("ufo").setup({
                fold_virt_text_handler = handler,
                provider_selector = function()
                    return { "treesitter", "indent" }
                end,
            })
        end,
    },

    -- Reference: https://github.com/norcalli/nvim-colorizer.lua
    {
        "norcalli/nvim-colorizer.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("colorizer").setup({
                "css",
                "javascript",
                "html",
                "tmux",
                "yaml",
                "zsh",
                "json",
                "lua",
            })
        end,
    },

    -- Reference: https://github.com/folke/todo-comments.nvim
    {
        "folke/todo-comments.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("todo-comments").setup({})
        end,
    },

    -- Reference: https://github.com/folke/zen-mode.nvim
    {
        "folke/zen-mode.nvim",
        event = "VeryLazy",
        cmd = "ZenMode",
        config = function()
            require("zen-mode").setup({})
        end,
    },

    -- Reference: https://github.com/karb94/neoscroll.nvim
    {
        "karb94/neoscroll.nvim",
        event = "VeryLazy",
        config = function()
            require("neoscroll").setup({
                mappings = {
                    "<C-u>",
                    "<C-d>",
                    "<C-b>",
                    "<C-f>",
                    "<C-y>",
                    "<C-e>",
                    "zt",
                    "zz",
                    "zb",
                    -- Add PageUp & PageDown
                    "<PageUp>",
                    "<PageDown>",
                },
            })
            local t = {}
            t["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "250" } }
            t["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "250" } }
            t["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "450" } }
            t["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "450" } }
            t["<C-y>"] = { "scroll", { "-0.10", "false", "100" } }
            t["<C-e>"] = { "scroll", { "0.10", "false", "100" } }
            t["zt"] = { "zt", { "250" } }
            t["zz"] = { "zz", { "250" } }
            t["zb"] = { "zb", { "250" } }
            -- Add PageUp & PageDown
            t["<PageUp>"] = { "scroll", { "-vim.wo.scroll", "true", "250" } }
            t["<PageDown>"] = { "scroll", { "vim.wo.scroll", "true", "250" } }
            require("neoscroll.config").set_mappings(t)
        end,
    },

    -- Reference: https://github.com/petertriho/nvim-scrollbar
    {
        "petertriho/nvim-scrollbar",
        config = function()
            local palette = require("catppuccin.palettes").get_palette()
            require("scrollbar").setup({
                handle = {
                    blend = 20,
                },
                marks = {
                    Search = { color = palette.base },
                    Error = { color = palette.red },
                    Warn = { color = palette.yellow },
                    Info = { color = palette.blue },
                    Hint = { color = palette.green },
                    Misc = { color = palette.mauve },
                },
            })
        end,
    },

    -- Reference: https://github.com/simrat39/symbols-outline.nvim
    {
        -- "simrat39/symbols-outline.nvim",
        "enddeadroyal/symbols-outline.nvim",
        branch = "bugfix/symbol-hover-misplacement",
        event = "VeryLazy",
        config = function()
            require("symbols-outline").setup({})
        end,
    },

    -- Reference: https://github.com/ethanholz/nvim-lastplace
    {
        "ethanholz/nvim-lastplace",
        config = function()
            require("nvim-lastplace").setup({})
        end,
    },

    -- Reference: https://github.com/AckslD/nvim-neoclip.lua
    {
        "AckslD/nvim-neoclip.lua",
        event = "VeryLazy",
        dependencies = {
            { "kkharji/sqlite.lua", module = "sqlite" },
            { "nvim-telescope/telescope.nvim" },
        },
        config = function()
            local function is_whitespace(line)
                return vim.fn.match(line, [[^\s*$]]) ~= -1
            end
            local function all(tbl, check)
                for _, entry in ipairs(tbl) do
                    if not check(entry) then
                        return false
                    end
                end
                return true
            end
            require("neoclip").setup({
                history = 10000,
                enable_persistent_history = true,
                continuous_sync = true,
                on_select = {
                    move_to_front = true,
                },
                on_paste = {
                    move_to_front = true,
                },
                on_replay = {
                    move_to_front = true,
                },
                filter = function(data)
                    return not all(data.event.regcontents, is_whitespace)
                end,
            })
        end,
    },

    -- Reference: https://github.com/christoomey/vim-tmux-navigator
    {
        "christoomey/vim-tmux-navigator",
        event = "VeryLazy",
    },

    -- Reference: https://github.com/nvim-focus/focus.nvim
    {
        "nvim-focus/focus.nvim",
        event = "VeryLazy",
        config = function()
            require("focus").setup({})
        end,
    },

    -----------------------------------------------------------------
    -- NOTE: git

    -- Reference: https://github.com/sindrets/diffview.nvim
    {
        "sindrets/diffview.nvim",
        event = "VeryLazy",
        cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    },

    -- Reference: https://github.com/tpope/vim-fugitive
    {
        "tpope/vim-fugitive",
        event = "VeryLazy",
        cmd = { "Git", "G" },
    },

    -----------------------------------------------------------------
    -- NOTE: markdown

    -- Reference: https://github.com/renerocksai/telekasten.nvim
    {
        "renerocksai/telekasten.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "renerocksai/calendar-vim",
        },
        config = function()
            require("telekasten").setup({
                home = vim.fn.expand("~/note/"),
            })
        end,
    },

    -- Reference: https://github.com/jakewvincent/mkdnflow.nvim
    {
        "jakewvincent/mkdnflow.nvim",
        ft = "markdown",
        event = "VeryLazy",
        config = function()
            require("mkdnflow").setup({
                modules = {
                    bib = true,
                    buffers = true,
                    conceal = true,
                    cursor = true,
                    folds = true,
                    links = true,
                    maps = false,
                    lists = true,
                    paths = true,
                    tables = true,
                    yaml = false,
                },
                links = {
                    transform_explicit = function(text)
                        text = text:gsub(" ", "-")
                        text = text:lower()
                        -- text = os.date("%Y-%m-%d_") .. text
                        return text
                    end,
                },
                to_do = {
                    symbols = { " ", "-", "x" },
                    update_parents = true,
                    not_started = " ",
                    in_progress = "-",
                    complete = "x",
                },
            })
        end,
    },

    -- Reference: https://github.com/AckslD/nvim-FeMaco.lua
    {
        "AckslD/nvim-FeMaco.lua",
        ft = { "markdown" },
        event = "VeryLazy",
        config = function()
            require("femaco").setup({
                post_open_float = function(winnr)
                    vim.cmd([[ set number ]])
                    vim.cmd([[ set norelativenumber ]])
                end,
                ensure_newline = function(base_filetype)
                    return true
                end,
            })
        end,
    },

    -- Reference: https://github.com/iamcco/markdown-preview.nvim
    {
        "iamcco/markdown-preview.nvim",
        ft = "markdown",
        cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
        event = "VeryLazy",
        config = function()
            vim.fn["mkdp#util#install"]()
        end,
    },

    -----------------------------------------------------------------
    -- NOTE: code runner & debugger

    -- Reference: https://github.com/michaelb/sniprun
    {
        "michaelb/sniprun",
        event = "VeryLazy",
        build = "sh ./install.sh 1",
        config = function()
            require("sniprun").setup({
                display = {
                    "Classic", --# display results in the command-line  area
                    "VirtualTextOk", --# display ok results as virtual text (multiline is shortened)
                    -- "VirtualText", --# display results as virtual text
                    "TempFloatingWindow", --# display results in a floating window
                    -- "LongTempFloatingWindow", --# same as above, but only long results. To use with VirtualText[Ok/Err]
                    -- "Terminal", --# display results in a vertical split
                    -- "TerminalWithCode", --# display results and code history in a vertical split
                    -- "NvimNotify", --# display with the nvim-notify plugin
                    -- "Api"                      --# return output to a programming interface
                },
                -- Catppuccin theme color
                snipruncolors = {
                    SniprunVirtualTextOk = { bg = "#ca9ee6", fg = "#000000" },
                    SniprunFloatingWinOk = { fg = "#ca9ee6" },
                    SniprunVirtualTextErr = { bg = "#e78284", fg = "#000000" },
                    SniprunFloatingWinErr = { fg = "#e78284" },
                },
            })
            vim.api.nvim_set_keymap("v", "<Bslash>", "<Plug>SnipRun", { silent = true })
        end,
    },

    -- Reference: https://github.com/jay-babu/mason-nvim-dap.nvim
    {
        "jay-babu/mason-nvim-dap.nvim",
        event = "VeryLazy",
        dependencies = {
            "williamboman/mason.nvim",
        },
        config = function()
            require("mason-nvim-dap").setup({
                -- See: https://github.com/jay-babu/mason-nvim-dap.nvim/blob/main/lua/mason-nvim-dap/mappings/source.lua
                ensure_installed = { "python", "cppdbg" },
                handlers = {
                    function(config)
                        -- Keep original functionality
                        require("mason-nvim-dap").default_setup(config)
                    end,
                    -- requires: python3 -m pip install debugpy
                    python = function(config)
                        config.adapters = {
                            type = "executable",
                            command = vim.fn["exepath"]("python3"),
                            args = {
                                "-m",
                                "debugpy.adapter",
                            },
                        }
                        require("mason-nvim-dap").default_setup(config) -- don't forget this!
                    end,
                },
            })
        end,
    },

    -- Reference: https://github.com/theHamsta/nvim-dap-virtual-text
    {
        "theHamsta/nvim-dap-virtual-text",
        event = "VeryLazy",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("nvim-dap-virtual-text").setup({})
        end,
    },

    -- Reference: https://github.com/nvim-telescope/telescope-dap.nvim
    {
        "nvim-telescope/telescope-dap.nvim",
        event = "VeryLazy",
        cmd = "Telescope dap",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-treesitter/nvim-treesitter",
            "folke/which-key.nvim",
        },
    },

    -- Reference: https://github.com/nvim-neotest/neotest
    {
        "nvim-neotest/neotest",
        event = "VeryLazy",
        ft = "python",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-neotest/neotest-python",
            "rouge8/neotest-rust",
            "folke/neodev.nvim",
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-python")({}),
                    require("neotest-rust")({}),
                },
            })
            require("neodev").setup({
                library = { plugins = { "neotest" }, types = true },
            })
        end,
    },

    -----------------------------------------------------------------
    -- NOTE: cscope & ctags

    -- Reference: https://github.com/ludovicchabant/vim-gutentags
    {
        "dhananjaylatkar/vim-gutentags",
        event = "VeryLazy",
        dependencies = {
            "dhananjaylatkar/cscope_maps.nvim",
            "folke/which-key.nvim",
            "nvim-telescope/telescope.nvim",
            -- "ibhagwan/fzf-lua",
            "nvim-tree/nvim-web-devicons",
        },
        init = function()
            vim.g.gutentags_modules = { "cscope_maps" } -- This is required. Other config is optional
            vim.g.gutentags_cscope_build_inverted_index_maps = 1
            vim.g.gutentags_file_list_command = "fd -e c -e h -e cpp -e java"
            vim.g.gutentags_cache_dir = tags_dir
            vim.g.gutentags_project_root = {
                ".git",
                ".root",
                ".project",
                ".workspace",
                "WORKSPACE",
                "Cargo.toml",
                "compile_commands.json",
                "cscope.out",
            }
            vim.g.gutentags_ctags_tagfile = ".tags"
            vim.g.gutentags_ctags_extra_args = { "--fields=+niazS", "--extra=+q", "--c++-kinds=+pxI", "--c-kinds=+px" }
            -- vim.g.gutentags_trace = 1
        end,
        config = function()
            require("cscope_maps").setup({
                disable_maps = true,
                skip_input_prompt = true,
                cscope = {
                    db_file = "./cscope.out",
                    exec = "cscope", -- "cscope" or "gtags-cscope"
                    picker = "telescope", -- "telescope", "fzf-lua" or "quickfix"
                    skip_picker_for_single_result = false, -- "false" or "true"
                    db_build_cmd_args = { "-Rbqkv" },
                    statusline_indicator = nil,
                },
            })
            local tags_dir = vim.fn.expand("~/.cache/tags")
            if vim.fn.isdirectory(tags_dir) == 0 then
                vim.fn.mkdir(tags_dir, "p")
            end
        end,
    },

    -----------------------------------------------------------------
    -- NOTE: LSPs & treesitter

    -- Reference: https://github.com/williamboman/mason-lspconfig.nvim
    {
        "williamboman/mason-lspconfig.nvim",
        event = "VeryLazy",
        dependencies = {
            "williamboman/mason.nvim",
        },
        config = function()
            require("mason").setup({})
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "clangd",
                    "jdtls",
                    "pyright",
                    "bashls",
                    "rust_analyzer",
                    "lua_ls",
                    "vimls",
                    "html",
                    "marksman",
                },
            })
        end,
    },

    -- Reference: https://github.com/folke/neodev.nvim
    {
        "folke/neodev.nvim",
        event = "VeryLazy",
        config = function()
            require("neodev").setup({})
        end,
    },

    -- Reference: https://github.com/rmagatti/goto-preview
    {
        "rmagatti/goto-preview",
        event = "VeryLazy",
        config = function()
            require("goto-preview").setup({
                default_mappings = false,
            })
        end,
    },

    -- Reference: https://github.com/folke/trouble.nvim
    {
        "folke/trouble.nvim",
        cmd = "TroubleToggle",
        config = function()
            local actions = require("telescope.actions")
            local trouble = require("trouble.providers.telescope")
            local telescope = require("telescope")
            telescope.setup({
                defaults = {
                    mappings = {
                        i = { ["<c-t>"] = trouble.open_with_trouble },
                        n = { ["<c-t>"] = trouble.open_with_trouble },
                    },
                },
            })
        end,
    },

    -- Reference: https://github.com/WhoIsSethDaniel/toggle-lsp-diagnostics.nvim
    {
        "WhoIsSethDaniel/toggle-lsp-diagnostics.nvim",
        event = "VeryLazy",
        cmd = { "ToggleDiag", "ToggleDiagDefault", "ToggleDiagOn", "ToggleDiagOff" },
        config = function()
            require("toggle_lsp_diagnostics").init({
                start_on = true,
                -- See: https://neovim.io/doc/user/diagnostic.html#vim.diagnostic.config()
                underline = true,
                virtual_text = false,
                update_in_insert = false,
            })
        end,
    },

    -- Reference: https://github.com/nvim-treesitter/nvim-treesitter-context
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = "VeryLazy",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("treesitter-context").setup({})
        end,
    },

    -- Reference: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        event = "VeryLazy",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("nvim-treesitter.configs").setup({
                textobjects = {
                    select = {
                        enable = true,

                        -- Automatically jump forward to textobj, similar to targets.vim
                        lookahead = true,

                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            -- You can optionally set descriptions to the mappings (used in the desc parameter of
                            -- nvim_buf_set_keymap) which plugins like which-key display
                            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                            -- You can also use captures from other query groups like `locals.scm`
                            ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
                        },
                        selection_modes = {
                            ["@parameter.outer"] = "v", -- charwise
                            ["@function.outer"] = "V", -- linewise
                            ["@class.outer"] = "<c-v>", -- blockwise
                        },
                        include_surrounding_whitespace = true,
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            ["]f"] = "@function.outer",
                            ["]b"] = "@block.outer",
                            ["]c"] = { query = "@class.outer", desc = "Next class start" },
                            ["]o"] = "@loop.*",
                            -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
                            ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
                        },
                        goto_previous_start = {
                            ["[f"] = "@function.outer",
                            ["[b"] = "@block.outer",
                            ["[c"] = "@class.outer",
                        },
                        -- goto_next = {
                        --     ["]d"] = "@conditional.outer",
                        -- },
                        -- goto_previous = {
                        --     ["[d"] = "@conditional.outer",
                        -- },
                    },
                },
            })
        end,
    },

    -- Reference: https://github.com/SmiteshP/nvim-navic
    {
        "SmiteshP/nvim-navic",
        event = "VeryLazy",
        dependencies = {
            "neovim/nvim-lspconfig",
        },
    },

    -- Reference: https://github.com/simrat39/rust-tools.nvim
    {
        "simrat39/rust-tools.nvim",
        event = "VeryLazy",
        ft = "rust",
        dependencies = {
            "neovim/nvim-lspconfig",
        },
        config = function()
            require("rust-tools").setup({})
        end,
    },

    -----------------------------------------------------------------
    -- NOTE: nvim: project management

    -- Reference: https://github.com/junegunn/fzf.vim
    {
        "junegunn/fzf.vim",
        event = "VeryLazy",
        dependencies = {
            "junegunn/fzf",
        },
        cmd = {
            "Files",
            "GFiles",
            "Buffers",
            "Colors",
            "Rg",
            "Lines",
            "BLines",
            "Tags",
            "BTags",
            "Marks",
            "Windows",
            "Locate",
            "History",
            "Snippets",
            "Commits",
            "BCommits",
            "Commands",
            "Maps",
            "Helptags",
            "Filetypes",
        },
    },

    -- Reference: https://github.com/MattesGroeger/vim-bookmarks
    {
        "MattesGroeger/vim-bookmarks",
        event = "VeryLazy",
        init = function()
            vim.g.bookmark_no_default_key_mappings = 1
        end,
    },

    -----------------------------------------------------------------
    -- NOTE: nvim: status line & notifications

    -- Reference: https://github.com/folke/noice.nvim
    {
        "folke/noice.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        config = function()
            require("noice").setup({
                cmdline = {
                    view = "cmdline",
                    enable = false,
                },
                messages = {
                    enable = false,
                },
                lsp = {
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true,
                    },
                },
                presets = {
                    bottom_search = true, -- use a classic bottom cmdline for search
                    command_palette = true, -- position the cmdline and popupmenu together
                    long_message_to_split = true, -- long messages will be sent to a split
                    inc_rename = true, -- enables an input dialog for inc-rename.nvim
                    lsp_doc_border = true, -- add a border to hover docs and signature help
                },
            })
        end,
    },

    -- Reference: https://github.com/gelguy/wilder.nvim
    {
        "gelguy/wilder.nvim",
        event = { "VeryLazy", "CmdlineEnter" },
        dependencies = {
            "romgrk/fzy-lua-native",
        },
        config = function()
            local wilder = require("wilder")
            wilder.setup({ modes = { ":", "/", "?" } })

            wilder.set_option("pipeline", {
                wilder.branch(
                    wilder.python_file_finder_pipeline({
                        file_command = { "rg", "--files" },
                        dir_command = { "fd", "-td" },
                        filters = { "fuzzy_filter", "difflib_sorter" },
                    }),
                    wilder.substitute_pipeline({
                        pipeline = wilder.python_search_pipeline({
                            skip_cmdtype_check = 1,
                            pattern = wilder.python_fuzzy_pattern({
                                start_at_boundary = 0,
                            }),
                        }),
                    }),
                    wilder.cmdline_pipeline({
                        fuzzy = 2,
                        fuzzy_filter = wilder.lua_fzy_filter(),
                    }),
                    {
                        wilder.check(function(ctx, x)
                            return x == ""
                        end),
                        wilder.history(),
                    },
                    wilder.python_search_pipeline({
                        pattern = wilder.python_fuzzy_pattern({
                            start_at_boundary = 0,
                        }),
                    })
                ),
            })

            local highlighters = {
                wilder.pcre2_highlighter(),
                wilder.lua_fzy_highlighter(),
            }

            local popupmenu_renderer = wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
                border = "rounded",
                winblend = 20,
                empty_message = wilder.popupmenu_empty_message_with_spinner(),
                highlighter = highlighters,
                left = {
                    " ",
                    wilder.popupmenu_devicons(),
                    wilder.popupmenu_buffer_flags({
                        flags = " a + ",
                        icons = { ["+"] = "", a = "", h = "" },
                    }),
                },
                right = {
                    " ",
                    wilder.popupmenu_scrollbar(),
                },
            }))

            local wildmenu_renderer = wilder.wildmenu_renderer({
                highlighter = highlighters,
                separator = " · ",
                left = { " ", wilder.wildmenu_spinner(), " " },
                right = { " ", wilder.wildmenu_index() },
            })

            wilder.set_option(
                "renderer",
                wilder.renderer_mux({
                    [":"] = popupmenu_renderer,
                    ["/"] = wildmenu_renderer,
                    substitute = wildmenu_renderer,
                })
            )
        end,
    },

    -----------------------------------------------------------------
    -- NOTE: uncategorized

    -- Reference: https://github.com/ojroques/nvim-osc52
    {
        "ojroques/nvim-osc52",
        event = "VeryLazy",
    },

    -- Reference: https://github.com/rafcamlet/nvim-luapad
    {
        "rafcamlet/nvim-luapad",
        event = "VeryLazy",
        config = function()
            require("luapad").setup({})
        end,
    },

    -- NOTE: dropbar requires nvim >= 0.10.0
    -- Reference: https://github.com/Bekaboo/dropbar.nvim
    -- {
    --     "Bekaboo/dropbar.nvim",
    --     event = "VeryLazy",
    --     config = function()
    --         require("dropbar").setup({})
    --     end,
    -- },
}

----------------------------------------------------------------------
-- LSP

local navic = require("nvim-navic")
local lsp_on_attach = function(client, bufnr)
    if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
    end
end

-- ---configure a server manually. IMPORTANT: Requires `:LvimCacheReset` to take effect
-- ---see the full default list `:lua =lvim.lsp.automatic_configuration.skipped_servers`
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, {
    "clangd",
    "jdtls",
    "pyright",
    "bashls",
    "rust_analyzer",
    "lua_ls",
    "vimls",
    "html",
    "marksman",
})
local lspmanager = require("lvim.lsp.manager")
lspmanager.setup("clangd", {
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--all-scopes-completion",
        "--completion-style=detailed",
        "--header-insertion=iwyu",
        "--header-insertion-decorators",
        "--limit-results=100",
        "--suggest-missing-includes",
        "-j=12",
        "--pch-storage=memory",
        "--offset-encoding=utf-16", -- Fix "warning: multiple different client offset_encodings detected" when using clangd with copilot
    },
    on_attach = lsp_on_attach,
})
lspmanager.setup("jdtls", { -- requires: sudo apt install -y openjdk-17-jdk | sudo pacman -Sy jdk17-openjdk
    on_attach = lsp_on_attach,
    cmd = { "jdtls" },
})
lspmanager.setup("pyright", {
    on_attach = lsp_on_attach,
})
lspmanager.setup("bashls", {
    on_attach = lsp_on_attach,
})
lspmanager.setup("rust_analyzer", {
    on_attach = lsp_on_attach,
})
-- NVIM / VIM
lspmanager.setup("lua_ls", {
    on_attach = lsp_on_attach,
    settings = {
        Lua = {
            completion = {
                callSnippet = "Replace",
            },
        },
    },
})
lspmanager.setup("vimls", {
    on_attach = lsp_on_attach,
})
-- HTML / CSS / JavaScript
lspmanager.setup("html", {
    on_attach = lsp_on_attach,
})
-- Markup Languages
lspmanager.setup("marksman", {
    on_attach = lsp_on_attach,
})
