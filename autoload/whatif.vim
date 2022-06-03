function! whatif#Run(bang, start_line, end_line)
  let filetypes = split(&filetype, '\.')

  for supported_filetype in ['vim', 'ruby', 'python']
    if index(filetypes, supported_filetype) >= 0
      call call('whatif#' . supported_filetype . '#Run', [a:bang, a:start_line, a:end_line])
      return
    endif
  endfor

  call whatif#curly#Run(a:bang, a:start_line, a:end_line)
endfunction

function! whatif#Undo(command)
  let command_pattern = printf(a:command, '["'']Whatif \d\+.*')
  keeppatterns exe 'g/^\s*' . command_pattern . '/d'
endfunction
