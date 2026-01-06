# dotfiles

個人用の dotfiles リポジトリです。

## Configurations

| Tool | Description |
|------|-------------|
| direnv | 環境変数の自動設定 |
| git | Git の設定とエイリアス |
| got | Go バージョンマネージャ |
| ideavim | IntelliJ IDEA の Vim プラグイン設定 |
| lf | ターミナルファイルマネージャ |
| nvim | Neovim の設定 |
| starship | シェルプロンプト |
| tmux | ターミナルマルチプレクサ |
| zsh | Zsh の設定 |

## Installation

### 1. Node.js のインストール

#### Debian/Ubuntu

```bash
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install nodejs -y
```

#### macOS

```bash
brew install node
```

### 2. Clone & Setup

```bash
mkdir -p $HOME/work/src/github.com/longkey1
git clone git@github.com:longkey1/dotfiles.git $HOME/work/src/github.com/longkey1/dotfiles
cd $HOME/work/src/github.com/longkey1/dotfiles

# Setup secrets
cp .scripts/secrets.env.dist .scripts/secrets.env
vim .scripts/secrets.env

# Build and install
make build
make install
```

## Optional

必要に応じてインストールしてください。

```bash
# Debian/Ubuntu
sudo apt install vim tmux -y

# macOS
brew install vim tmux
```

## Make Commands

| Command | Description |
|---------|-------------|
| `make init` | 初期化（bin, eget, gojq, bitwarden） |
| `make build` | 全ファイルをビルド |
| `make build target=<name>` | 指定ターゲットのみビルド |
| `make install` | シンボリックリンクを作成 |
| `make uninstall` | シンボリックリンクを削除 |
| `make update` | ビルドファイルを更新 |
| `make clean` | ビルドファイルを削除 |
