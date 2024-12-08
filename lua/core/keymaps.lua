local vim = vim
local opts = { noremap = true, silent = true } -- local term_opts = { silent = true }
local keymap = vim.keymap.set
-- オプションテーブルにdescを追加するための簡略化関数
local function extend_opts(desc)
    return vim.tbl_extend("force", opts, { desc = desc })
end

-- Neotree
keymap("n", "<leader>nn", ":Neotree toggle<cr>", extend_opts("Neotree Toggle"))
