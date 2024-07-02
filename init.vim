" Specify a directory for plugins
call plug#begin('~/.config/nvim/pack')

" Python syntax highlighting plugin
Plug 'sheerun/vim-polyglot'
" GitHub Copilot plugin
Plug 'github/copilot.vim'
" coc.nvim plugin for LSP support
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Initialize plugin system
call plug#end()

" Enable syntax highlighting
syntax on

" File type detection
filetype plugin indent on

" Set colorscheme
colorscheme industry

" Set folding options
set foldmethod=syntax
set foldlevel=99

" Set number lines
set number

" Set system clipboard
set clipboard=unnamedplus

" Python-specific folding
augroup python
  autocmd!
  autocmd FileType python setlocal foldmethod=indent
augroup END

" Configure coc.nvim for Python
" Use :CocInstall coc-pyright to install the Python language server
autocmd FileType python setlocal omnifunc=v:lua.vim.lsp.omnifunc

" Set up coc.nvim for Python development
let g:coc_global_extensions = ['coc-pyright']

" Additional coc.nvim configuration can go here
