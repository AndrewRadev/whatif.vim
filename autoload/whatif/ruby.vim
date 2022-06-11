" Horrible regex taken from vim-ruby
let s:continuation_pattern =
      \ '\%(%\@<![({[\\.,:*/%+]\|\<and\|\<or\|\%(<%\)\@<![=-]\|:\@<![^[:alnum:]:][|&?]\|||\|&&\)\s*\%(#.*\)\=$'

function! whatif#ruby#Run(bang, start_line, end_line) abort
  let command = get(b:, 'whatif_command', 'puts %s')

  if a:bang == '!'
    call whatif#Undo(command, a:start_line, a:end_line)
    return
  endif

  let printer = whatif#printer#New(command, a:start_line, a:end_line)

  while !printer.Finished()
    let if_line = printer.GetCurrentLine()

    if if_line =~ '^\%(els\)\=if '
          \ || if_line =~ '^else$'
          \ || if_line =~ '^return\>.*\<\(if\|unless\)\>'
      while getline(printer.current_lineno) =~ s:continuation_pattern
        call printer.NextLineno()
      endwhile

      call printer.Print(if_line)
    else
      call printer.NextLineno()
    endif
  endwhile
endfunction
