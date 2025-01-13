local lsp_servers = {
    "pyright",
    "ruff",
    "bashls",
    "lua_ls",
    "yamlls",
    "jsonls",
    "taplo",
    "rust_analyzer",
    "ts_ls",
    "html",
    "cssls",
    -- "gopls@v0.16.0",
    "gopls",
    "intelephense",
    -- "buf_ls", -- Mason 管理から除外（手動設定を使用）
}

local formatters = {
    "djlint",
    "stylua",
    "shfmt",
    "prettier",
}
local diagnostics = {
    "yamllint",
    "selene",
}

return {
    -- lsp icons like vscode
    {
        "onsails/lspkind.nvim",
        -- nvim-cmp.lua
        event = "InsertEnter",
    },

    -- mason / mason-lspconfig / lspconfig
    {
        "williamboman/mason.nvim",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "neovim/nvim-lspconfig",
            "jay-babu/mason-null-ls.nvim",
            -- "jose-elias-alvarez/null-ls.nvim",
            "nvimtools/none-ls.nvim",
        },
        config = function()
            require("mason").setup({
                PATH = "prepend", -- PATH に手動インストール済みのバイナリを優先させる
            })
            require("mason-lspconfig").setup({
                -- lsp_servers table Install
                ensure_installed = lsp_servers,
                automatic_installation = false,
            })

            local lsp_config = require("lspconfig")
            -- lsp_servers table setup
            for _, lsp_server in ipairs(lsp_servers) do
                if lsp_server == "gopls" then
                    -- gopls に特別な設定を適用
                    lsp_config.gopls.setup({
                        cmd = { vim.fn.expand("$HOME/go/bin/gopls") },
                        root_dir = function(fname)
                            return lsp_config.util.find_git_ancestor(fname) or vim.fn.getcwd()
                        end,
                        settings = {
                            gopls = {
                                analyses = {
                                    unusedparams = true,
                                },
                                staticcheck = true,
                            },
                        },
                    })
                else
                    -- 他のサーバーにはデフォルト設定を適用
                    lsp_config[lsp_server].setup({
                        root_dir = function(fname)
                            return lsp_config.util.find_git_ancestor(fname) or vim.fn.getcwd()
                        end,
                    })
                end
            end

            -- bufls カスタム設定を定義
            -- if not lsp_config.buf_ls then
            --     lsp_config.buf_ls = {
            --         default_config = {
            --             cmd = { "buf", "ls" }, -- buf CLI のコマンド
            --             filetypes = { "proto" }, -- .proto ファイルを対象
            --             root_dir = function(fname)
            --                 return lsp_config.util.find_git_ancestor(fname) or vim.fn.getcwd()
            --             end,
            --             single_file_support = true,
            --         },
            --     }
            -- end

            -- bufls を手動で設定
            if lsp_config.buf_ls then
                print("Configuring bufls...")
                lsp_config.buf_ls.setup({
                    -- cmd = { "buf", "lsp" },
                    cmd = { "buf", "beta", "lsp" },
                    filetypes = { "proto" }, -- 確認
                    root_dir = function(fname)
                        return lsp_config.util.root_pattern("buf.yaml")(fname)
                            or lsp_config.util.find_git_ancestor(fname)
                            or vim.fn.getcwd()
                    end,
                    single_file_support = true,
                    on_attach = function(client, bufnr)
                        -- フォーマット機能を有効化
                        client.server_capabilities.documentFormattingProvider = true
                        client.server_capabilities.documentRangeFormattingProvider = true

                        -- キーマップを設定（任意）
                        local opts = { noremap = true, silent = true }
                        vim.api.nvim_buf_set_keymap(
                            bufnr,
                            "n",
                            "<leader>f",
                            "<cmd>lua vim.lsp.buf.format({ async = true })<CR>",
                            opts
                        )
                    end,
                })
            else
                print("Error: bufls is not defined")
            end
        end,
        cmd = "Mason",
    },

    -- mason-null-ls
    {
        "jay-babu/mason-null-ls.nvim",
        -- event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            -- "jose-elias-alvarez/null-ls.nvim",
            "nvimtools/none-ls.nvim",
        },
        config = function()
            require("mason-null-ls").setup({
                automatic_setup = true,
                -- formatters table and diagnostics table Install
                ensure_installed = vim.tbl_flatten({ formatters, diagnostics }),
                handlers = {},
            })
        end,
        cmd = "Mason",
    },

    -- none-ls
    {
        -- "jose-elias-alvarez/null-ls.nvim",
        "nvimtools/none-ls.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function()
            local null_ls = require("null-ls")

            -- formatters table
            local formatting_sources = {}
            for _, tool in ipairs(formatters) do
                table.insert(formatting_sources, null_ls.builtins.formatting[tool])
            end

            -- diagnostics table
            local diagnostics_sources = {}
            for _, tool in ipairs(diagnostics) do
                table.insert(diagnostics_sources, null_ls.builtins.diagnostics[tool])
            end

            -- none-ls setup
            null_ls.setup({
                diagnostics_format = "[#{m}] #{s} (#{c})",
                sources = vim.tbl_flatten({ formatting_sources, diagnostics_sources }),
            })
        end,
        event = { "BufReadPre", "BufNewFile" },
    },

    -- lspsaga
    {
        "nvimdev/lspsaga.nvim",
        config = function()
            require("lspsaga").setup({
                symbol_in_winbar = {
                    separator = "  ",
                },
            })
        end,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        event = { "BufRead", "BufNewFile" },
    },

    -- mason-nvim-dap
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
        },
        opts = {
            ensure_installed = {
                "python",
            },
            handlers = {},
        },
    },
}
