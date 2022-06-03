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

  let printer = whatif#printer#New(command, a:start_line, a:end_line)

  while !printer.Finished()
    let if_line = printer.GetCurrentLine()

    if if_line =~ '^\%(}\s*\)\=\%(else \)\=if ' || if_line =~ '^\%(}\s*\)\=else\%(\s*{\)\=$'
      " clean out surrounding } {
      let if_line = substitute(if_line, '^}\s*\(.*\)', '\1', '')
      let if_line = substitute(if_line, '\(.\{-}\)\s*{$', '\1', '')

      while getline(printer.current_lineno) !~ '{\s*$'
        call printer.NextLineno()
      endwhile

      call printer.Print(if_line)
    else
      call printer.NextLineno()
    endif
  endwhile
endfunction
