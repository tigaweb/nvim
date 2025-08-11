local M = {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        -- cmdline は別プラグイン定義で CmdlineEnter 時に読み込む
        "saadparwaiz1/cmp_luasnip",
        "L3MON4D3/LuaSnip",
        "onsails/lspkind.nvim", -- アイコン表示用の依存関係を追加
    },
    event = "InsertEnter", -- CmdlineEnterを削除して安定性向上
}

M.config = function()
    local cmp_status_ok, cmp = pcall(require, "cmp")
    if not cmp_status_ok then
        vim.notify("nvim-cmp not found!", vim.log.levels.ERROR)
        return
    end
    
    local lspkind_status_ok, lspkind = pcall(require, "lspkind")
    
    vim.opt.completeopt = { "menu", "menuone", "noselect" }

    local formatting_config = {}
    if lspkind_status_ok then
        formatting_config = {
            format = lspkind.cmp_format({
                mode = "symbol",
                maxwidth = 50,
                ellipsis_char = "...",
                before = function(entry, vim_item)
                    return vim_item
                end,
            }),
        }
    end

    cmp.setup({
        formatting = formatting_config,
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end,
        },
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "nvim_lua" },
            { name = "luasnip" }, -- For luasnip users.
            -- { name = "orgmode" },
        }, {
            { name = "buffer" },
            { name = "path" },
        }),
    })

    -- '/' 検索のコマンドライン補完だけを有効化（cmp-cmdline 不要）
    local aug = vim.api.nvim_create_augroup("CmpCmdlineSearchOnly", { clear = true })
    vim.api.nvim_create_autocmd("CmdlineEnter", {
        group = aug,
        pattern = "/",
        callback = function()
            local ok_cmp, cmp2 = pcall(require, "cmp")
            if not ok_cmp then return end
            pcall(function()
                cmp2.setup.cmdline("/", {
                    mapping = cmp2.mapping.preset.cmdline(),
                    sources = { { name = "buffer" } },
                })
            end)
        end,
    })
end

return M
