# dotfiles

## Installation

```
$ mkdir -p $HOME/work/src/github.com/longkey1

$ git clone git@github.com:longkey1/dotfiles.git $HOME/work/src/github.com/longkey1/dotfiles
$ cd $HOME/work/src/github.com/longkey1/dotfiles

$ make init

# secrets.env
cp dotfiles/secrets.env.dist dotfiles/secrets.env
vim dotfiles/secrets.env

# bitwarden
./bin/bw login
export BW_SESSION
```

$ make build
$ make install

## Configuration

### golang sample using direnv

```
PATH_add ~/.goroots/1.23.45/bin
export GOROOT=~/.goroots/1.23.45
export GOPATH=~/work
export GO111MODULE=on
```
