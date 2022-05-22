if exists('g:loaded_whatif') || &cp
  finish
endif

let g:loaded_whatif = '0.0.1' " version number
let s:keepcpo = &cpo
set cpo&vim

packadd matchit

augroup WhatifDefaults
  autocmd!
  autocmd FileType javascript if !exists('b:whatif_command') | let b:whatif_command = 'console.log(%s)' | endif
augroup END

if !exists('g:whatif_truncate')
  let g:whatif_truncate = 20
endif

command! -nargs=* -bang -range=% Whatif call whatif#Run('<bang>', <line1>, <line2>)

let &cpo = s:keepcpo
unlet s:keepcpo
