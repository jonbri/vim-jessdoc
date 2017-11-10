" jsdoc.vim - JSDoc shortcuts

if exists("g:loaded_jsdoc") || &cp || v:version < 700
  finish
endif
let g:loaded_jsdoc = 1

function! ExecuteFoo()
  silent! s/.*/Foo/
endfunction
