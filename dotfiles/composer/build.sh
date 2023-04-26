#!/usr/bin/env zsh

export GITHUB_PERSONAL_ACCESS_TOKEN=$(${LOCAL_BIN}/bw get password afcc443a-6d28-4950-b83b-afeb004c167b)
envsubst '${GITHUB_PERSONAL_ACCESS_TOKEN}' < ${LOCAL_CONFIG}/composer/auth.json.dist > ${LOCAL_CONFIG}/composer/auth.json
