" tab indent
setlocal noexpandtab         " tabをスペースに置き換えない
setlocal tabstop=4           " tabをスペース何文字分で表示するかの指定
setlocal shiftwidth=4        " オートインデント時に挿入されるスペース文字数
setlocal softtabstop=4       " tabキーで挿入されるスペース文字数

" local
if filereadable(expand('$HOME/.vim/after/ftplugin/go.vim.local'))
  source $HOME/.vim/after/ftplugin/ruby.vim.local
endif
