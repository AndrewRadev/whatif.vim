function! whatif#python#Run(bang, start_line, end_line) abort
  let command = get(b:, 'whatif_command', 'print(%s)')

  if a:bang == '!'
    call whatif#Undo(command)
    return
  endif

  let printer = whatif#printer#New(command, a:start_line, a:end_line)

  while !printer.Finished()
    let if_line = printer.GetCurrentLine()

    if (if_line =~ '^\%(el\)\=if ' && if_line =~ ':$') || if_line =~ '^else:$'
      call printer.Print(substitute(if_line, ':$', '', ''))
    else
      call printer.NextLineno()
    endif
  endwhile
endfunction
