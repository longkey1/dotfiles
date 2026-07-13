#!/usr/bin/env bash

REPOSITORY="goreleaser/goreleaser"

# リリースには deb/rpm/apk・Darwin_all (universal binary)・*.tar.gz.sbom.json も含まれるため、arch 別の tar.gz に絞る。
"${LOCAL_BIN}"/eget ${REPOSITORY} --to "${LOCAL_BIN}"/goreleaser --upgrade-only --asset tar.gz --asset ^all --asset ^sbom
