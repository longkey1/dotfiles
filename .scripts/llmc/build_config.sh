#!/usr/bin/env zsh

. ${SCRIPTS}/functions
bw_session=$(get_bitwarden_session)

export GEMINI_API_KEY=$(${LOCAL_BIN}/bw get notes a317aaf3-bb1e-4f52-8f07-b27f010add73 --session "${bw_session}")
envsubst '${HOME}' < ${LOCAL_CONFIG}/llmc/config.toml.dist > ${LOCAL_CONFIG}/llmc/config.toml
