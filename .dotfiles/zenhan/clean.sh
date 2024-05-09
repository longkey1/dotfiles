#!/usr/bin/env zsh

BINARY="zenhan.exe"
WIN_BIN="/mnt/c/Users/$(powershell.exe '$env:USERNAME' | tr -d '\r')/Program Files/zenhan"

rm -rf ${WIN_BIN}
