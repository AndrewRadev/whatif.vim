" Horrible regex taken from vim-ruby
let s:continuation_pattern =
      \ '\%(%\@<![({[\\.,:*/%+]\|\<and\|\<or\|\%(<%\)\@<![=-]\|:\@<![^[:alnum:]:][|&?]\|||\|&&\)\s*\%(#.*\)\=$'

function! whatif#ruby#Run(bang, start_line, end_line) abort
  let command = get(b:, 'whatif_command', 'puts %s')

  if a:bang == '!'
    call whatif#Undo(command)
    return
  endif

  let debug_index = 1
  let lineno = a:start_line

  while lineno <= a:end_line
    let line = trim(getline(lineno))
    if line !~ '^\%(els\)\=if ' && line !~ '^else$'
      let lineno = nextnonblank(lineno + 1)
      continue
    endif

    let line_description = whatif#utils#FormatLine(line)
    let next_lineno = nextnonblank(lineno + 1)

    while getline(lineno) =~ s:continuation_pattern
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
