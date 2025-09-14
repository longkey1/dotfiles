#!/usr/bin/env zsh

. ${SCRIPTS}/functions
. ${SCRIPTS}/npm/packages.sh

symlink config/npm

for package in "${PACKAGES[@]}"; do
    npm install --global --prefix "${ROOT}/local" "${package}"
done
