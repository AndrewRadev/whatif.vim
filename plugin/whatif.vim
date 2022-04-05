if exists('g:loaded_whatif') || &cp
  finish
endif

let g:loaded_whatif = '0.0.1' " version number
let s:keepcpo = &cpo
set cpo&vim

packadd matchit

command! -nargs=* -bang WhatIf call s:WhatIf('<bang>')
function! s:WhatIf(bang)
  let filetypes = split(&filetype, '\.')

  if index(filetypes, 'ruby') >= 0
    call whatif#ruby#Run(a:bang)
  elseif index(filetypes, 'vim') >= 0
    call whatif#vim#Run(a:bang)
  else
    call whatif#curly#Run(a:bang)
  endif
endfunction

let &cpo = s:keepcpo
unlet s:keepcpo
