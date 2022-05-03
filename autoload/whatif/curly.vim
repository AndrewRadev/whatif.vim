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

  let printer = whatif#printer#New(command, a:start_line)

  while printer.lineno <= a:end_line
    let if_line = trim(getline(printer.lineno))
    if if_line !~ '^\%(}\s*\)\=\%(else \)\=if ' && if_line !~ '^\%(}\s*\)\=else\%(\s*{\)\=$'
      call printer.NextLineno()
      continue
    endif

    " clean out surrounding } {
    let if_line = substitute(if_line, '^}\s*\(.*\)', '\1', '')
    let if_line = substitute(if_line, '\(.\{-}\)\s*{$', '\1', '')

    while getline(printer.lineno) !~ '{\s*$'
      call printer.NextLineno()
    endwhile

    call printer.Print(if_line)
  endwhile
endfunction
