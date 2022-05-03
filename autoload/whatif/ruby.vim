" Horrible regex taken from vim-ruby
let s:continuation_pattern =
      \ '\%(%\@<![({[\\.,:*/%+]\|\<and\|\<or\|\%(<%\)\@<![=-]\|:\@<![^[:alnum:]:][|&?]\|||\|&&\)\s*\%(#.*\)\=$'

function! whatif#ruby#Run(bang, start_line, end_line) abort
  let command = get(b:, 'whatif_command', 'puts %s')

  if a:bang == '!'
    call whatif#Undo(command)
    return
  endif

  let printer = whatif#printer#New(command, a:start_line)

  while printer.lineno <= a:end_line
    let if_line = trim(getline(printer.lineno))
    if if_line !~ '^\%(els\)\=if ' && if_line !~ '^else$'
      call printer.NextLineno()
      continue
    endif

    while getline(printer.lineno) =~ s:continuation_pattern
      call printer.NextLineno()
    endwhile

    call printer.Print(if_line)
  endwhile
endfunction
