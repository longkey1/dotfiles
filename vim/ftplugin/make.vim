" tab indent
setlocal noexpandtab
setlocal tabstop=2
setlocal shiftwidth=2
setlocal softtabstop=2

" retab
augroup force_retab
  autocmd!
  autocmd BufWritePre justfile execute 'retab!'
augroup END
