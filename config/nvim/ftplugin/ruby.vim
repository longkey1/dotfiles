" tab indent
setlocal expandtab           " tabをスペースに置き換える
setlocal tabstop=2           " tabをスペース何文字分で表示するかの指定
setlocal shiftwidth=2        " オートインデント時に挿入されるスペース文字数
setlocal softtabstop=2       " tabキーで挿入されるスペース文字数

" local
if filereadable(expand('$HOME/.config/nvim/ftdetect/ruby.vim.local'))
  source $HOME/.config/nvim/ftdetect/ruby.vim.local
endif
