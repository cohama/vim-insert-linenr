let s:save_cpo = &cpo
set cpo&vim

augroup InsertLineNr
  autocmd!
  autocmd InsertEnter * call insert_linenr#to_insert_line_nr()
  autocmd InsertLeave * call insert_linenr#to_normal_line_nr()
  autocmd ColorScheme * call insert_linenr#reset()
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
