#!/usr/bin/env bash

REPOSITORY="junegunn/fzf"

"${LOCAL_BIN}"/eget ${REPOSITORY} --to "${LOCAL_BIN}"/ --upgrade-only
