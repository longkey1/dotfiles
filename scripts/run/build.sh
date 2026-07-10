#!/usr/bin/env bash

REPOSITORY="longkey1/run"

"${LOCAL_BIN}"/eget ${REPOSITORY} --to "${LOCAL_BIN}"/ --upgrade-only

mkdir -p "${LOCAL_CONFIG}"/zsh/functions
"${LOCAL_BIN}"/run self completion zsh > "${LOCAL_CONFIG}"/zsh/functions/_run
