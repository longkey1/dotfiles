# dotfiles

## Installation

```
$ mkdir -p $HOME/work/src/github.com/longkey1
$ git clone git@github.com:longkey1/dotfiles.git $HOME/work/src/github.com/longkey1/dotfiles
$ pushd $HOME/work/src/github.com/longkey1/dotfiles && make build && make install && popd
```

## Configuration

### golang sample using direnv

```
PATH_add ~/.goroots/1.23.45/bin
export GOROOT=~/.goroots/1.23.45
export GOPATH=~/work
export GO111MODULE=on
```
