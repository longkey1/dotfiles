# load zgen
[[ -f "${HOME}/.zgen/zgen.zsh" ]] && source "${HOME}/.zgen/zgen.zsh"

# if the init scipt doesn't exist
if ! zgen saved; then

  # specify plugins here
  zgen oh-my-zsh
  zgen oh-my-zsh themes/clean

  zgen load zsh-users/zsh-completions
  zgen load zsh-users/zsh-history-substring-search
  zgen load zsh-users/zsh-syntax-highlighting

  # generate the init script from plugins above
  zgen save
fi

# include .zshrc.mine
[[ -f ~/.zshrc.mine ]] && source ~/.zshrc.mine

# include .zshrc.local
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
