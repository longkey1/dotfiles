#!/usr/bin/env bash

REPOSITORY="zenbu-labs/terminal-browser"
INSTALL_DIR="${LOCAL_OPT}/terminal-browser"

LATEST_VERSION=$("${LOCAL_BIN}"/xh --follow --body GET "https://api.github.com/repos/${REPOSITORY}/releases/latest" | "${LOCAL_BIN}"/jq -r .tag_name)

if [ -f "${INSTALL_DIR}/VERSION" ]; then
  CURRENT_VERSION=$(cat "${INSTALL_DIR}/VERSION")
  if [ "${CURRENT_VERSION}" = "${LATEST_VERSION}" ]; then
    echo "terminal-browser: already up to date: ${CURRENT_VERSION}"
    exit 0
  fi
fi

WORK_DIR=/tmp/dotfiles-terminal-browser-${USER}
mkdir -p "${WORK_DIR}"
pushd "${WORK_DIR}" || exit

# アーカイブは Electron app を含むディレクトリ構成のため、eget での展開（フラット化される）は使わずダウンロードのみ行う
"${LOCAL_BIN}"/eget "${REPOSITORY}" --download-only --asset tar.gz
rm -rf "${INSTALL_DIR}"
tar -C "${LOCAL_OPT}" -xzf terminal-browser-*.tar.gz

popd || exit
rm -rf "${WORK_DIR}"

# launcher は $0 の位置から相対で app を解決するため、symlink ではなく wrapper を生成する
cat >"${LOCAL_BIN}"/terminal-browser <<EOF
#!/bin/sh
exec "${INSTALL_DIR}/bin/terminal-browser" "\$@"
EOF
chmod +x "${LOCAL_BIN}"/terminal-browser
