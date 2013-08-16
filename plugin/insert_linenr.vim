augroup InsertLineNr
  autocmd!
  autocmd VimEnter,ColorScheme * call insert_linenr#initialize_default_line_nr()
  autocmd InsertEnter * call insert_linenr#to_insert_line_nr()
  autocmd InsertLeave * call insert_linenr#to_normal_line_nr()
augroup END

