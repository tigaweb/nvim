# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Neovim Configuration Overview

This is a personal Neovim configuration using lazy.nvim as the plugin manager. The configuration is structured with Japanese comments and follows a modular approach.

## Development Setup

### Prerequisites
```bash
brew install neovim
brew install ripgrep
brew install lazygit
```

### Plugin Management
- Uses lazy.nvim as the plugin manager
- Plugins are auto-installed on first startup
- Lock file: `lazy-lock.json` tracks exact plugin versions
- Main plugin configuration: `lua/plugins/plugins_lazy.lua`

### Linting and Formatting
- Lua linting: Uses selene (configured in `selene.toml`)
- LSP setup includes formatters and diagnostics via none-ls/null-ls
- Run `:Lazy profile` to check plugin performance
- Run `:Lazy sync` to update plugins

## Architecture

### Configuration Structure
```
init.lua                    # Entry point, lazy.nvim bootstrap
lua/
├── core/                   # Core Neovim settings
│   ├── options.lua         # Vim options (encoding, display, etc.)
│   ├── keymaps.lua         # Key mappings and LSP keybinds
│   └── autocmds.lua        # Auto commands
├── plugins/                # Plugin configurations
│   ├── plugins_lazy.lua    # Main plugin definitions
│   ├── lsp_cfg.lua         # LSP server configurations
│   ├── neo-tree.lua        # File explorer config
│   ├── telescope.lua       # Fuzzy finder config
│   └── [other plugins]
└── user/
    └── ui.lua              # UI customizations
```

### Key Settings
- Leader key: `<Space>`
- Language: Japanese locale (ja_JP.UTF-8)
- Clipboard integration enabled
- Relative line numbers
- 4-space indentation
- Auto-save disabled by default

### LSP Configuration
- **Managed LSP servers**: pyright, ruff, bashls, lua_ls, yamlls, jsonls, taplo, rust_analyzer, ts_ls, html, cssls, gopls, intelephense, dockerls
- **Custom configurations**: 
  - gopls: Uses `$HOME/go/bin/gopls`
  - buf_ls: Manual setup for Protocol Buffers
  - dockerls: Docker file support
- **Formatters**: djlint, stylua, shfmt, prettier
- **Diagnostics**: yamllint, selene, eslint_d, hadolint

### Key Plugins
- **lazy.nvim**: Plugin manager
- **neo-tree**: File explorer (toggle: `<leader>nn`)
- **telescope**: Fuzzy finder (buffers: `<leader>bb`)
- **lspsaga**: Enhanced LSP UI
- **which-key**: Keybinding hints
- **treesitter**: Syntax highlighting
- **lualine**: Status line
- **gitsigns**: Git integration

## Common Commands

### Plugin Management
```vim
:Lazy sync          " Update all plugins
:Lazy profile       " Check plugin performance
:Mason              " Open LSP/formatter installer
```

### Key Mappings
- `<Space>`: Leader key
- `<leader>nn`: Toggle Neo-tree file explorer
- `<leader>bb`: List buffers with Telescope
- `<leader>w`: Save file  
- `<leader>q`: Quit
- `<C-h>/<C-l>`: Switch buffers
- `jk`: Exit insert mode
- `<leader>bd`: Delete current buffer
- `<leader>bo`: Delete all other buffers

### LSP Operations (when LSP is attached)
- `gd`: Go to definition
- `gr`: Show references
- `K`: Hover documentation
- `<leader>rn`: Rename symbol
- `<space>ca`: Code actions
- `<leader><space>`: Format buffer
- `[d]d`: Previous/next diagnostic

## Development Notes

- Configuration uses Japanese comments throughout
- Custom buffer management with BufOnly command
- Highlights for NeoTree current file and opened buffers
- Mason manages LSP servers, formatters, and diagnostics automatically
- Special handling for Go (gopls) and Protocol Buffers (buf_ls)
- None-ls provides additional formatting and diagnostic capabilities