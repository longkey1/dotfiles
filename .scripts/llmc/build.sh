#!/usr/bin/env zsh

REPOSITORY="longkey1/llmc"
CURRENT=$(cd $(dirname $0);pwd)

${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/ --upgrade-only

${LOCAL_BIN}/checkexec ${LOCAL_CONFIG}/llmc/config.toml ${LOCAL_CONFIG}/llmc/config.toml.dist -- env LOCAL_CONFIG=${LOCAL_CONFIG} ${CURRENT}/build_config.sh
mkdir -p ${LOCAL_CONFIG}/zsh/functions
${LOCAL_BIN}/llmc --config ${LOCAL_CONFIG}/llmc/config.toml completion zsh > ${LOCAL_CONFIG}/zsh/functions/_llmc
