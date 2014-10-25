let s:highlight_args = ["ctermfg", "ctermbg", "guifg", "guibg"]
let s:need_to_init = 1

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
  return {
  \ 'ctermfg': get(a:hi_dict, 'ctermbg', 'NONE'),
  \ 'ctermbg': get(a:hi_dict, 'ctermfg', 'NONE'),
  \ 'guifg': get(a:hi_dict, 'guibg', 'NONE'),
  \ 'guibg': get(a:hi_dict, 'guifg', 'NONE')
  \ }
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

function! insert_linenr#to_insert_line_nr()
  if s:need_to_init ==# 1
    let base_highlight = extend({'ctermfg': 'NONE', 'ctermbg': 'NONE', 'guifg': 'NONE', 'guibg': 'NONE'}, s:get_highlight('Normal'))
    let s:normal_linenr = extend(copy(base_highlight), s:get_highlight('LineNr'))
    let s:normal_cursorlinenr = extend(copy(base_highlight), s:get_highlight('CursorLineNr'))
    let s:insert_linenr = s:invert_fg_bg(s:normal_linenr)
    let s:insert_cursorlinenr = s:invert_fg_bg(s:normal_cursorlinenr)
    let s:need_to_init = 0
  endif
  silent exec 'highlight LineNr ' . s:highlight_dict_to_string(s:insert_linenr)
  silent exec 'highlight CursorLineNr ' . s:highlight_dict_to_string(s:insert_cursorlinenr)
endfunction

function! insert_linenr#to_normal_line_nr()
  if exists("s:normal_linenr") && exists("s:normal_cursorlinenr")
    silent exec 'highlight LineNr ' . s:highlight_dict_to_string(s:normal_linenr)
    silent exec 'highlight CursorLineNr ' . s:highlight_dict_to_string(s:normal_cursorlinenr)
  endif
endfunction

function! insert_linenr#reset()
  let s:need_to_init = 1
endfunction
