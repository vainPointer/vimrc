" ************************************************
"  0.Content
" ************************************************ 
"  1.Vundle Setups
"  2.Display Options
"  3.Convenient Settings
"  4.Keyboard Shortcuts
"  6.Compile Functions
"  7.Auto Templates

" ************************************************
"  1.Vundle Setups
" ************************************************ 
" $ git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/vundle.vim
" :PluginInstall
set nocompatible			" bevim
filetype off				" required
set rtp+=~/.vim/bundle/vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

" My Plugins
" plugin on GitHub repo
Plugin 'fatih/vim-go'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-markdown'
Plugin 'jiangmiao/auto-pairs'
Plugin 'djoshea/vim-matlab'
Plugin 'djoshea/vim-matlab-fold'
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'

" plugin from vim-scripts
Plugin 'molokai'

call vundle#end()
filetype plugin indent on	" required

" ------------------------------------------------
"  2.Display Options
" ------------------------------------------------
colorscheme molokai			" scheme
syntax on					" highight
set number					" numbers
set statusline=%f%m%r\ [ACSII=%b,0x%B]\ [POS=%l,%v]%=\(%p%%\)
set laststatus=2			" statusline
set cursorline				" highlightline
set hlsearch				" highlightsearch
set scrolloff=3		        
set showcmd					" showcommand
set nowrap

" ------------------------------------------------
"  3.Convenient Settings
" ------------------------------------------------
set autoindent				" tabindent
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
set foldenable				" foldcode
set foldmethod=manual
set autoread				" autoreadchange
set mouse=a					" mouseenable
set wildmenu
set wildmode=full

" ------------------------------------------------
"  4.Keyboard Shortcuts
" ------------------------------------------------
vmap <C-C> :w !pbcopy<CR><CR>
map <C-H> :%!xxd<CR>
map <C-J> :%!xxd -r<CR>
map <F5> :call CompileCode()<CR>
map <F6> :call RunResult()<CR>
map <F7> :call UseTestData()<CR>
map <F12> :w<CR>:make<CR>

" ------------------------------------------------
"  6.Compile Functions
" ------------------------------------------------
func! CompileGcc()
    if &filetype == "c"
        let compilecmd = "!gcc "
    elseif &filetype == "cpp"
        let compilecmd = "!g++ "
    endif
	let compileflag = "-o %< -I/usr/local/include -L/usr/local/lib "
	if search("math\.h") != 0
		let compileflag .= " -lm "
	endif
	if search("gmp\.h") != 0
		let compileflag .= " -lgmp "
	endif
	exec compilecmd." % ".compileflag
endfunc

func! CompileLex()
	let compilecmd = "!flex "
	let compileflag = ""
	exec compilecmd." % ".compileflag
	exec "!cc -o %< lex.yy.c -ll"
endfunc

func! CompileCode()
	exec "w"
	if &filetype == "c" || &filetype == "cpp"
		exec "call CompileGcc()"
	elseif &filetype == "lex"
		exec "call CompileLex()"
	elseif &filetype == "python"
		exec "!python %"
	endif
endfunc

func! RunResult()
	if &filetype == "c" || &filetype == "cpp"
		exec "! ./%<"
	elseif &filetype == "lex"
		exec "! ./%<"
	elseif &filetype == "python"
		exec "!python %"
	endif
endfunc

func! UseTestData()
    if &filetype == "c" || &filetype == "cpp"
        exec "! ./%< < test.txt"
    endif
endfunc

" ------------------------------------------------
"   7.Auto Templates
" ------------------------------------------------
autocmd BufNewFile *.c call SetCTitle()
autocmd BufNewFile *.cpp call SetCppTitle()
autocmd BufNewFile *.h call SetHTitle()
autocmd BufNewFile *.sh call SetShTitle()
autocmd BufNewFile *.py call SetPyTitle()

func SetCTitle()
    call setline(1, "#include <stdio.h>")
    call append(line("."), "#include <stdlib.h>")
endfunc
func SetCppTitle()
    call setline(1, "#include <iostream>")
    call append(line("."), "using namespace std;")
endfunc
func SetHTitle()
    call setline(1, "#ifndef _".toupper(expand("%:t:r"))."_H_")
    call append(line("."), "#define _".toupper(expand("%:t:r"))."_H_")
    call append(line(".")+1, "")
    call append(line(".")+2, "#endif /* _".toupper(expand("%:t:r"))."_H_ */")
endfunc
func SetShTitle()
    call setline(1, "\#!/bin/bash")
endfunc
func SetPyTitle()
    call setline(1, "\#!/usr/bin/env python")
endfunc

