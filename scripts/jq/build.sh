#!/usr/bin/env bash

REPOSITORY="jqlang/jq"

# OS/arch は eget が自動検出する。リリースの tar.gz はソースアーカイブのため除外し、raw バイナリの asset を直接取得する。
"${LOCAL_BIN}"/eget ${REPOSITORY} --to "${LOCAL_BIN}"/jq --asset ^.tar.gz --upgrade-only
