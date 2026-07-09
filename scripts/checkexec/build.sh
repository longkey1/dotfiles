#!/usr/bin/env bash

REPOSITORY="kurtbuilds/checkexec"

"${LOCAL_BIN}"/eget ${REPOSITORY} --to "${LOCAL_BIN}"/ --upgrade-only
