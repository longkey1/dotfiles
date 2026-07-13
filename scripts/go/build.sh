#!/usr/bin/env bash

BINARY="go"
GO_INSTALL_DIR="${ROOT}/local/go"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

if [ "${ARCH}" = "x86_64" ]; then
  ARCH="amd64"
elif [ "${ARCH}" = "aarch64" ]; then
  ARCH="arm64"
fi

LATEST_VERSION=$("${LOCAL_BIN}"/xh --follow --body GET "https://go.dev/VERSION?m=text" | head -1)

if [ -d "${GO_INSTALL_DIR}" ]; then
  CURRENT_VERSION=$("${GO_INSTALL_DIR}"/bin/go version 2>/dev/null | awk '{print $3}')
  if [ "${CURRENT_VERSION}" = "${LATEST_VERSION}" ]; then
    echo "go: already up to date: ${CURRENT_VERSION}"
    exit 0
  fi
fi

WORK_DIR=/tmp/dotfiles-${BINARY}-${USER}
mkdir -p "${WORK_DIR}"
pushd "${WORK_DIR}" || exit

TARBALL="${LATEST_VERSION}.${OS}-${ARCH}.tar.gz"
"${LOCAL_BIN}"/xh --follow --download "https://go.dev/dl/${TARBALL}" --output "${TARBALL}"

rm -rf "${GO_INSTALL_DIR}"
tar -C "${ROOT}"/local -xzf "${TARBALL}"

popd || exit
rm -rf "${WORK_DIR}"
