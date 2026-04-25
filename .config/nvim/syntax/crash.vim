" Vim syntax file
" Language: crash
" Maintainer: Cowboy8625
" Latest Revision: 19 April 2021

if exists("b:current_syntax")
  finish
endif


" syntax keyword crashKeyword let
" syntax keyword crashKeyword cowboy8625
" syntax keyword crashKeyword return for while fn
syntax keyword crashKeyword if else then
syntax keyword crashKeyword true false
syntax keyword crashKeyword or and

syntax keyword crashFunction print

highlight link crashKeyword Keyword
highlight link crashFunction Function

syn keyword crashTodo contained TODO FIXME XXX NOTE
syn match crashComment "//.*$" contains=crashTodo

" Regular int like number with - + or nothing in front
syn match crashNumber '\d\+' contained display
syn match crashNumber '[-+]\d\+' contained display

" Floating point number with decimal no E or e (+,-)
syn match crashNumber '\d\+\.\d*' contained display
syn match crashNumber '[-+]\d\+\.\d*' contained display

" Floating point like number with E and no decimal point (+,-)
syn match crashNumber '[-+]\=\d[[:digit:]]*[eE][\-+]\=\d\+' contained display
syn match crashNumber '\d[[:digit:]]*[eE][\-+]\=\d\+' contained display

" Floating point like number with E and decimal point (+,-)
syn match crashNumber '[-+]\=\d[[:digit:]]*\.\d*[eE][\-+]\=\d\+' contained display
syn match crashNumber '\d[[:digit:]]*\.\d*[eE][\-+]\=\d\+' contained display

syn region crashString start='"' end='"' contained
syn region crashDesc start='"' end='"'

syn match crashHip '\d\{1,6}' nextgroup=crashString
syn region crashDescBlock start="{" end="}" fold transparent contains=ALLBUT,crashHip,crashString

syn keyword crashBlockCmd RA Dec Distance AbsMag nextgroup=crashNumber
syn keyword crashBlockCmd SpectralType nextgroup=crashDesc

let b:current_syntax = "crash"

hi def link crashTodo        Todo
hi def link crashComment     Comment
hi def link crashBlockCmd    Statement
hi def link crashHip         Type
hi def link crashString      Constant
hi def link crashDesc        PreProc
hi def link crashNumber      Constant
