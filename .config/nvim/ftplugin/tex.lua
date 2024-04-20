-- Configuration for Latex in Neovim
--
-- My config
-- ,c   Starts the compilation of the document continuously
-- ,v   Shows the current line in the preview
-- ,f   Hides the quick fix menu (:cclose)
--
-- Note that using "Skim.app" is specified in init.lua

vim.keymap.set('n', '<localleader>f', ':cclose<CR>', {desc = 'Hide the quick fix list'})


vim.cmd [[
    let g:vimtex_compiler_latexmk_engines = {
        \ '_'           : '-pdf',
        \ 'pdf_escaped' : '-pdf -pdflatex="pdflatex -shell-escape %O %S"'
    \}

	let g:vimtex_quickfix_open_on_warning = 0  
	nmap <localleader>v <plug>(vimtex-view)
	nmap <localleader>c <plug>(vimtex-compile)

	" Bring back focus to Neovim when the time is right
	" https://ejmastnak.github.io/tutorials/vim-latex/pdf-reader.html#returning-focus-to-neovim-after-inverse-search-on-macos
	function! s:TexFocusVim() abort
	  silent execute "!open -a iTerm"
	  redraw!
	endfunction

	augroup vimtex_event_focus
	  au!
	  au User VimtexEventViewReverse call s:TexFocusVim()
	augroup END
]]

