return {
    -- colorscheme（Warp最適化）
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 21000,
        config = function()
          require("catppuccin").setup({
            transparent_background = false, -- Warpでは透明背景を無効化
            term_colors = true,
            compile_path = vim.fn.stdpath("cache") .. "/catppuccin", -- コンパイルキャッシュ
          })
          vim.cmd.colorscheme("catppuccin")
        end,
    },

    {
        "folke/tokyonight.nvim",
        enabled = false, -- catppuccinを優先して無効化（起動時間短縮）
        lazy = true,
        priority = 1000,
        styles = {
            sidebars = "transparent",
            floats = "transparent",
        },
    },

    -- file browser
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        opts = {},
        event = "VeryLazy",
    },

    -- tabline
    {
        "kdheepak/tabline.nvim",
        opts = {},
        event = "BufWinEnter",
    },

    -- indent
    {
        "echasnovski/mini.indentscope",
        opts = {
            symbol = "▏",
        },
        event = "BufRead",
    },

    -- nvim-treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufRead", "BufNewFile", "InsertEnter" },
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                ensure_installed = {
                    "awk",
                    "bash",
                    "comment",
                    "c",
                    "css",
                    "csv",
                    "diff",
                    "gpg",
                    "html",
                    "htmldjango",
                    "javascript",
                    "json",
                    "lua",
                    "markdown",
                    "python",
                    "rust",
                    "sql",
                    "ssh_config",
                    "tmux",
                    "toml",
                    "vim",
                    "xml",
                    "yaml",
                    "regex",
                    "vimdoc",
                },
                sync_install = false,
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },

    -- noice（Warp最適化）
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        opts = {
            cmdline = {
                enabled = true,
                view = "cmdline", -- Warpでは標準のcmdlineビューを使用
            },
            messages = {
                enabled = true,
                view = "mini", -- メッセージビューを軽量化
            },
            routes = {
                {
                    filter = { event = "msg_show", find = "E486: Pattern not found: .*" },
                    opts = { skip = true },
                },
                {
                    filter = { event = "msg_show", find = "search hit BOTTOM" },
                    opts = { skip = true },
                },
                {
                    filter = { event = "msg_show", find = "search hit TOP" },
                    opts = { skip = true },
                },
            },
            lsp = {
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
                },
                progress = {
                    enabled = false, -- LSP進捗表示を無効化（パフォーマンス向上）
                },
            },
        },
    },

    -- git
    {
        "lewis6991/gitsigns.nvim",
        config = true,
        event = { "BufReadPre", "BufNewFile" },
    },
    -- autopairs
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({
                check_ts = true, -- Treesitter を使った文脈認識を有効化
            })
        end,
        event = "InsertEnter", -- 挿入モードに入ったときに読み込む
    },
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
        event = "BufReadPre",
    },

    -- which-key
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
            preset = "modern",
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },
}
