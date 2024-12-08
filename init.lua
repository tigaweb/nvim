-- lazy.nvim boot strapw
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- local plugins
local plugins = {
    { import = "plugins" },
}

-- local opts
local opts = {
    root = vim.fn.stdpath("data") .. "/lazy",
    lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",
    concurrency = 10,
    checker = { enabled = true },
    log = { level = "info" },
}

-- leader key
vim.g.mapleader = " "

-- 挿入モードで "jk" を押すとノーマルモードに戻る
vim.keymap.set("i", "jk", "<ESC>", { noremap = true, silent = true })
-- Viewモードでのクリップボード操作
vim.keymap.set("v", "<leader>y", '"+y', { noremap = true, silent = true, desc = "Copy to clipboard" }) -- 選択範囲をコピー
vim.keymap.set("v", "<leader>d", '"+d', { noremap = true, silent = true, desc = "Cut to clipboard" })  -- 選択範囲を切り取り
vim.keymap.set("v", "<leader>p", '"+p', { noremap = true, silent = true, desc = "Paste from clipboard" }) -- クリップボードの内容を貼り付け

-- ファイル切り替え
vim.keymap.set("n", "<C-h>", "<cmd>bprev<CR>")
vim.keymap.set("n", "<C-l>", "<cmd>bnext<CR>")

-- lazy setup
require("lazy").setup(plugins, opts)

-- require core/ and user/
require("core.options")
require("core.autocmds")
require("core.keymaps")
require("user.ui")
