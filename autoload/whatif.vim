function! whatif#Run(bang, start_line, end_line)
  let filetypes = split(&filetype, '\.')

  if index(filetypes, 'ruby') >= 0
    call whatif#ruby#Run(a:bang, a:start_line, a:end_line)
  elseif index(filetypes, 'vim') >= 0
    call whatif#vim#Run(a:bang, a:start_line, a:end_line)
  else
    call whatif#curly#Run(a:bang, a:start_line, a:end_line)
  endif
endfunction

function! whatif#Undo(command)
  let command_pattern = printf(a:command, '"WhatIf \d\+.*')
  keeppatterns exe 'g/^\s*' . command_pattern . '/d'
endfunction
