#!/usr/bin/env bash

REPOSITORY="jqlang/jq"

# OS/arch は eget が自動検出する。
# x86_64環境にて jq-linux-amd64 と jq-linux64 が重複して競合するのを防ぐため、後方互換用アセットである linux64 を除外する。
"${LOCAL_BIN}"/eget ${REPOSITORY} --to "${LOCAL_BIN}"/jq --asset ^.tar.gz --asset ^linux64 --upgrade-only
