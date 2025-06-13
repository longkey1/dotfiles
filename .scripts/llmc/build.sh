#!/usr/bin/env zsh

BINARY="llmc"
REPOSITORY="longkey1/llmc"
CURRENT=$(cd $(dirname $0);pwd)

${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/${BINARY} --upgrade-only

${LOCAL_BIN}/checkexec ${LOCAL_CONFIG}/llmc/config.toml ${LOCAL_CONFIG}/llmc/config.toml.dist -- env LOCAL_CONFIG=${LOCAL_CONFIG} ${CURRENT}/build_config.sh
