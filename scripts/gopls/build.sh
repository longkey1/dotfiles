#!/usr/bin/env zsh

. ${SCRIPTS}/functions

GOBIN="${ROOT}/local/bin" go install golang.org/x/tools/gopls@latest
