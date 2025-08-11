# Neovim 設定（Warp 最適化）

このリポジトリは Neovim 用の個人設定です。React Native(TypeScript) と Python、Markdown 編集に最適化しています。

## 依存パッケージ

macOS(Homebrew) 例:

```bash
brew install neovim ripgrep fd glow
brew install node python
npm i -g @biomejs/biome
pip install ruff
```

任意: git 操作に lazygit を使う場合

```bash
brew install lazygit
```

## プラグインの主な構成
- UI: catppuccin, lualine, alpha-nvim(ダッシュボード)
- エディタ: telescope, neo-tree, toggleterm, which-key, treesitter
- LSP/補完: nvim-lspconfig, nvim-cmp, mason (最小限), ruff/pyright, tsserver など
- フォーマット: conform.nvim（Biome/ruff/他）
- Markdown: glow.nvim（ターミナル内プレビュー）

## よく使うショートカット
- 全般
  - <leader>ff: ファイル検索
  - <leader>fg: ライブgrep
  - <leader>tt: ターミナル切替(ToggleTerm)
  - <leader>e: Neo-tree トグル
  - <leader>? : which-key（現在バッファのキーマップ）
- Git
  - <leader>lg: lazygit (ToggleTerm)
- バッファ/タブ
  - <C-h>/<C-l>: 前/次バッファ
  - <leader>bd: 現在バッファ削除, <leader>bo: 他バッファ消去
  - <leader>tn: 新規タブ, <leader>tc: タブを閉じる

起動時のダッシュボードにも主要ショートカットのボタンが出ます。

## フォーマット設定（Conform + Biome/Ruff）
- JS/TS/React/JSON/CSS/Markdown: Biome
- Python: Ruff (ruff_format)
- Lua: stylua, Shell: shfmt, YAML: yamlfmt
- 保存時に自動整形が有効（一部のファイルタイプは除外）。

## LSP
- TypeScript/JavaScript: tsserver(ts_ls)
- Python: pyright + ruff-lsp
- Markdown: marksman
- YAML/JSON/Lua/Bash/Docker 等も最低限を有効化

## コマンド例
- Markdown プレビュー: :Glow
- Conform 情報: :ConformInfo

## トラブルシュート
- Noice 警告: lazyredraw は無効化済み
- 依存コマンドが無いとフォーマットが動作しません。例: `biome`/`ruff`/`stylua` など

