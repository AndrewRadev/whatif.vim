function! whatif#curly#Run(bang)
  if !exists('b:whatif_command')
    echoerr "No b:whatif_command set for this filetype: " . &ft
    return
  endif

  let command = b:whatif_command

  if a:bang == '!'
    call whatif#Undo(command)
    return
  endif

  if search('^\s*\zsif ', 'Wbc') <= 0
    return
  endif

  let debug_index = 1

  while getline('.') !~ '^\s*}\s*$'
    let if_lineno = line('.')
    let if_line = trim(getline('.'))

    " clean out surrounding } {
    let if_line = substitute(if_line, '^}\s*\(.*\)', '\1', '')
    let if_line = substitute(if_line, '\(.\{-}\)\s*{$', '\1', '')

    " while indent(line('.') + 1) > indent(if_lineno) + shiftwidth()
    "       \ && getline(line('.') + 1) !~ '^\s*\%(else\|elsif\)\>'
    "   " it's probably a continuation, move downwards
    "   normal! j
    " endwhile

    let line_description = whatif#utils#FormatLine(if_line)
    call append(line('.'), printf(command, "\"WhatIf " . debug_index . ': ' . line_description . '"'))
    normal! j==
    let debug_index += 1

    exe if_lineno
    if search('{\s*$', 'Wc', line('.')) <= 0
      break
    endif

    normal! %

    if if_lineno >= line('.')
      " then we haven't moved, or we've wrapped around, bail out
      break
    endif
  endwhile
endfunction
