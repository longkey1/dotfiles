#!/usr/bin/env zsh

BINARY="gh"

rm -f ${LOCAL_BIN}/${BINARY}

#
rm -f ${LOCAL_CONFIG}/gh/credentials.json
rm -f ${LOCAL_CONFIG}/gh/hosts.yml
