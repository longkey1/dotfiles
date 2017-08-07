" tab indent
setlocal expandtab           " tabをスペースに置き換える
setlocal tabstop=4           " tabをスペース何文字分で表示するかの指定
setlocal shiftwidth=4        " オートインデント時に挿入されるスペース文字数
setlocal softtabstop=4       " tabキーで挿入されるスペース文字数

" local
if filereadable(expand('$HOME/.config/nvim/ftdetect/php.vim.local'))
  source $HOME/.config/nvim/ftdetect/php.vim.local
endif
