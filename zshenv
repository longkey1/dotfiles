export XDG_CONFIG_HOME="${HOME}/.config"
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"

#
# environment variables
#
## common
export EDITOR="vim"
export VISUAL="vim"
export PAGER="less"

#
# Applications
#
## go
export GOPATH="${XDG_DATA_HOME:-${HOME}/.local/share}/go"

## docker-compose
export LOCAL_UID=${UID}
export LOCAL_GID=${GID}

#
# Include files
#
## include ostype files
case ${OSTYPE} in
  darwin*) _ostype=darwin ;;
  linux*) _ostype=linux ;;
esac
[[ -n ${_ostype} && -f ${ZDOTDIR}/zshenv.${_ostype} ]] && source ${ZDOTDIR}/zshenv.${_ostype}
unset _ostype

## include local file
[[ -f ${ZDOTDIR}/zshenv.local ]] && source ${ZDOTDIR}/zshenv.local
