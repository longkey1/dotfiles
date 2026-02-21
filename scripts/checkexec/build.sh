#!/usr/bin/env zsh

REPOSITORY="kurtbuilds/checkexec"

${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/ --upgrade-only
