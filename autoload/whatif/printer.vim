function whatif#printer#New(command, start_lineno, end_lineno) abort
  return {
        \ 'index':          1,
        \ 'command':        a:command,
        \ 'current_lineno': a:start_lineno,
        \ 'end_lineno':     a:end_lineno,
        \
        \ 'Finished':      function('whatif#printer#Finished'),
        \ 'NextLineno': function('whatif#printer#NextLineno'),
        \ 'Print':      function('whatif#printer#Print'),
        \ }
endfunction

function! whatif#printer#Finished() dict abort
  return self.current_lineno >= self.end_lineno
endfunction

function whatif#printer#NextLineno() dict abort
  let self.current_lineno = nextnonblank(self.current_lineno + 1)
endfunction

function whatif#printer#Print(line) dict abort
  let line_description = s:FormatLine(a:line)
  let output = printf(self.command, "\"Whatif " . self.index . ': ' . line_description . '"')

  let command_pattern = printf(self.command, '"Whatif \d\+.*')
  if getline(self.current_lineno + 1) =~ '^\s*' . command_pattern
    " There's already a print statement here, replace it
    call setline(self.current_lineno + 1, output)
  else
    call append(self.current_lineno, output)
    let self.end_lineno += 1
  endif

  let self.current_lineno += 1
  let saved_view = winsaveview()
  exe self.current_lineno
  normal! ==
  call winrestview(saved_view)
  let self.index += 1
  let self.current_lineno += 1
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
