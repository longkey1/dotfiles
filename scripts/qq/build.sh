#!/usr/bin/env bash

REPOSITORY="JFryy/qq"

# OS/arch は eget が自動検出する。--asset で .md5 を除いて tar.gz に絞り、--file で tarball 内のバイナリのみ抽出する。
"${LOCAL_BIN}"/eget ${REPOSITORY} --to "${LOCAL_BIN}"/qq --asset .tar.gz --asset ^.md5 --file qq --upgrade-only
