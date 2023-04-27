# dotfiles

## Installation

```
$ mkdir -p $HOME/work/src/github.com/longkey1

$ git clone git@github.com:longkey1/dotfiles.git $HOME/work/src/github.com/longkey1/dotfiles
$ cd $HOME/work/src/github.com/longkey1/dotfiles

# secrets.env
cp .dotfiles/secrets.env.dist .dotfiles/secrets.env
vim .dotfiles/secrets.env

$ make build
$ make install
