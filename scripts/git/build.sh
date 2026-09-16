#!/usr/bin/env bash

CURRENT=$(cd "$(dirname "$0")" && pwd)
. "${SCRIPTS}"/functions

set -a && . "${SCRIPTS}"/secrets.env && set +a
checkexec "${LOCAL_CONFIG}"/git/config "${LOCAL_CONFIG}"/git/config.dist "${SCRIPTS}"/secrets.env -- "${CURRENT}"/build_config.sh
