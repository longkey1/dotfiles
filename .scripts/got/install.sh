#!/usr/bin/env zsh

APP="got"

. ${SCRIPTS}/functions

symlink local/bin/${APP}
symlink config/${APP}
