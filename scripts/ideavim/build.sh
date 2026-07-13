#!/usr/bin/env bash

OS=$(uname -s | tr '[:upper:]' '[:lower:]')

if [ ! -h "${LOCAL_CONFIG}"/ideavim/ideavimrc ]; then
  ln -s "${LOCAL_CONFIG}"/ideavim/ideavimrc."${OS}" "${LOCAL_CONFIG}"/ideavim/ideavimrc
fi
