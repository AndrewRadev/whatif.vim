function! whatif#ruby#Run(bang)
  let command = get(b:, 'whatif_command', 'puts %s')

  if a:bang == '!'
    call whatif#Undo(command)
    return
  endif

  if search('^\s*\zsif ', 'Wbc') <= 0
    return
  endif

  let debug_index = 1

  while getline('.') !~ '^\s*end\>'
    let if_lineno = line('.')
    let if_line = trim(getline('.'))

    while indent(line('.') + 1) > indent(if_lineno) + shiftwidth()
          \ && getline(line('.') + 1) !~ '^\s*\%(else\|elsif\)\>'
      " it's probably a continuation, move downwards
      normal! j
    endwhile

    let line_description = whatif#utils#FormatLine(if_line)
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
