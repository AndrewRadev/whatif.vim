function! whatif#vim#Run(bang, start_line, end_line) abort
  let command = get(b:, 'whatif_command', 'echomsg %s')

  if a:bang == '!'
    call whatif#Undo(command)
    return
  endif

  let printer = whatif#printer#New(command, a:start_line)

  while printer.lineno <= a:end_line
    let if_line = trim(getline(printer.lineno))
    if if_line !~ '^\%(else\)\=if ' && if_line !~ '^else$'
      call printer.NextLineno()
      continue
    endif

    let next_lineno = nextnonblank(printer.lineno + 1)

    while getline(next_lineno) =~ '^\s*\\'
      " next line is a continuation, move downwards
      call printer.NextLineno()
      let next_lineno = nextnonblank(printer.lineno + 1)
    endwhile

    call printer.Print(if_line)
  endwhile
endfunction
