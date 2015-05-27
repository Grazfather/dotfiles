setlocal tabstop=4
setlocal shiftwidth=4
setlocal expandtab
setlocal smarttab
setlocal softtabstop=4

" SNIPPETS
" Add 'DELETEME' comment
nmap <leader>dm mxA # DELETEME<ESC>`x

" Delete all DELETEME lines
nmap <leader>dd :keepp :g/DELETEME/d<CR><C-o>

" Add log line
nmap <leader>o Oimport logging; logging.getLogger("DELETEME").error("")<ESC>hi

" Add breakpoint
nmap <leader>db Oimport pdb; pdb.set_trace()<ESC>
