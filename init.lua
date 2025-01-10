vim.env.LANG = "ja_JP.UTF-8"

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

vim.keymap.set("i", "jk", "<ESC>", { noremap = true, silent = true })
vim.keymap.set("v", "<leader>y", '"+y', { noremap = true, silent = true, desc = "Copy to clipboard" })
vim.keymap.set("v", "<leader>d", '"+d', { noremap = true, silent = true, desc = "Cut to clipboard" })
vim.keymap.set("v", "<leader>p", '"+p', { noremap = true, silent = true, desc = "Paste from clipboard" })

vim.keymap.set("n", "<C-h>", "<cmd>bprev<CR>")
vim.keymap.set("n", "<C-l>", "<cmd>bnext<CR>")

vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", { noremap = true, silent = true, desc = "Close Tab" })

vim.keymap.set("n", "<leader>tn", ":tabnew<CR>", { noremap = true, silent = true, desc = "New Tab" })

vim.cmd([[
  command! BufOnly execute '%bdelete|edit#|bdelete#'
]])

vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { noremap = true, silent = true, desc = "Delete Current Buffer" })

vim.keymap.set("n", "<leader>bo", ":BufOnly<CR>", { noremap = true, silent = true, desc = "Delete Other Buffers" })

vim.cmd([[
  highlight NeoTreeFileNameOpened guifg=#ff0000 gui=bold
  highlight NeoTreeOtherBuffers guibg=#504945 gui=italic
  highlight NeoTreeCurrentFile guibg=#3c3836 gui=bold
]])
-- vim.api.nvim_set_hl(0, "NeoTreeFileNameOpened", { bg = nil }) -- デフォルトをリセット
vim.api.nvim_set_hl(0, "NeoTreeCurrentFile", { bg = "#3c3836", fg = "#ebdbb2", bold = true })
vim.api.nvim_set_hl(0, "NeoTreeOtherBuffers", { bg = "#504945", fg = "#a89984", italic = true })
-- lazy setup
require("lazy").setup(plugins, opts)

-- require core/ and user/
require("core.options")
require("core.autocmds")
require("core.keymaps")
require("user.ui")
