" diffbuf - diff two buffer
" Version: 0.0.1
" Copyright (C) 2014 deris0126
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}

let s:save_cpo = &cpo
set cpo&vim

" Public API {{{1
function! diffbuf#diffbuf()
  if !exists('s:diffbuf1')
    let s:diffbuf1 = bufnr('%')
  else
    let s:diffbuf2 = bufnr('%')
  endif

  call s:diffbuf()
endfunction

function! diffbuf#clearbuf()
  if exists('s:diffbuf1')
    unlet s:diffbuf1
  endif
  if exists('s:diffbuf2')
    unlet s:diffbuf2
  endif
endfunction

function! diffbuf#echobuf()
  if exists('s:diffbuf1')
    echom 'buffer' s:diffbuf1
  elseif exists('s:diffbuf2')
    echom 'buffer' s:diffbuf2
  else
    echom 'no buffer added'
  endif
endfunction

"}}}

" Private {{{1
function! s:diffbuf()
  if !exists('s:diffbuf1') || !exists('s:diffbuf2')
    return
  endif

  if s:diffbuf1 == s:diffbuf2
    call s:echo_error('buffer' s:diffbuf1 'is already specified')
    let s:diffbuf2 = 0
    return
  endif

  if !bufexists(s:diffbuf1)
    call s:echo_error('buffer' s:diffbuf1 'does not exist')
    unlet s:diffbuf1
    return
  endif

  if !bufexists(s:diffbuf2)
    call s:echo_error('buffer' s:diffbuf2 'does not exist')
    unlet s:diffbuf2
    return
  endif

  try
    tabe
    execute 'buffer' s:diffbuf2
    vnew
    execute 'buffer' s:diffbuf1
    windo diffthis
  finally
    unlet s:diffbuf1
    unlet s:diffbuf2
  endtry
endfunction

function! s:echo_error(msg)
  echohl ErrorMsg
  echomsg a:msg
  echohl None
endfunction

"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" __END__ "{{{1
" vim: foldmethod=marker
