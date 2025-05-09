" clear trim_trailing_blank_space
autocmd! trim_trailing_blank_space

" abbreviations
augroup abbreviations_md_ts
  autocmd FileType markdown iabbrev <buffer> :ts: <C-R>=strftime("%Y-%m-%d %H:%M")<CR>
augroup END
