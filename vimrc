" ======================================================= plugin =====
" colorscheme
if isdirectory(expand('~/.vim/pack/bundle/start/jellybeans.vim'))
  colorscheme jellybeans
endif

" netrw
let g:netrw_liststyle = 3


" ======================================================= general =====
syntax on " シンタックス
filetype plugin on " ファイルタイププラグイン

set autoindent " オートインデント
set number " 行番号表示

" クリップボード共有
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
" fcitx
if executable('fcitx-remote')
  augroup AutoFcitxOff
    autocmd!
    autocmd InsertLeave * call system('fcitx-remote -c')
  augroup END
endif
" ibus
if executable('ibus')
  augroup AutoIBusOff
    autocmd!
    autocmd InsertLeave * call system('ibus engine "xkb:us::eng"')
  augroup END
endif

" local
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif
