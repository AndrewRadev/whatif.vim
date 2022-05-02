function! whatif#Run(bang)
  let filetypes = split(&filetype, '\.')

  if index(filetypes, 'ruby') >= 0
    call whatif#ruby#Run(a:bang)
  elseif index(filetypes, 'vim') >= 0
    call whatif#vim#Run(a:bang)
  else
    call whatif#curly#Run(a:bang)
  endif
endfunction

function! whatif#Undo(command)
  let command_pattern = printf(a:command, '"WhatIf \d\+.*')
  keeppatterns exe 'g/^\s*' . command_pattern . '/d'
endfunction
