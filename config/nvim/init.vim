" ======================================================= plug ===
if has('vim_starting')
  if !isdirectory(expand('~/.local/share/nvim/site/plugged/vim-plug'))
    echo 'install vim-plug...'
    call system('mkdir -p ~/.local/share/nvim/site/plugged/vim-plug')
    call system('git clone https://github.com/junegunn/vim-plug.git ~/.local/share/nvim/site/plugged/vim-plug')
    call system('mkdir -p ~/.local/share/nvim/site/autoload')
    call system('ln -s ~/.local/share/nvim/site/plugged/vim-plug/plug.vim ~/.local/share/nvim/site/autoload/')
  end
endif
call plug#begin('~/.local/share/nvim/site/plugged')
Plug 'junegunn/vim-plug'
Plug 'nanotech/jellybeans.vim'
Plug 'thinca/vim-quickrun'
Plug 'cocopon/vaffle.vim'
call plug#end()
" ======================================================= plug ===

" ======================================================= plugin =====
" jellybeans =====
if isdirectory(expand('~/.local/share/nvim/site/plugged/jellybeans.vim'))
  colorscheme jellybeans
endif
" ======================================================= plugin =====

" ======================================================= general =====
set number                                                " 行番号表示

" 行末までyank
nnoremap Y y$

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
if filereadable(expand('$HOME/.config/nvim/init.vim.local'))
  source $HOME/.config/nvim/init.vim.local
endif
" ======================================================= general =====
