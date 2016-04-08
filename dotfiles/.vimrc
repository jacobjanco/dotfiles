"pathogen setup
execute pathogen#infect()

" set file refresh
set autoread

"line numbers
set nu

"colorscheme settings
set t_Co=256
colorscheme badwolf

"filetypes and syntax
syntax on
filetype plugin indent on
augroup filetype
    au! BufRead,BufNewFile *.proto set filetype=proto
    au! BufNewFile,BufReadPost *.md set filetype=markdown
augroup end

set autoindent

"vim-markdown settings
let g:vim_markdown_folding_disabled=1

"vim-instant-markdown settings
let g:instant_markdown_autostart=0


"strip trailing whitespace keep cursor
fun! <SID>StripTrailingWhitespaces()
    if &ft =~ 'markdown'
        return
    endif
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

"make explore look like nerdtree
let g:netrw_liststyle=3

"highlight over 80 characters
highlight limit_80c ctermbg=darkred ctermfg=white
fun! <SID>limit_80c_ft()
    if &ft !~ 'markdown\|txt\|text\|html\|java'
        match limit_80c /\%81v.\+/
    endif
endfun
autocmd BufEnter,BufWinEnter * :call <SID>limit_80c_ft()

"remappings
let mapleader = ','
nnoremap <leader><space> za

"remap ctrl-d/u to leader
nnoremap <leader>d <C-d>
nnoremap <leader>u <C-u>

"remap esc key
inoremap jk <esc>

"move line up/down
nnoremap <leader>- ddp
nnoremap <leader>_ ddkkp

"open, source vimrc in split to edit
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

"toggle paste mode, normal
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

"goto left, goto right
nnoremap H ^
nnoremap L $

"statusline tweaks
set laststatus=2
set statusline=%=[%t][%l/%L]
highlight statusline ctermfg=121 ctermbg=233 cterm=NONE
