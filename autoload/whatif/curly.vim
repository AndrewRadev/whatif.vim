function! whatif#curly#Run(bang, start_line, end_line) abort
  if !exists('b:whatif_command')
    echoerr "No b:whatif_command set for this filetype: " . &ft
    return
  endif

  let command = b:whatif_command

  if a:bang == '!'
    call whatif#Undo(command)
    return
  endif

  let debug_index = 1
  let lineno = a:start_line

  while lineno <= a:end_line
    let line = trim(getline(lineno))
    if line !~ '^\%(}\s*\)\=\%(else \)\=if ' && line !~ '^\%(}\s*\)\=else\%(\s*{\)\=$'
      let lineno = nextnonblank(lineno + 1)
      continue
    endif

    " clean out surrounding } {
    let line = substitute(line, '^}\s*\(.*\)', '\1', '')
    let line = substitute(line, '\(.\{-}\)\s*{$', '\1', '')

    let line_description = whatif#utils#FormatLine(line)
    let next_lineno = nextnonblank(lineno + 1)

    while getline(lineno) !~ '{\s*$'
      let lineno = next_lineno
      let next_lineno = nextnonblank(lineno + 1)
    endwhile

    call append(lineno, printf(command, "\"WhatIf " . debug_index . ': ' . line_description . '"'))
    let lineno += 1
    let saved_view = winsaveview()
    exe lineno
    normal! ==
    call winrestview(saved_view)
    let debug_index += 1
    let lineno += 1
  endwhile
endfunction
