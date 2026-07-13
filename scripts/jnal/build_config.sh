#!/usr/bin/env bash

envsubst '${HOME}' <"${LOCAL_CONFIG}"/jnal/config.toml.dist >"${LOCAL_CONFIG}"/jnal/config.toml
