-- Reference: https://github.com/folke/which-key.nvim

local wk = require("which-key")
local normal_mode = { mode = "n" }
local normal_mode_with_expr = { mode = "n", expr = true }
local visual_mode = { mode = "v" }

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Global Mappings: both normal mode & visual mode

wk.register({
    ["s"] = { require("substitute").operator, "Substitute Operator" },
    ["ss"] = { require("substitute").line, "Substitute Line" },
    ["S"] = { require("substitute").eol, "Substitute to End of Line" },
}, normal_mode)
wk.register({
    ["s"] = { require("substitute").operator, "Substitute Operator" },
}, visual_mode)

wk.register({
    ["<leader>C"] = { name = "+ChatGPT" },
    ["<leader>Ca"] = { "<cmd>ChatGPTActAs<cr>", "Act as ..." },
    ["<leader>Cc"] = { "<cmd>ChatGPT<cr>", "ChatGPT" },
    ["<leader>Ce"] = { "<cmd>ChatGPTEditWithInstructions<cr>", "Edit with Instructions" },
}, normal_mode)
wk.register({
    ["<leader>C"] = { name = "+ChatGPT" },
    ["<leader>Ce"] = { require("chatgpt").edit_with_instructions, "Edit with Instructions" },
}, visual_mode)

wk.register({
    ["<leader>_"] = { require("osc52").copy_operator, "Copy (osc52)" },
}, normal_mode_with_expr)
wk.register({
    ["<leader>_"] = { "<cmd>lua require('osc52').copy_visual()<cr>", "Copy (osc52)" },
}, visual_mode)

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Global Mappings: only normal mode

wk.register({
    ["<leader>y"] = { "<cmd>lua require('telescope').extensions.neoclip.default()<cr>", "Yank History (neoclip)" },

    ["<C-p>"] = { "<cmd>Telescope lsp_definitions<cr>", "Goto Definition" },
    ["K"] = { vim.lsp.buf.hover, "Hover" },
    ["gd"] = { "<cmd>Telescope lsp_definitions<cr>", "Goto Definition" },
    ["gi"] = { "<cmd>Telescope lsp_implementations<cr>", "Goto Implementation" },
    ["gt"] = { "<cmd>Telescope lsp_type_definitions<cr>", "Goto Type Definition" },
    ["gr"] = { "<cmd>Telescope lsp_references<cr>", "Goto References" },

    ["<leader>["] = { "<cmd>BufferLineCyclePrev<cr>", "Previous Buffer" },
    ["<leader>]"] = { "<cmd>BufferLineCycleNext<cr>", "Next Buffer" },
    ["<leader><tab>"] = { "<cmd>b#<cr>", "Switch between buffers" },
    ["<leader>q"] = { "<cmd>qa!<cr>", "Force Quit All Buffers" },
    ["<leader>w"] = { "<cmd>BufferKill<cr>", "Close Current Buffer" },
    ["<leader>Z"] = { "<cmd>ZenMode<cr>", "Zen Mode" },

    ["<leader>a"] = { name = "+AsyncRun & AsyncTasks" },
    ["<leader>aa"] = { "<cmd>lua require('telescope').extensions.asynctasks.all()<cr>", "List All AsyncTasks" },

    ["<leader>bb"] = { "<cmd>Telescope buffers previewer=false<cr>", "Find" },

    ["<leader>E"] = { "<cmd>SymbolsOutline<cr>", "Symbols Explorer" },

    ["<leader>f"] = { name = "+File" },
    ["<leader>ff"] = { "<cmd>Telescope find_files previewer=false<cr>", "Find File" },
    ["<leader>fw"] = { "<cmd>Telescope grep_string<cr>", "File Grep Current Word" },
    ["<leader>fg"] = { "<cmd>Telescope live_grep<cr>", "File Live Grep" },
    ["<leader>fr"] = { "<cmd>Telescope oldfiles previewer=true<cr>", "Open Recent File" },
    ["<leader>fn"] = { "<cmd>enew<cr>", "New File" },
    ["<leader>ft"] = { "<cmd>Filetypes<cr>", "Set File Type" },

    ["<leader>d"] = { name = "+Dap" },
    -- mostly follow gdb/ldb mappings
    ["<leader>db"] = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "b(reakpoint)" },
    ["<leader>dc"] = { "<cmd>lua require'dap'.continue()<cr>", "c(ontinue)" },
    ["<leader>dr"] = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "run to cursor" },
    ["<leader>ds"] = { "<cmd>lua require'dap'.step_into()<cr>", "s(tep) [step into]" },
    ["<leader>dn"] = { "<cmd>lua require'dap'.step_over()<cr>", "n(ext) [step over]" },
    ["<leader>do"] = { "<cmd>lua require'dap'.step_out()<cr>", "finish [step out]" },
    -- DapUI
    ["<leader>dd"] = {
        function()
            require("dap").disconnect()
            require("dapui").toggle({ reset = true })
        end,
        "Disconnect",
    },
    ["<leader>du"] = { "<cmd>lua require'dapui'.toggle({reset = true})<cr>", "Toggle Dap UI" },
    -- Dap + Telescope
    ["<leader>dl"] = {
        function()
            require("telescope").extensions.dap.list_breakpoints({})
        end,
        "Dap list breakpoints",
    },
    ["<leader>dv"] = {
        function()
            require("telescope").extensions.dap.variables({})
        end,
        "Dap variables",
    },
    ["<leader>df"] = {
        function()
            require("telescope").extensions.dap.frames({})
        end,
        "Dap frames",
    },
    ["<leader>D"] = {
        function()
            require("telescope").extensions.dap.commands({})
        end,
        "Dap commands",
    },

    ["<leader>gf"] = {
        function()
            require("lvim.core.telescope.custom-finders").find_project_files({ previewer = false })
        end,
        "Find Git File",
    },
    ["<leader>gd"] = { "<cmd>DiffviewFileHistory<cr>", "Git diff" },
    ["<leader>gD"] = { "<cmd>DiffviewFileHistory %<cr>", "Git diff (for current file)" },
    ["<leader>gt"] = { "<cmd>DiffviewToggleFiles<cr>", "Toggle DiffviewFileHistoryPanel" },
    ["<leader>gL"] = { "<cmd>Git blame<cr>", "Git blame (for all lines)" },

    ["<leader>ld"] = { "<cmd>TroubleToggle document_diagnostics<cr>", "Buffer Diagnostics" },
    ["<leader>lt"] = { "<cmd>ToggleDiag<cr>", "Toggle Diagnostics" },
    ["<leader>lD"] = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace Diagnostics" },

    ["<leader>o"] = { name = "+Open file with" },
    ["<leader>oc"] = { "<cmd>call ExecuteBufferSilentlyWith('code')<cr>", "Open with VsCode" },
    ["<leader>ow"] = { "<cmd>call ExecuteBufferSilentlyWith('explorer.exe')<cr>", "Open with Windows Explorer" },

    ["<leader>p"] = { name = "+Project" },
    ["<leader>pp"] = { "<cmd>Telescope projects<cr>", "Recent Projects" },
    ["<leader>pf"] = {
        function()
            require("telescope.builtin").find_files()
        end,
        "Find Project File",
    },
    ["<leader>pw"] = {
        function()
            require("telescope.builtin").grep_string()
        end,
        "Project Grep Current Word",
    },
    ["<leader>pg"] = {
        function()
            require("telescope.builtin").live_grep()
        end,
        "Project Live Grep",
    },

    ["<leader>s"] = { name = "+Search & Substitute" },
    ["<leader>sw"] = { name = "Substitute word (from current selection)" },
    ["<leader>sa"] = { name = "Substitute word (from first line)" },
    ["<leader>ss"] = { "<cmd>lua require('spectre').open()<cr>", "Substitute with Spectre" },

    ["<leader>z"] = { name = "Telekasten" },
    ["<leader>zz"] = { "<cmd>Telekasten panel<cr>", "Panel" },
    ["<leader>zf"] = { "<cmd>Telekasten find_notes<cr>", "Find notes" },
    ["<leader>zs"] = { "<cmd>Telekasten search_notes<cr>", "Search notes" },
    ["<leader>zt"] = { "<cmd>Telekasten goto_today<cr>", "Goto today" },
    ["<leader>zl"] = { "<cmd>Telekasten follow_link<cr>", "Follow link" },
    ["<leader>zn"] = { "<cmd>Telekasten new_note<cr>", "New note" },
    ["<leader>zc"] = { "<cmd>Telekasten show_calendar<cr>", "Show calendar" },
    ["<leader>zb"] = { "<cmd>Telekasten show_backlinks<cr>", "Show backlinks" },
    ["<leader>zi"] = { "<cmd>Telekasten insert_img_link<cr>", "Insert img link" },
}, normal_mode)

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Conditional Mappings: FileType

vim.cmd("autocmd FileType * lua set_key_bindings()")
function set_key_bindings()
    local ftype = vim.api.nvim_buf_get_option(0, "filetype")
    local fname = vim.fn.expand("%:t")

    -- markdown
    if ftype == "markdown" then
        wk.register({
            ["<CR>"] = { "<cmd>MkdnEnter<cr>", "Follow or Insert Link / Header Collapse" },
            ["<BS>"] = { "<cmd>MkdnGoBack<cr>", "Go Back" },
            ["<S-Tab>"] = { "<cmd>MkdnPrevLink<cr>", "Previous Link" },
            ["<Tab>"] = { "<cmd>MkdnNextLink<cr>", "Next Link" },
            ["[["] = { "<cmd>MkdnPrevHeading<cr>", "Previous Heading" },
            ["]]"] = { "<cmd>MkdnNextHeading<cr>", "Next Heading" },
            ["o"] = { "<cmd>MkdnNewListItemBelowInsert<cr>", "Insert Below (list-supported)" },
            ["O"] = { "<cmd>MkdnNewListItemAboveInsert<cr>", "Insert Above (list-supported)" },
            ["H"] = { "<cmd>MkdnTablePrevCell<cr>", "Table - Previous Cell" },
            ["L"] = { "<cmd>MkdnTableNextCell<cr>", "Table - Next Cell" },
            ["<leader>m"] = { name = "+Markdown" },
            ["<leader>mc"] = { "<cmd>FeMaco<cr>", "Edit Code Snippet" },
            ["<leader>mp"] = { "<cmd>MarkdownPreviewToggle<cr>", "Toggle Preview" },
            ["<leader>mx"] = { "<cmd>MkdnToggleToDo<cr>", "Toggle Todo" },
            ["<leader>ml"] = { "<cmd>MkdnCreateLink<cr>", "Insert Link" },
            ["<leader>mL"] = { "<cmd>MkdnCreateLinkFromClipboard<cr>", "Insert Link from Clipboard" },
            ["<leader>mt"] = { name = "+Table" },
            ["<leader>mtt"] = { "<cmd>MkdnTable 3 2<cr>", "Insert Table" },
            ["<leader>mtR"] = { "<cmd>MkdnTableNewRowAbove<cr>", "Insert Row Above" },
            ["<leader>mtr"] = { "<cmd>MkdnTableNewRowBelow<cr>", "Insert Row Below" },
            ["<leader>mtC"] = { "<cmd>MkdnTableNewColBefore<cr>", "Insert Col Left" },
            ["<leader>mtc"] = { "<cmd>MkdnTableNewColAfter<cr>", "Insert Col Right" },
            ["<leader>mr"] = { "<cmd>MkdnMoveSource<cr>", "Rename Source in Link" },
        }, normal_mode)
        wk.register({
            ["<CR>"] = { "<cmd>MkdnEnter<cr>", "Follow or Insert Link / Header Collapse" },
        }, visual_mode)
    end

    -- program: c / cpp / python / sh / zsh
    -- ac: AsyncRun Code
    if ftype == "c" then
        wk.register({
            ["<leader>ac"] = { "<cmd>call ExecuteBufferWith('rc --clean_output')<cr>", "Run (buffer)" },
        }, normal_mode)
    elseif ftype == "cpp" then
        wk.register({
            ["<leader>ac"] = { "<cmd>call ExecuteBufferWith('rcxx --clean_output')<cr>", "Run (buffer)" },
        }, normal_mode)
    elseif ftype == "java" then
        wk.register({
            ["<leader>ac"] = { "<cmd>call ExecuteBufferWith('java')<cr>", "Run (buffer)" },
        }, normal_mode)
    elseif ftype == "python" then
        wk.register({
            ["<leader>ac"] = { "<cmd>call ExecuteBufferWith('python')<cr>", "Run (buffer)" },
        }, normal_mode)
    elseif ftype == "sh" or ftype == "bash" then
        wk.register({
            ["<leader>ac"] = { "<cmd>call ExecuteBufferWith('bash')<cr>", "Run (buffer)" },
        }, normal_mode)
    elseif ftype == "zsh" then
        wk.register({
            ["<leader>ac"] = { "<cmd>call ExecuteBufferWith('zsh')<cr>", "Run (buffer)" },
        }, normal_mode)
    end

    -- project: cmake / cargo
    if ftype == "c" or ftype == "cpp" or fname == "CMakeLists.txt" then
        wk.register({
            ["<leader>ab"] = { "<cmd>call ExecuteInRootWith('cmakebuild -t all')<cr>", "Project Build [CMake]" },
            ["<leader>ar"] = { "<cmd>call ExecuteInRootWith('cmakebuild -t run')<cr>", "Project Run [CMake]" },
        }, normal_mode)
    elseif ftype == "rust" or fname == "Cargo.toml" then
        wk.register({
            ["<leader>ab"] = { "<cmd>call ExecuteInRootWith('cargo build')<cr>", "Project Build [Cargo]" },
            ["<leader>ar"] = { "<cmd>call ExecuteInRootWith('cargo run')<cr>", "Project Run [Cargo]" },
        }, normal_mode)
    end

    -- for telekasten calendar; do not use default 'BufferKill' would open next buffer
    if ftype == "calendar" then
        wk.register({
            ["<leader>w"] = { "<cmd>q<cr>", "Close Current Buffer" },
        }, normal_mode)
    end
end
