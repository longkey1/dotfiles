#!/usr/bin/env bash

BINARY="bw"
"${LOCAL_BIN}"/${BINARY} logout
rm -f "${LOCAL_BIN}"/${BINARY}
