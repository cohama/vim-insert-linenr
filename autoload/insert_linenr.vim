let s:highlight_args = ["ctermfg", "ctermbg", "guifg", "guibg"]

function! s:get_highlight(highlight_group)
  redir => hl
  silent execute 'highlight ' . a:highlight_group
  redir END
  let hl = substitute(hl, '[\r\n]', '', 'g')
  let hi_dict = {}
  for hi_arg in s:highlight_args
    let args_list = matchlist(hl, hi_arg . '=\(\S\+\)')
    if len(args_list) > 1
      let hi_dict[hi_arg] = args_list[1]
    endif
  endfor
  return hi_dict
endfunction

function! s:invert_fg_bg(hi_dict)
  let inverted = {}
  if has_key(a:hi_dict, "ctermfg") && has_key(a:hi_dict, "ctermbg")
    let inverted.ctermfg = a:hi_dict.ctermbg
    let inverted.ctermbg = a:hi_dict.ctermfg
  endif
  if has_key(a:hi_dict, "guifg") && has_key(a:hi_dict, "guibg")
    let inverted.guifg = a:hi_dict.guibg
    let inverted.guibg = a:hi_dict.guifg
  endif
  return inverted
endfunction

function! s:highlight_dict_to_string(highlight_dict)
  let str = ""
  for hi_arg in s:highlight_args
    if has_key(a:highlight_dict, hi_arg) && a:highlight_dict[hi_arg] != ""
      let str .= hi_arg . "=" . a:highlight_dict[hi_arg] . " "
    endif
  endfor
  return str
endfunction

function! insert_linenr#initialize_default_line_nr()
  silent! let s:normal_normal = s:get_highlight('Normal')
  silent! let s:normal_linenr = extend(copy(s:normal_normal), s:get_highlight('LineNr'))
  silent! let s:normal_cursorlinenr = extend(copy(s:normal_normal), s:get_highlight('CursorLineNr'))
  let s:insert_linenr = s:invert_fg_bg(s:normal_linenr)
  let s:insert_cursorlinenr = s:invert_fg_bg(s:normal_cursorlinenr)
endfunction

function! insert_linenr#to_insert_line_nr()
  if exists("s:insert_linenr") && exists("s:insert_cursorlinenr")
    silent exec 'highlight LineNr ' . s:highlight_dict_to_string(s:insert_linenr)
    silent exec 'highlight CursorLineNr ' . s:highlight_dict_to_string(s:insert_cursorlinenr)
  endif
endfunction

function! insert_linenr#to_normal_line_nr()
  if exists("s:normal_linenr") && exists("s:normal_cursorlinenr")
    silent exec 'highlight LineNr ' . s:highlight_dict_to_string(s:normal_linenr)
    silent exec 'highlight CursorLineNr ' . s:highlight_dict_to_string(s:normal_cursorlinenr)
  endif
endfunction
