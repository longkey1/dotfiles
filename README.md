# dotfiles

## Installation

```
$ mkdir -p $HOME/work/src/github.com/longkey1

$ git clone git@github.com:longkey1/dotfiles.git $HOME/work/src/github.com/longkey1/dotfiles
$ cd $HOME/work/src/github.com/longkey1/dotfiles

# secrets.env
cp .scripts/secrets.env.dist .scripts/secrets.env
vim .scripts/secrets.env

# Node.js
$ curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
$ sudo apt install nodejs -y

# vim
$ sudo apt install vim -y

# tmux
$ sudo apt install tmux -y

$ make build
$ make install
```
