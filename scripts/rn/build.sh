#!/usr/bin/env zsh

CURRENT=$(cd $(dirname $0);pwd)

mkdir -p ${LOCAL_CONFIG}/zsh/functions
checkexec ${LOCAL_CONFIG}/zsh/functions/_rn ${CURRENT}/_rn -- cp ${CURRENT}/_rn ${LOCAL_CONFIG}/zsh/functions/_rn
