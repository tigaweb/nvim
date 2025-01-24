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
    "eslint_d",
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
                elseif lsp_server == "dockerls" then
                    -- Dockerfile 用 LSP 設定
                    lsp_config.dockerls.setup({
                        root_dir = function(fname)
                            return lsp_config.util.find_git_ancestor(fname) or vim.fn.getcwd()
                        end,
                        on_attach = function(client, bufnr)
                            -- フォーマット機能を有効化
                            client.server_capabilities.documentFormattingProvider = true

                            -- キーマップを設定
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
                    -- TypeScript/JavaScript 用 LSP 設定
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
                                    enable = true, -- フォーマットを有効化
                                },
                                schemaStore = {
                                    enable = true,
                                    url = "https://www.schemastore.org/api/json/catalog.json",
                                },
                                validate = true, -- 構文検証を有効化
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
                    -- 他のサーバーにはデフォルト設定を適用
                    lsp_config[lsp_server].setup({
                        root_dir = function(fname)
                            return lsp_config.util.find_git_ancestor(fname) or vim.fn.getcwd()
                        end,
                    })
                end
            end

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
                            "<leader><space>",
                            ":!buf format -w %<CR>",
                            { noremap = true, silent = true }
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
            -- ソースのリスト
            local sources = {
                -- React 用 Prettier
                null_ls.builtins.formatting.prettier.with({
                    filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
                }),
                -- Dockerfile フォーマッタ (dockfmt)
                dockfmt,
                -- Dockerfile 用 Hadolint
                null_ls.builtins.diagnostics.hadolint,
                -- React 用 ESLint
                null_ls.builtins.diagnostics.eslint_d,
                -- null_ls.builtins.diagnostics.eslint_d.with({
                --     command = "eslint_d",
                --     filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
                --     condition = function(utils)
                --         -- 設定ファイルが存在する場合のみ有効化
                --         return utils.root_has_file({
                --             ".eslintrc",
                --             ".eslintrc.json",
                --             ".eslintrc.js",
                --             ".eslintignore",
                --         })
                --     end,
                -- }),
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
