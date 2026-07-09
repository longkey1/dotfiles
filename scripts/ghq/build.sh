#!/usr/bin/env bash

REPOSITORY="x-motemen/ghq"

"${LOCAL_BIN}"/eget ${REPOSITORY} --to "${LOCAL_BIN}"/ --upgrade-only
