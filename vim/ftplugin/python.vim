setlocal tabstop=4
setlocal shiftwidth=4
setlocal expandtab
setlocal smarttab
setlocal softtabstop=4

" SNIPPETS
" Add 'DELETEME' comment
nmap <leader>dm mdA # DELETEME<ESC>`d

" Delete all DELETEME lines
nmap <leader>dd :g/DELETEME/d<CR>

" Add log line
nmap <leader>o Oimport logging; logging.getLogger("BLA").error("")<ESC>hi
