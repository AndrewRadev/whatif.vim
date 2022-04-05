function! whatif#Undo(command)
  let command_pattern = printf(a:command, '"WhatIf \d\+.*')
  keeppatterns exe 'g/^\s*' . command_pattern . '/d'
endfunction
