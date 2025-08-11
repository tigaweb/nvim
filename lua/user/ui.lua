-- colorscheme (Warp optimized)
-- Use catppuccin as the primary theme since tokyonight is disabled
local status_ok, _ = pcall(vim.cmd, 'colorscheme catppuccin')
if not status_ok then
  vim.notify('colorscheme catppuccin not found!', vim.log.levels.ERROR)
  -- Fallback to default colorscheme
  vim.cmd.colorscheme "default"
end
