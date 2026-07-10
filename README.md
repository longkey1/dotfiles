# dotfiles

個人用の dotfiles リポジトリです。

## Prerequisites

`make build` / `make install` を実行する前に以下をインストールしてください。

### macOS

```bash
# Xcode Command Line Tools（git / make / curl / tar が含まれる）
xcode-select --install

# Homebrew パッケージ
brew install node gettext gnupg
```

### Debian/Ubuntu

```bash
# 基本ツール
sudo apt install -y build-essential curl git gettext-base gnupg

# Node.js (LTS)
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs
```

## Installation

### Clone & Setup

```bash
mkdir -p $HOME/work/src/github.com/longkey1
git clone git@github.com:longkey1/dotfiles.git $HOME/work/src/github.com/longkey1/dotfiles
cd $HOME/work/src/github.com/longkey1/dotfiles

# Setup secrets
cp scripts/secrets.env.dist scripts/secrets.env
vim scripts/secrets.env

# Build and install
make build
make install
```

## Secrets

ビルド時にいくつかのスクリプトは秘匿情報を必要とします。これらは `scripts/secrets.env` から環境変数として読み込まれ、`git config` の署名鍵設定（`scripts/git/build_config.sh`）や GPG パスフレーズの preset（`scripts/zsh/build_gpg.sh`）、Bitwarden CLI のログイン（`scripts/bitwarden/build.sh`）などで使われます。

`scripts/secrets.env` は `.gitignore` 済みでコミットされません。`scripts/secrets.env.dist` をコピーして各値を埋めてください。

```bash
cp scripts/secrets.env.dist scripts/secrets.env
vim scripts/secrets.env
```

### 環境変数の取得方法

| 変数 | 説明 | 取得方法 |
|------|------|----------|
| `GPG_KEYGRIP` | GPG 鍵の keygrip。`gpg-preset-passphrase` でパスフレーズを preset する際に使用 | 下記コマンドの `Keygrip` 行 |
| `GPG_KEYID` | GPG 署名鍵の long ID。git の `user.signingkey` に使用 | 下記コマンドの `sec` 行のキーID |
| `BW_CLIENTID` | Bitwarden CLI の API キー (client_id) | [Bitwarden Personal API Key](https://bitwarden.com/help/personal-api-key/) |
| `BW_CLIENTSECRET` | Bitwarden CLI の API キー (client_secret) | [Bitwarden Personal API Key](https://bitwarden.com/help/personal-api-key/) |

`GPG_KEYGRIP` と `GPG_KEYID` は、GPG 鍵をインポート済みの環境で次のコマンドから確認できます。

```bash
gpg --list-secret-keys --keyid-format=long --with-keygrip
```

```
sec   rsa4096/ABCDEF0123456789 2023-01-01 [SC]
      ^^^^^^^ ^^^^^^^^^^^^^^^^
      |       └─ この `/` の後ろが GPG_KEYID（例: ABCDEF0123456789）
      └─ 鍵の種類とビット数
      Keygrip = 0123456789ABCDEF0123456789ABCDEF01234567
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                └─ この `Keygrip =` の値が GPG_KEYGRIP
uid                 [ultimate] Your Name <you@example.com>
ssb   rsa4096/1122334455667788 2023-01-01 [E]
      Keygrip = 89ABCDEF89ABCDEF89ABCDEF89ABCDEF89ABCDEF
```

- `GPG_KEYID` は **`[S]`（署名能力）を持つ鍵** のキーID を使います。`/` 直後の 16 桁がキーID です。上の例では `sec` 行が `[SC]` なので `sec` を使いますが、鍵構成によっては署名用サブ鍵（例: `ssb ... [S]`）側を選ぶ必要があります。`[C]`（認証のみ）や `[E]`（暗号化のみ）の鍵は対象外です。
- `GPG_KEYGRIP` は上で選んだ署名鍵（`GPG_KEYID` と同じ行）に対応する直下の `Keygrip` の値を使います。git の `user.signingkey` は `!` 付き（厳密指定）で設定されるため、preset する Keygrip は実際に署名する鍵のものと一致している必要があります。

`BW_CLIENTID` / `BW_CLIENTSECRET` は Bitwarden の Web Vault の `Account Settings > Security > Keys > API Key` から取得できます。なお GPG パスフレーズや一部 API キーは Bitwarden 上に保管され、ビルド時に `bw` 経由で取得されます（`scripts/zsh/build_gpg.sh` 等）。そのため `make build` 前に Bitwarden CLI へログイン可能な状態にしておく必要があります。

### GPG 鍵の復元

git のコミット署名（`commit.gpgsign = true`）に GPG 秘密鍵が必要です。新しい環境では事前に鍵をインポートしてください。鍵をインポートしていないと `scripts/zsh/build_gpg.sh` のパスフレーズ preset が失敗します。

バックアップ（既存環境でエクスポート）:

```bash
# 秘密鍵をエクスポート（ASCII armor 形式）
gpg --export-secret-keys --armor ${GPG_KEYID} > secret-key.asc
# 信頼情報をエクスポート
gpg --export-ownertrust > ownertrust.txt
```

エクスポートした `secret-key.asc` とパスフレーズは Bitwarden 等の安全な場所に保管してください（リポジトリにはコミットしないこと）。

復元（新しい環境でインポート）:

```bash
# 秘密鍵をインポート（パスフレーズの入力を求められる）
gpg --import secret-key.asc
# 信頼情報をインポート
gpg --import-ownertrust ownertrust.txt
# インポート結果を確認
gpg --list-secret-keys --keyid-format=long --with-keygrip
```

インポート後、確認コマンドの出力から `[S]`（署名能力）を持つ鍵のキーID（`/` の後ろ）と `Keygrip`（その直下の値）を読み取り、`scripts/secrets.env` の `GPG_KEYID` / `GPG_KEYGRIP` に設定してから `make build` を実行してください。どの部分を使うかは上記「[環境変数の取得方法](#環境変数の取得方法)」の出力例を参照してください。

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
| `make build` | 全パッケージをビルド（依存を自動解決） |
| `make install` | シンボリックリンクを作成 |
| `make uninstall` | シンボリックリンクを削除 |
| `make update` | ビルドファイルを更新 |
| `make clean` | ビルドファイルを削除 |
| `make lint` | scripts 配下を shfmt（チェック）と shellcheck で検査 |
| `make fmt` | scripts 配下を shfmt で整形 |

### 個別実行

各アクションは `<action>-<package>` 形式で単一パッケージのみ実行できます。

```bash
make build-gopls    # go を先にビルドしてから gopls をビルド
make build-rg       # eget を先に用意してから rg をビルド
make install-zsh    # zsh のみインストール
make clean-tmux     # tmux のみクリーン
```

### 依存関係

パッケージ間のビルド依存は `scripts/<package>/deps` に直接依存を1行1つで宣言します（依存がなければファイル不要）。`make build` および `make build-<package>` 実行時に Make が依存を辿って正しい順序で解決します。

```
# scripts/gopls/deps
go
```

例えば `make build-gopls` は `go` → `gopls` の順に、`make build-rg` は `bin` → `eget` → `rg` の順に自動でビルドされます。複数パッケージから要求される共通の依存（`eget` など）は `make build` 全体でも一度だけビルドされます。

### システムコマンド要件

パッケージが PATH 上のシステムコマンドを必要とする場合は `scripts/<package>/system_deps` に1行1つで宣言します。`make build-<package>` 実行前にコマンドの存在チェックが走り、見つからない場合はエラーで停止します。

```
# scripts/claude/system_deps
npm
```

### Lint / Format

`scripts/` 配下のシェルスクリプト（`*.sh` と `scripts/functions`）は bash スクリプトで、[shfmt](https://github.com/mvdan/sh) と [ShellCheck](https://www.shellcheck.net/) が通る状態を維持します。

```bash
# インストール（macOS）
brew install shfmt shellcheck

# インストール（Debian/Ubuntu）
sudo apt install -y shfmt shellcheck

# 検査
make lint

# 整形
make fmt
```

- shfmt のスタイル（2スペースインデント、`space_redirects`）は `.editorconfig` で定義しています（shfmt はフラグ無し実行時に `.editorconfig` を読みます）
- shellcheck の除外ルールとその理由は `.shellcheckrc` に記載しています

## Targets

| Target | Link |
|--------|------|
| argc | [sigoden/argc](https://github.com/sigoden/argc) |
| bin | - |
| bitwarden | [@bitwarden/cli](https://www.npmjs.com/package/@bitwarden/cli) |
| checkexec | [kurtbuilds/checkexec](https://github.com/kurtbuilds/checkexec) |
| claude | [@anthropic-ai/claude-code](https://www.npmjs.com/package/@anthropic-ai/claude-code) |
| cloudflared | [cloudflare/cloudflared](https://github.com/cloudflare/cloudflared) |
| codex | [@openai/codex](https://www.npmjs.com/package/@openai/codex) |
| direnv | [direnv/direnv](https://github.com/direnv/direnv) |
| eget | [zyedidia/eget](https://github.com/zyedidia/eget) |
| fzf | [junegunn/fzf](https://github.com/junegunn/fzf) |
| gemini | [@google/gemini-cli](https://www.npmjs.com/package/@google/gemini-cli) |
| gh | [cli/cli](https://github.com/cli/cli) |
| ghq | [x-motemen/ghq](https://github.com/x-motemen/ghq) |
| git | [git-scm.com](https://git-scm.com/) |
| gnupg | [gnupg.org](https://gnupg.org/) |
| go | [go.dev](https://go.dev/) |
| gopls | [golang/tools](https://github.com/golang/tools) |
| herdr | [ogulcancelik/herdr](https://github.com/ogulcancelik/herdr) |
| ideavim | [JetBrains/ideavim](https://github.com/JetBrains/ideavim) |
| intelephense | [intelephense.com](https://intelephense.com/) |
| jnal | [longkey1/jnal](https://github.com/longkey1/jnal) |
| jq | [jqlang/jq](https://github.com/jqlang/jq) |
| lf | [gokcehan/lf](https://github.com/gokcehan/lf) |
| llmc | [longkey1/llmc](https://github.com/longkey1/llmc) |
| lnkr | [longkey1/lnkr](https://github.com/longkey1/lnkr) |
| pam_environment | - |
| rg | [BurntSushi/ripgrep](https://github.com/BurntSushi/ripgrep) |
| rn | - |
| run | [longkey1/run](https://github.com/longkey1/run) |
| ssh | - |
| starship | [starship/starship](https://github.com/starship/starship) |
| systemd | - |
| tmux | [tmux/tmux](https://github.com/tmux/tmux) |
| vim | [vim/vim](https://github.com/vim/vim) |
| xh | [ducaale/xh](https://github.com/ducaale/xh) |
| yq | [mikefarah/yq](https://github.com/mikefarah/yq) |
| zenhan | [iuchim/zenhan](https://github.com/iuchim/zenhan) |
| zsh | [zsh.org](https://www.zsh.org/) |

## rn (Run) コマンド

プロジェクトごとにカスタムサブコマンドを定義できる CLI ツール。[argc](https://github.com/sigoden/argc) を使ったコマンド定義と zsh 補完をサポートしています。

### 仕組み

- 各リポジトリに `.rn/bin/rn` スクリプトと `.rn/` ディレクトリを配置する
- `direnv` の `.envrc` で `PATH_add .rn/bin` を設定し、`rn` コマンドをリポジトリ内で有効にする
- zsh 補完関数 (`_rn`) はカレントディレクトリから `.rn/` を探索し、argc による動的補完を提供する

### リポジトリでの作成方法

#### 1. ディレクトリ構造を作成

```
your-repo/
├── .envrc              # direnv 設定
├── .rn/
│   ├── bin/
│   │   └── rn          # メインスクリプト
│   └── completions/
│       └── _rn_extra   # (任意) プロジェクト固有の補完拡張
└── scripts/
    └── rn/             # サブコマンドの実装
        └── hello/
            └── world.sh
```

#### 2. `.envrc` を設定

```bash
PATH_add .rn/bin
```

#### 3. `.rn/bin/rn` を作成

argc のアノテーションでコマンドを定義します。

```bash
#!/usr/bin/env bash
# @describe My project CLI

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

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
chmod +x .rn/bin/rn
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
