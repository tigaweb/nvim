-- Warp Terminal specific optimizations
-- This file contains settings specifically optimized for Warp terminal

local M = {}

function M.setup()
  -- Warp terminal detection
  if vim.env.TERM_PROGRAM == "WarpTerminal" then
    -- Warp-specific optimizations
    vim.opt.ttimeoutlen = 10    -- キーエスケープシーケンスのタイムアウトを短縮
    vim.opt.ttyfast = true      -- 高速ターミナル接続を想定
    
    -- Mouse support optimization for Warp
    vim.opt.mouse = "a"         -- すべてのモードでマウス有効
    vim.opt.mousefocus = true   -- マウスでフォーカス移動
    
    -- Scroll optimization
    vim.opt.scroll = 1          -- スクロール行数を1に設定
    vim.opt.scrolljump = 1      -- ジャンプスクロール行数
    
    -- Terminal cursor optimization
    vim.opt.guicursor = table.concat({
      "n-v-c-sm:block-Cursor/lCursor-blinkwait300-blinkon200-blinkoff150",
      "i-ci-ve:ver25-Cursor/lCursor-blinkwait300-blinkon200-blinkoff150", 
      "r-cr-o:hor20-Cursor/lCursor-blinkwait300-blinkon200-blinkoff150"
    }, ",")
    
    -- Disable problematic features in Warp
    vim.g.loaded_matchparen = 1 -- 括弧マッチングプラグインを無効化（パフォーマンス向上）
    
    -- Optimize redraw behavior
    -- Noice.nvim の描画と競合するため lazyredraw は無効化
    vim.opt.lazyredraw = false
    vim.opt.regexpengine = 1    -- 古い正規表現エンジンを使用（安定性向上）
    
    -- Better display refresh
    vim.cmd([[
      autocmd FocusGained * checktime
      autocmd CursorHold,CursorHoldI * checktime
    ]])
  end
  
  -- General terminal optimizations
  if vim.fn.has("termguicolors") == 1 then
    vim.opt.termguicolors = true
  end
  
  -- Reduce escape key delay
  vim.opt.ttimeoutlen = 5
  
  -- Better splitting behavior
  vim.opt.splitbelow = true
  vim.opt.splitright = true
  
  -- Improve performance for large files
  vim.cmd([[
    autocmd BufWinEnter * if line2byte(line("$") + 1) > 100000 | syntax clear | endif
  ]])
end

return M