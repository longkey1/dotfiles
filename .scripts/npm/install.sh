#!/usr/bin/env zsh

. ${SCRIPTS}/functions

# npmでインストールされたツール（node_modulesへのシンボリックリンク）のシンボリックリンクを作成
for target in $(find "${ROOT}/local/bin" -type l -name "*" | xargs ls -l | grep "node_modules" | awk '{print $(NF-2)}' | sed "s|.*local/bin/||"); do
    # シンボリックリンクの場合は、直接絶対パスでリンク
    if [ -h "${ROOT}/local/bin/${target}" ]; then
        symlink_to_symlink "${target}"
    else
        symlink "local/bin/${target}"
    fi
done