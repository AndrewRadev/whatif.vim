function whatif#printer#New(command, start_line) abort
  return {
        \ 'index':   1,
        \ 'command': a:command,
        \ 'lineno':  a:start_line,
        \
        \ 'NextLineno': function('whatif#printer#NextLineno'),
        \ 'Print':      function('whatif#printer#Print'),
        \ }
endfunction

function whatif#printer#NextLineno() dict abort
  let self.lineno = nextnonblank(self.lineno + 1)
endfunction

function whatif#printer#Print(line) dict abort
  let line_description = s:FormatLine(a:line)
  let output = printf(self.command, "\"WhatIf " . self.index . ': ' . line_description . '"')

  call append(self.lineno, output)
  let self.lineno += 1
  let saved_view = winsaveview()
  exe self.lineno
  normal! ==
  call winrestview(saved_view)
  let self.index += 1
  let self.lineno += 1
endfunction

function! s:FormatLine(line) abort
  let line = a:line
  let limit = g:whatif_truncate

  if limit <= 0 || len(line) <= limit + len("...")
    let line_description = line
  else
    let line_description = strpart(line, 0, limit)."..."
  endif

  return escape(line_description, '"')
endfunction
