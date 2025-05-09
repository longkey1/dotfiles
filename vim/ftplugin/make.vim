" tab indent
setlocal noexpandtab         " tabをスペースに置き換えない
setlocal tabstop=2           " tabをスペース何文字分で表示するかの指定
setlocal shiftwidth=2        " オートインデント時に挿入されるスペース文字数
setlocal softtabstop=2       " tabキーで挿入されるスペース文字数

" retab
augroup force_retab
  autocmd!
  autocmd BufWritePre justfile execute 'retab!'
augroup END
