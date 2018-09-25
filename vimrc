" ======================================================= plugin =====
" colorscheme
if isdirectory(expand('~/.vim/pack/bundle/start/jellybeans.vim'))
  colorscheme jellybeans
endif

" ======================================================= general =====
syntax on " シンタックス
filetype plugin on " ファイルタイププラグイン

set autoindent " オートインデント
set number " 行番号表示
set list
set listchars=trail:-

" netrw
let g:netrw_liststyle = 3

" clipboard
if has('mac')
  set clipboard+=unnamed
else
  set clipboard&
  set clipboard^=unnamedplus
endif

" タブインデント
set expandtab      " tabをスペースに置き換えない
set tabstop=2      " tabをスペース何文字分で表示するかの指定
set shiftwidth=2   " オートインデント時に挿入されるスペース文字数
set softtabstop=2  " tabキーで挿入されるスペース文字数

" 保存時に行末の空白を除去するコマンド
command TrimTrailingBlank %s/\s\+$//ge
augroup TrimTrailingBlankSpace
  autocmd!
  autocmd BufWritePre * :TrimTrailingBlank"
augroup END

" 挿入モードから出る時にIMEを自動的にオフにする
set ttimeoutlen=1  "待ち時間を短くする
if has('mac')
  augroup AutoIMEOff
    autocmd!
    autocmd InsertLeave * :call system('osascript -e "tell application \"System Events\" to key code 102"')
  augroup END
elseif executable('fcitx-remote')
  augroup AutoFcitxOff
    autocmd!
    autocmd InsertLeave * call system('fcitx-remote -c')
  augroup END
elseif executable('ibus')
  augroup AutoIBusOff
    autocmd!
    autocmd InsertLeave * call system('ibus engine "xkb:us::eng"')
  augroup END
endif

" local
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif
