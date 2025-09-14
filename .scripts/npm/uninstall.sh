#!/usr/bin/env zsh

. ${SCRIPTS}/functions

# npmでインストールされたツール（node_modulesへのシンボリックリンク）のシンボリックリンクを削除
for target in $(find "${ROOT}/local/bin" -type l -name "*" | xargs ls -l | grep "node_modules" | awk '{print $(NF-2)}' | sed "s|.*local/bin/||"); do
    unsymlink "local/bin/${target}"
done
