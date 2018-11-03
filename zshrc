# include .zshrc.antigen
[[ -f $HOME/.zsh/zshrc.antigen ]] && source $HOME/.zsh/zshrc.antigen

# functions
function excutable() {
  type "$1" &> /dev/null;
}

# general
export EDITOR="vim"
export VISUAL="vim"
export PAGER="less"

# no create core dump file
ulimit -c 0

# path .bin
export PATH="$HOME/.bin:$PATH"

# fpath .zsh/functions
if [[ -d $HOME/.zsh/functions ]]; then
  export FPATH="$HOME/.zsh/functions:$FPATH"
fi

# phpenv
if [[ -d $HOME/.phpenv ]]; then
  export PATH="$HOME/.phpenv/bin:$PATH"
  eval "$(phpenv init -)"
fi

# rbenv
if [[ -d $HOME/.rbenv ]]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

# pyenv
if [[ -d $HOME/.pyenv ]]; then
  export PATH="$HOME/.pyenv/bin:$PATH"
  eval "$(pyenv init -)"
fi

# linuxbrew
if [[ -d $HOME/.linuxbrew ]]; then
  export PATH="$HOME/.linuxbrew/bin:$PATH"
  export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
  export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"
fi

# nvm
if [[ -d $HOME/.nvm ]]; then
  export NVM_DIR="$HOME/.nvm"
  if [[ -s "$NVM_DIR/nvm.sh" ]] then
    . "$NVM_DIR/nvm.sh"
  fi
fi

# ruby
if excutable ruby && excutable gem; then
  export PATH="$(ruby -e 'puts Gem.user_dir')/bin:$PATH"
fi

# go
if excutable go && [[ -d "$HOME/work" ]]; then
  export GOPATH="$HOME/work"
  export PATH="$GOPATH/bin:$PATH"
fi

# git/diff-highlight
# for mac
if [[ -d /usr/local/share/git-core/contrib/diff-highlight ]]; then
  export PATH=$PATH:/usr/local/share/git-core/contrib/diff-highlight
# for arch
elif [[ -d /usr/share/git/diff-highlight ]]; then
  export PATH=$PATH:/usr/share/git/diff-highlight
# for debian or ubuntu
elif [[ -d /usr/share/doc/git/contrib/diff-highlight ]]; then
  export PATH=$PATH:/usr/share/doc/git/contrib/diff-highlight
fi

# direnv
if excutable direnv; then
  eval "$(direnv hook zsh)"
fi

# alias
if excutable ls; then
  alias ll="ls -l"
fi
if excutable vim; then
  alias vi="vim"
fi
if excutable grep; then
  alias grep="grep -I --color=auto"
  # for grep's glob
  setopt nonomatch
fi
if excutable jq; then
  alias jq="jq -C"
fi
if excutable tmux && [[ "${OSTYPE}" =~ ^darwin* ]]; then
  alias tmux="tmux -2 -u"
fi
# nocorrect alias
alias jekyll="nocorrect jekyll"
alias cleaver="nocorrect cleaver"

# less
export LESS="-R -F -X"
if excutable less && excutable source-highlight-esc.sh; then
  export LESSOPEN="| source-highlight-esc.sh %s"
fi

# colordiff
if excutable colordiff; then
  alias diff="colordiff"
fi

# ansible
if excutable ansible; then
  export ANSIBLE_NOCOWS=1
fi

# nproc
if ! excutable nproc && excutable sysctl; then
  alias nproc='sysctl -n hw.physicalcpu'
fi

# make
if excutable make; then
  export MAKEFLAGS="-j$(nproc)"
fi

# oh-my-zsh
export DISABLE_AUTO_TITLE=true

# select-history and select-path
#
# fzf
if excutable fzf-tmux ]]; then
  # historical search with peco binded to ^r
  function select-history-fzf() {
    # historyを番号なし、逆順、最初から表示。
    # 順番を保持して重複を削除。
    # カーソルの左側の文字列をクエリにしてpecoを起動
    # \nを改行に変換
    BUFFER="$(\history -nr 1 | awk '!a[$0]++' | fzf-tmux --query "$LBUFFER" --prompt 'HISTORY>' | sed 's/\\n/\n/')"
    # カーソルを文末に移動
    CURSOR=$#BUFFER
    # refresh
    zle -R -c
  }
  zle -N select-history-fzf
  bindkey '^r' select-history-fzf

  # path selection with peco binded to ^f
  function select-path-fzf() {
    local filepath="$(find . | grep -v '/\.' | fzf-tmux --prompt 'PATH>')"
    [ -z "$filepath" ] && return
    if [ -n "$LBUFFER" ]; then
      BUFFER="$LBUFFER$filepath"
    else
      if [ -d "$filepath" ]; then
        BUFFER="cd $filepath"
      elif [ -f "$filepath" ]; then
        BUFFER="$EDITOR $filepath"
      fi
    fi
    CURSOR=$#BUFFER
  }

  zle -N select-path-fzf
  # Ctrl+f で起動
  bindkey '^f' select-path-fzf
#
# peco
elif excutable peco; then
  # historical search with peco binded to ^r
  function select-history-peco() {
    # historyを番号なし、逆順、最初から表示。
    # 順番を保持して重複を削除。
    # カーソルの左側の文字列をクエリにしてpecoを起動
    # \nを改行に変換
    BUFFER="$(\history -nr 1 | awk '!a[$0]++' | peco --query "$LBUFFER" | sed 's/\\n/\n/')"
    # カーソルを文末に移動
    CURSOR=$#BUFFER
    # refresh
    zle -R -c
  }
  zle -N select-history-peco
  # Ctrl+f
  bindkey '^r' select-history-peco

  # path selection with peco binded to ^f
  function select-path-peco() {
    local filepath="$(find . | grep -v '/\.' | peco --prompt 'PATH>')"
    [ -z "$filepath" ] && return
    if [ -n "$LBUFFER" ]; then
      BUFFER="$LBUFFER$filepath"
    else
      if [ -d "$filepath" ]; then
        BUFFER="cd $filepath"
      elif [ -f "$filepath" ]; then
        BUFFER="$EDITOR $filepath"
      fi
    fi
    CURSOR=$#BUFFER
  }
  zle -N select-path-peco
  # Ctrl+f
  bindkey '^f' select-path-peco
fi

# gg
#
# fzf
if excutable ghq && excutable fzf-tmux; then
  alias gg='cd $(ghq list -p | fzf-tmux)'
# peco
elif excutable ghq && excutable peco; then
  alias gg='cd $(ghq list -p | peco)'
fi

# historica backward/forward search with linehead string binded to ^p/^n
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end

# update compinit
autoload -U compinit
compinit

# include .zshrc.local
[[ -f ${HOME}/.zshrc.local ]] && source ${HOME}/.zshrc.local
