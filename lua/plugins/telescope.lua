return {
  'nvim-telescope/telescope.nvim', tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim' },
   pickers = {
    buffers = {
      mappings = {
        i = {
          ["<C-d>"] = "delete_buffer", -- Ctrl+d でバッファ削除
        },
        n = {
          ["d"] = "delete_buffer", -- d キーでバッファ削除
        },
      },
    },
  },
  config = function()
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
    vim.keymap.set("n", "<leader>fd", function()
      vim.ui.input({ prompt = "Enter directory: " }, function(input)
        if input then
          require('telescope.builtin').live_grep({ search_dirs = { input } })
        end
      end)
    end, { noremap = true, silent = true, desc = "Live Grep in user-specified directory" })
  end
}
