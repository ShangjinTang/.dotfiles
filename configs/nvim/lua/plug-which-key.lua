-- Reference: https://github.com/folke/which-key.nvim

local wk = require("which-key")

wk.register({
    ["<leader>c"] = { name = "+Cscope" },
})

wk.register({
    ["<C-p>"] = { "<cmd>Telescope lsp_definitions<cr>", "Goto Definition" },
    ["K"] = { vim.lsp.buf.hover, "Hover" },
    ["gd"] = { "<cmd>Telescope lsp_definitions<cr>", "Goto Definition" },
    ["gi"] = { "<cmd>Telescope lsp_implementations<cr>", "Goto Implementation" },
    ["gt"] = { "<cmd>Telescope lsp_type_definitions<cr>", "Goto Type Definition" },
    ["gr"] = { "<cmd>Telescope lsp_references<cr>", "Goto References" },
})

wk.register({
    ["<leader>["] = { "<cmd>BufferLineCyclePrev<cr>", "Previous Buffer" },
    ["<leader>]"] = { "<cmd>BufferLineCycleNext<cr>", "Next Buffer" },
    ["<leader><tab>"] = { "<cmd>b#<cr>", "Switch between buffers" },
    ["<leader>q"] = { "<cmd>qa!<cr>", "Force Quit" },
    ["<leader>w"] = { "<cmd>bd<cr>", "Close Buffer" },
    ["<leader>z"] = { "<cmd>ZenMode<cr>", "Zen Mode" },
})

wk.register({
    ["<leader>a"] = { name = "+AsyncRun" },
    ["<leader>as"] = { "<cmd>call AsyncRunWith('')<left><left>", "Asyncrun Command" },
    ["<leader>aq"] = { "<cmd>VimuxCloseRunner<cr>", "Quit Asyncrun Window" },
})

wk.register({
    ["<leader>bb"] = { "<cmd>Telescope buffers previewer=false<cr>", "Find" },
})

wk.register({
    ["<leader>f"] = { name = "+File" },
    ["<leader>ff"] = { "<cmd>Telescope find_files previewer=false<cr>", "Find File" },
    ["<leader>fw"] = { "<cmd>Telescope grep_string<cr>", "File Grep Current Word" },
    ["<leader>fg"] = { "<cmd>Telescope live_grep<cr>", "File Live Grep" },
    ["<leader>fr"] = { "<cmd>Telescope oldfiles previewer=true<cr>", "Open Recent File" },
    ["<leader>fn"] = { "<cmd>enew<cr>", "New File" },
})

wk.register({
    ["<leader>gf"] = {
        function()
            require("lvim.core.telescope.custom-finders").find_project_files { previewer = false }
        end,
        "Find Git File",
    },
})

wk.register({
    ["<leader>o"] = { name = "+Open with" },
    ["<leader>oc"] = { "<cmd>call OpenCurrentFileWith('code')<cr>", "Open with vscode" },
})

wk.register({
    ["<leader>p"] = { name = "+Project" },
    ["<leader>pp"] = { "<cmd>Telescope projects<cr>", "Recent Projects" },
    ["<leader>pf"] = {
        function()
            require("telescope.builtin").find_files({ cwd = vim.api.nvim_eval('FindRootDirectory()') })
        end,
        "Find Project File",
    },
    ["<leader>pw"] = {
        function()
            require("telescope.builtin").grep_string({ cwd = vim.api.nvim_eval('FindRootDirectory()') })
        end,
        "Project Grep Current Word",
    },
    ["<leader>pg"] = {
        function()
            require("telescope.builtin").live_grep({ cwd = vim.api.nvim_eval('FindRootDirectory()') })
        end,
        "Project Live Grep",
    },
})
