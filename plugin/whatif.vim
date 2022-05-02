if exists('g:loaded_whatif') || &cp
  finish
endif

let g:loaded_whatif = '0.0.1' " version number
let s:keepcpo = &cpo
set cpo&vim

packadd matchit

augroup WhatIfDefaults
  autocmd!
  autocmd FileType javascript if !exists('b:whatif_command') | let b:whatif_command = 'console.log(%s)' | endif
augroup END

command! -nargs=* -bang WhatIf call whatif#Run('<bang>')

let &cpo = s:keepcpo
unlet s:keepcpo
