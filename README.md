# dotfiles

個人用の dotfiles リポジトリです。

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

### Optional

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
| `make install` | シンボリックリンクを作成 |
| `make uninstall` | シンボリックリンクを削除 |
| `make update` | ビルドファイルを更新 |
| `make clean` | ビルドファイルを削除 |

`build`, `install`, `uninstall`, `update`, `clean` は `target=<name>` を指定すると、そのターゲットのみ実行します。

```bash
make build target=zsh      # zsh のみビルド
make install target=nvim   # nvim のみインストール
make clean target=tmux     # tmux のみクリーン
```

## Targets

| Target | Link |
|--------|------|
| argc | [sigoden/argc](https://github.com/sigoden/argc) |
| bat | [sharkdp/bat](https://github.com/sharkdp/bat) |
| bin | - |
| bitwarden | [bitwarden/clients](https://github.com/bitwarden/clients) |
| checkexec | [kurtbuilds/checkexec](https://github.com/kurtbuilds/checkexec) |
| claude | [@anthropic-ai/claude-code](https://www.npmjs.com/package/@anthropic-ai/claude-code) |
| cloudflared | [cloudflare/cloudflared](https://github.com/cloudflare/cloudflared) |
| codex | [@openai/codex](https://www.npmjs.com/package/@openai/codex) |
| direnv | [direnv/direnv](https://github.com/direnv/direnv) |
| eget | [zyedidia/eget](https://github.com/zyedidia/eget) |
| envsubst | [a8m/envsubst](https://github.com/a8m/envsubst) |
| fzf | [junegunn/fzf](https://github.com/junegunn/fzf) |
| gemini | [@google/gemini-cli](https://www.npmjs.com/package/@google/gemini-cli) |
| gh | [cli/cli](https://github.com/cli/cli) |
| ghq | [x-motemen/ghq](https://github.com/x-motemen/ghq) |
| git | [git-scm.com](https://git-scm.com/) |
| gitlint | [jorisroovers/gitlint](https://github.com/jorisroovers/gitlint) |
| gnupg | [gnupg.org](https://gnupg.org/) |
| go | [go.dev](https://go.dev/) |
| gopls | [golang/tools](https://github.com/golang/tools) |
| ideavim | [JetBrains/ideavim](https://github.com/JetBrains/ideavim) |
| intelephense | [intelephense.com](https://intelephense.com/) |
| jnal | [longkey1/jnal](https://github.com/longkey1/jnal) |
| jq | [itchyny/gojq](https://github.com/itchyny/gojq) |
| just | [casey/just](https://github.com/casey/just) |
| lf | [gokcehan/lf](https://github.com/gokcehan/lf) |
| llmc | [longkey1/llmc](https://github.com/longkey1/llmc) |
| lnkr | [longkey1/lnkr](https://github.com/longkey1/lnkr) |
| pam_environment | - |
| rg | [BurntSushi/ripgrep](https://github.com/BurntSushi/ripgrep) |
| rn | - |
| ssh | - |
| starship | [starship/starship](https://github.com/starship/starship) |
| sws | [joseluisq/static-web-server](https://github.com/joseluisq/static-web-server) |
| systemd | - |
| tmux | [tmux/tmux](https://github.com/tmux/tmux) |
| usql | [xo/usql](https://github.com/xo/usql) |
| vim | [vim/vim](https://github.com/vim/vim) |
| xh | [ducaale/xh](https://github.com/ducaale/xh) |
| yq | [mikefarah/yq](https://github.com/mikefarah/yq) |
| zenhan | [iuchim/zenhan](https://github.com/iuchim/zenhan) |
| zsh | [zsh.org](https://www.zsh.org/) |

## rn (Run) コマンド

プロジェクトごとにカスタムサブコマンドを定義できる CLI ツール。[argc](https://github.com/sigoden/argc) を使ったコマンド定義と zsh 補完をサポートしています。

### 仕組み

- 各リポジトリに `bin/rn` スクリプトと `.rn/` ディレクトリを配置する
- `direnv` の `.envrc` で `PATH_add bin` を設定し、`rn` コマンドをリポジトリ内で有効にする
- zsh 補完関数 (`_rn`) はカレントディレクトリから `.rn/` を探索し、argc による動的補完を提供する

### リポジトリでの作成方法

#### 1. ディレクトリ構造を作成

```
your-repo/
├── .envrc              # direnv 設定
├── .rn/
│   └── completions/
│       └── _rn_extra   # (任意) プロジェクト固有の補完拡張
├── bin/
│   └── rn              # メインスクリプト
└── scripts/
    └── rn/             # サブコマンドの実装
        └── hello/
            └── world.sh
```

#### 2. `.envrc` を設定

```bash
PATH_add bin
```

#### 3. `bin/rn` を作成

argc のアノテーションでコマンドを定義します。

```bash
#!/usr/bin/env bash
# @describe My project CLI

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

# @cmd Say hello
# @arg name! Name to greet
hello() {
    echo "Hello, ${argc_name}!"
}

# @cmd Greet subcommands
greet() { :; }

# @cmd Say good morning
# @arg name Name (default: World)
greet::morning() {
    echo "Good morning, ${argc_name:-World}!"
}

eval "$(argc --argc-eval "$0" "$@")"
```

```bash
chmod +x bin/rn
```

#### 4. 動作確認

```bash
direnv allow
rn hello Alice          # => Hello, Alice!
rn greet::morning       # => Good morning, World!
rn --help               # => コマンド一覧を表示
rn hello <TAB>          # => zsh 補完が動作
```

### argc アノテーション

| アノテーション | 説明 | 例 |
|---|---|---|
| `# @describe` | スクリプト全体の説明 | `# @describe My project CLI` |
| `# @cmd` | サブコマンドの説明 | `# @cmd Run tests` |
| `# @arg name` | 引数（任意） | `# @arg target Target date` |
| `# @arg name!` | 引数（必須） | `# @arg url! PR URL` |
| `# @arg name*[a\|b\|c]` | 引数（選択肢付き） | `# @arg targets*[build\|clean]` |
| `# @flag --name` | フラグ | `# @flag --force Force execution` |

詳細は [argc ドキュメント](https://github.com/sigoden/argc) を参照してください。

### 補完の拡張 (任意)

`.rn/completions/_rn_extra` にプロジェクト固有の補完ロジックを追加できます。

```bash
# .rn/completions/_rn_extra
_rn_extra() {
    local words=("$@")
    # カスタム補完ロジック
    return 1  # 0: 補完済み、1: argc にフォールバック
}
```
