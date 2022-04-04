if exists('g:loaded_whatif') || &cp
  finish
endif

let g:loaded_whatif = '0.0.1' " version number
let s:keepcpo = &cpo
set cpo&vim

packadd matchit


let &cpo = s:keepcpo
unlet s:keepcpo
