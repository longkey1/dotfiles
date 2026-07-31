#!/usr/bin/env bash

REPOSITORY="charmbracelet/glow"

"${LOCAL_BIN}"/eget ${REPOSITORY} --to "${LOCAL_BIN}"/glow --upgrade-only --asset ^sbom
