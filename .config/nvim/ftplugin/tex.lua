-- Configuration for Latex in Neovim
--
-- My config
-- ,c   Starts the compilation of the document continuously
-- ,v   Shows the current line in the preview
-- The quick fix menu with automatically close after typing some more in the document
-- 
-- Unfortunately, whenever I change the output directory the quickfix window fails to popup. This seems to be since vimtex cannot find the output log file
--

-- Not needed with autoclose set below
--vim.keymap.set('n', '<localleader>f', ':cclose<CR>', {desc = 'Hide the quick fix list'})
vim.keymap.set('n', '<localleader>c', '<Plug>(vimtex-compile)', {desc = 'Start VimTex compliation'})
vim.keymap.set('n', '<localleader>v', '<Plug>(vimtex-view)', {desc = 'View the generated pdf'})

if vim.g.os == 'Darwin' then
    vim.g.vimtex_view_method = "skim"  --Use "Skim.app" instead of "Preview.app" for latex
else
    vim.g.vimtex_view_method = "zathura"  -- on linux
end

vim.g.vimtex_quickfix_mode = 2  -- Open quickfix on errors, but don't become active
vim.g.vimtex_quickfix_autoclose_after_keystrokes = 10  -- close after 10 keystrokes
vim.g.vimtex_quickfix_open_on_warning = 1

-- Set default compilation flags for latex
vim.g.vimtex_compiler_latexmk = {
    options = {
        '-verbose',
        '-file-line-error',
        '-synctex=1',
        '-interaction=nonstopmode',
        '-shell-escape',
     --   '-auxdir=build',
        --'-outdir=output',
    },
}

vim.cmd [[
    let g:vimtex_compiler_latexmk_engines = {
        \ '_'           : '-pdf',
        \ 'pdf_escaped' : '-pdf -pdflatex="pdflatex -shell-escape %O %S"'
    \}

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

