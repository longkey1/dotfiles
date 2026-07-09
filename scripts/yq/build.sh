#!/usr/bin/env bash

REPOSITORY="mikefarah/yq"

# OS/arch は eget が自動検出する。--asset で生バイナリを除き tar.gz に絞り、--file で tarball 内のバイナリのみ抽出する。
"${LOCAL_BIN}"/eget ${REPOSITORY} --to "${LOCAL_BIN}"/yq --asset .tar.gz --file 'yq_*' --upgrade-only
