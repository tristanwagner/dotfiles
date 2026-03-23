" declare a macro and put a binding on it
" you can paste a macro by doing "<macro letter>p
" this macro replace require with imports for js

" change require statements into import statements
let @i = '0ceimportf=cf(from f)x'
nnoremap <leader>ri :g/require/normal @i<CR>

" change import statements into require statements
let @r = "0ceconstf'cFf= require(f'f'a)"
nnoremap <leader>rr :g/import/normal @r<CR>

