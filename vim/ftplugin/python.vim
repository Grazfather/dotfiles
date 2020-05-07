setlocal tabstop=4
setlocal shiftwidth=4
setlocal expandtab
setlocal smarttab
setlocal softtabstop=4

" SNIPPETS
" Add log line
nmap <leader>o Oimport logging; logging.getLogger("DELETEME").error()<ESC>i

" Add breakpoint
nmap <leader>db Oimport pdb; pdb.set_trace()<ESC>
