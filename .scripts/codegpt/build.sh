#!/usr/bin/env zsh

BINARY="codegpt"
REPOSITORY="appleboy/CodeGPT"

if [ ! -x "${LOCAL_BIN}/${BINARY}" ]; then
  ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/${BINARY} --asset=^.xz
fi

. ${SCRIPTS}/functions
bw_session=$(get_bitwarden_session)

export GEMINI_API_KEY=$(${LOCAL_BIN}/bw get notes a317aaf3-bb1e-4f52-8f07-b27f010add73 --session "${bw_session}")
envsubst '${GEMINI_API_KEY}' < ${LOCAL_CONFIG}/codegpt/.codegpt.yaml.dist > ${LOCAL_CONFIG}/codegpt/.codegpt.yaml
