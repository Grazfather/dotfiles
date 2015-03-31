setlocal tabstop=4
setlocal shiftwidth=4
setlocal expandtab
setlocal smarttab
setlocal softtabstop=4

" SNIPPETS
" Add 'DELETEME' comment
nmap <leader>dm mxA # DELETEME<ESC>`x

" Delete all DELETEME lines
nmap <leader>dd :let @x=@/<CR>:g/DELETEME/d<CR>:let @/=@x<CR><C-o>

" Add log line
nmap <leader>o Oimport logging; logging.getLogger("BLA").error("")<ESC>hi
