#!/usr/bin/env bash

REPOSITORY="gokcehan/lf"

"${LOCAL_BIN}"/eget ${REPOSITORY} --to "${LOCAL_BIN}"/ --upgrade-only
