#!/usr/bin/env bash

REPOSITORY="mikefarah/yq"

# OS/arch は eget が自動検出する。tar.gz 内のバイナリ名が yq_<os>_<arch> のため、raw バイナリの asset を直接取得する。
"${LOCAL_BIN}"/eget ${REPOSITORY} --to "${LOCAL_BIN}"/yq --asset ^.tar.gz --upgrade-only
