#!/usr/bin/env zsh

. ${SCRIPTS}/functions
. ${SCRIPTS}/npm/packages.sh

unsymlink config/npm

for package in "${PACKAGES[@]}"; do
    npm uninstall --global --prefix "${ROOT}/local" "${package}"
done
