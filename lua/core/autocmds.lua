-- ファイル保存時に自動フォーマット
vim.cmd([[autocmd BufWritePre * lua vim.lsp.buf.format()]])
