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
    "dockerls",
    "marksman", -- Markdown LSP
}

local formatters = {
    "djlint",
    "stylua",
    "shfmt",
}
local diagnostics = {
    "yamllint",
    "selene",
    "hadolint",
}

local on_attach = function(client, bufnr)
    -- キーマップを設定して `hover` 機能を有効化
    local opts = { noremap = true, silent = true }
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "K", -- デフォルトで `K` にマッピング
        "<cmd>lua vim.lsp.buf.hover()<CR>",
        opts
    )
end

return {
    -- lsp icons like vscode
    {
        "onsails/lspkind.nvim",
        -- nvim-cmp.lua
        event = "InsertEnter",
    },

    -- mason / lspconfig (simplified setup)
    {
        "williamboman/mason.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "nvimtools/none-ls.nvim",
        },
        config = function()
            -- Mason setup with minimal configuration
            local mason_status_ok, mason = pcall(require, "mason")
            if not mason_status_ok then
                vim.notify("Mason not found!", vim.log.levels.ERROR)
                return
            end
            
            mason.setup({
                PATH = "prepend",
                log_level = vim.log.levels.WARN, -- Reduce log noise
            })

            local lsp_config_status_ok, lsp_config = pcall(require, "lspconfig")
            if not lsp_config_status_ok then
                vim.notify("Lspconfig not found!", vim.log.levels.ERROR)
                return
            end

            -- Manual LSP server setup without mason-lspconfig
            for _, lsp_server in ipairs(lsp_servers) do
                local setup_ok, _ = pcall(function()
                    if lsp_server == "gopls" then
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
                    elseif lsp_server == "dockerls" then
                        lsp_config.dockerls.setup({
                            root_dir = function(fname)
                                return lsp_config.util.find_git_ancestor(fname) or vim.fn.getcwd()
                            end,
                            on_attach = function(client, bufnr)
                                client.server_capabilities.documentFormattingProvider = true
                                local opts = { noremap = true, silent = true }
                                vim.api.nvim_buf_set_keymap(
                                    bufnr,
                                    "n",
                                    "<leader><space>",
                                    "<cmd>lua vim.lsp.buf.format({ async = true })<CR>",
                                    opts
                                )
                            end,
                        })
                    elseif lsp_server == "ts_ls" then
                        lsp_config.ts_ls.setup({
                            root_dir = function(fname)
                                return lsp_config.util.find_git_ancestor(fname) or vim.fn.getcwd()
                            end,
                            settings = {
                                javascript = {
                                    format = {
                                        semicolons = "insert",
                                    },
                                },
                                typescript = {
                                    format = {
                                        semicolons = "insert",
                                    },
                                },
                            },
                        })
                    elseif lsp_server == "yamlls" then
                        lsp_config.yamlls.setup({
                            settings = {
                                yaml = {
                                    format = {
                                        enable = true,
                                    },
                                    schemaStore = {
                                        enable = true,
                                        url = "https://www.schemastore.org/api/json/catalog.json",
                                    },
                                    validate = true,
                                },
                            },
                        })
                    elseif lsp_server == "pyright" then
                        lsp_config.pyright.setup({
                            on_attach = on_attach,
                            root_dir = function(fname)
                                return lsp_config.util.find_git_ancestor(fname) or vim.fn.getcwd()
                            end,
                        })
                    else
                        -- Default setup for other servers
                        lsp_config[lsp_server].setup({
                            root_dir = function(fname)
                                return lsp_config.util.find_git_ancestor(fname) or vim.fn.getcwd()
                            end,
                        })
                    end
                end)
                if not setup_ok then
                    vim.notify("Failed to setup LSP server: " .. lsp_server, vim.log.levels.WARN)
                end
            end

            -- Manual setup for bufls
            if lsp_config.buf_ls then
                local buf_status_ok, _ = pcall(function()
                    lsp_config.buf_ls.setup({
                        cmd = { "buf", "beta", "lsp" },
                        filetypes = { "proto" },
                        root_dir = function(fname)
                            return lsp_config.util.root_pattern("buf.yaml")(fname)
                                or lsp_config.util.find_git_ancestor(fname)
                                or vim.fn.getcwd()
                        end,
                        single_file_support = true,
                        on_attach = function(client, bufnr)
                            client.server_capabilities.documentFormattingProvider = true
                            client.server_capabilities.documentRangeFormattingProvider = true
                            local opts = { noremap = true, silent = true }
                            vim.api.nvim_buf_set_keymap(
                                bufnr,
                                "n",
                                "<leader><space>",
                                ":!buf format -w %<CR>",
                                opts
                            )
                        end,
                    })
                end)
                if not buf_status_ok then
                    vim.notify("Failed to setup bufls", vim.log.levels.WARN)
                end
            end
        end,
        cmd = "Mason",
    },


    -- none-ls
    {
        "nvimtools/none-ls.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function()
            local null_ls = require("null-ls")

            -- カスタムフォーマッタの定義
            local dockfmt = {
                name = "dockfmt",
                method = null_ls.methods.FORMATTING,
                filetypes = { "dockerfile" },
                generator = null_ls.generator({
                    command = "dockfmt", -- dockfmt コマンドを指定
                    args = { "fmt", "$FILENAME" }, -- ファイルパスを渡す
                    -- to_stdin = false, -- 標準入力を使用しない
                    -- format = "raw", -- フォーマット結果をそのまま出力
                    on_output = function(params, done)
                        -- 結果をパースして返却
                        if params.err then
                            vim.notify("Dockfmt error: " .. params.err, vim.log.levels.ERROR)
                            done() -- エラーの場合は終了
                            return
                        end

                        done({
                            {
                                text = params.output, -- フォーマット結果をテキストとして返却
                                range = nil, -- 全体を置き換える
                            },
                        })
                    end,
                }),
            }
            -- ソースのリスト（安定版）
            local sources = {
                -- Dockerfile フォーマッタ (dockfmt)
                dockfmt,
                -- Dockerfile 用 Hadolint
                null_ls.builtins.diagnostics.hadolint,
            }

            -- none-ls のセットアップ
            null_ls.setup({
                sources = sources,
                diagnostics_format = "[#{m}] #{s} (#{c})",
                debug = true, -- デバッグを有効化
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
