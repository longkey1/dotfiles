#!/usr/bin/env zsh

APP="got"

. ${SCRIPTS}/functions

unsymlink local/bin/${APP}
unsymlink config/${APP}
