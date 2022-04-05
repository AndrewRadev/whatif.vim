function! whatif#vim#Run(bang)
  let command = get(b:, 'whatif_command', 'echomsg %s')

  if a:bang == '!'
    call whatif#Undo(command)
    return
  endif

  if search('^\s*\zsif ', 'Wbc') <= 0
    return
  endif

  let debug_index = 1

  while getline('.') !~ '^\s*endif\>'
    let if_lineno = line('.')
    let if_line = trim(getline('.'))

    while getline(line('.') + 1) =~ '^\s*\\'
      " it's a continuation, move downwards
      normal! j
    endwhile

    if len(if_line) <= 23
      let line_description = if_line
    else
      let line_description = strpart(if_line, 0, 20)."..."
    endif
    let line_description = escape(line_description, '"')

    call append(line('.'), printf(command, "\"WhatIf " . debug_index . ': ' . line_description . '"'))
    normal! j==
    let debug_index += 1

    exe if_lineno
    normal %
    if if_lineno == line('.')
      " then we haven't moved, bail out
      break
    endif
  endwhile
endfunction
