function! whatif#rust#Run(bang, start_line, end_line) abort
  let command = get(b:, 'whatif_command', 'println!(%s);')

  if a:bang == '!'
    call whatif#Undo(command, a:start_line, a:end_line)
    return
  endif

  let printer = whatif#printer#New(command, a:start_line, a:end_line)

  while !printer.Finished()
    let if_line = printer.GetCurrentLine()

    if if_line =~ '^\%(}\s*\)\=\%(else \)\=if '
          \ || if_line =~ '^\%(}\s*\)\=else\%(\s*{\)\=$'
          \ || if_line =~ '\s\+=>\s\+{$'
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
