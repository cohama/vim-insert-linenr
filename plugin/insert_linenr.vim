augroup InsertLineNr
  autocmd!
  autocmd InsertEnter * call insert_linenr#to_insert_line_nr()
  autocmd InsertLeave * call insert_linenr#to_normal_line_nr()
augroup END

