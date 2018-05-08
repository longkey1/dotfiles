# include .zshrc.zgen
[[ -f $HOME/.zshrc.zgen ]] && source $HOME/.zshrc.zgen

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

# path
export PATH="$HOME/.bin:$PATH"

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

# ruby & gem
if excutable ruby && excutable gem; then
  export PATH="$(ruby -e 'puts Gem.user_dir')/bin:$PATH"
fi

# go
if excutable go && [[ -d "$HOME/work" ]]; then
  export GOPATH="$HOME/work"
  export PATH=$GOPATH/bin:$PATH
fi

# ffmpeg
if [[ -d /opt/ffmpeg ]]; then
  export PATH=/opt/ffmpeg:$PATH
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

# ansible
if excutable ansible; then
  export ANSIBLE_NOCOWS=1
fi

# fzf
if excutable fzf-tmux ]]; then
  # historical search with peco binded to ^r
  function fzf-select-history() {
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
  zle -N fzf-select-history
  bindkey '^r' fzf-select-history

  # path selection with peco binded to ^f
  function fzf-select-path() {
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

  zle -N fzf-select-path
  # Ctrl+f で起動
  bindkey '^f' fzf-select-path

# peco
elif excutable peco; then
  # historical search with peco binded to ^r
  function peco-select-history() {
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
  zle -N peco-select-history
  bindkey '^r' peco-select-history

  # path selection with peco binded to ^f
  function peco-select-path() {
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

  zle -N peco-select-path
  # Ctrl+f で起動
  bindkey '^f' peco-select-path
fi

# gg
if excutable ghq && excutable fzf && excutable fzf-tmux; then
  alias gg='cd $(ghq root)/$(ghq list -p | fzf-tmux)'
elif excutable ghq && excutable peco; then
  alias gg='cd $(ghq root)/$(ghq list | peco)'
fi

# historica backward/forward search with linehead string binded to ^p/^n
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end

# include .zshrc.local
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
