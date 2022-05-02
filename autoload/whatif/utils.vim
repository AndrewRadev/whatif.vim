function! whatif#utils#FormatLine(line)
  let line = a:line
  let limit = g:whatif_truncate

  if limit <= 0 || len(line) <= limit + len("...")
    let line_description = line
  else
    let line_description = strpart(line, 0, limit)."..."
  endif

  return escape(line_description, '"')
endfunction
