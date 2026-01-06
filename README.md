# dotfiles

## Installation

```
$ mkdir -p $HOME/work/src/github.com/longkey1

$ git clone git@github.com:longkey1/dotfiles.git $HOME/work/src/github.com/longkey1/dotfiles
$ cd $HOME/work/src/github.com/longkey1/dotfiles

# secrets.env
cp .scripts/secrets.env.dist .scripts/secrets.env
vim .scripts/secrets.env

$ make build
$ make install
