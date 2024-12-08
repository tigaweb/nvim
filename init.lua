-- lazy.nvim boot strap
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
vim.keymap.set("n", "<leader>e", function()
  -- Neo-tree バッファの番号を取得
  local neo_tree_bufnr = vim.fn.bufnr("neo-tree://")
  
  -- Neo-tree が開かれているウィンドウを取得
  local neo_tree_open = false
  for _, win in ipairs(vim.fn.win_findbuf(neo_tree_bufnr)) do
    if vim.api.nvim_win_is_valid(win) then
      neo_tree_open = true
      break
    end
  end

  -- 開いている場合はフォーカスを移動し、閉じている場合はトグルで開く
  if neo_tree_open then
    vim.cmd("Neotree focus")
  else
    vim.cmd("Neotree toggle")
  end
end, { noremap = true, silent = true })

-- 挿入モードで "jk" を押すとノーマルモードに戻る
vim.keymap.set("i", "jk", "<ESC>", { noremap = true, silent = true })

-- lazy setup
require("lazy").setup(plugins, opts)

-- require core/ and user/
require("core.options")
require("core.autocmds")
require("core.keymaps")
require("user.ui")
