#!/usr/bin/env bash

REPOSITORY="ogulcancelik/herdr"

# リリースアセットは圧縮なしの単体バイナリ (herdr-{macos,linux}-{aarch64,x86_64}) なので、OS/arch の自動検出のみで取得できる。
"${LOCAL_BIN}"/eget ${REPOSITORY} --to "${LOCAL_BIN}"/herdr --upgrade-only
