#!/usr/bin/env zsh

. ${SCRIPTS}/functions

GOBIN="${ROOT}/local/bin" "${ROOT}/local/go/bin/go" install golang.org/x/tools/gopls@latest
