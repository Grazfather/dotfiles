" SNIPPETS
" Add 'DELETEME' comment
nmap <leader>dm mxA // DELETEME<ESC>`x

" Delete all DELETEME lines
nmap <leader>dd :keepp :g/DELETEME/d<CR><C-o>

nmap <leader>gi :GoImports<CR>
