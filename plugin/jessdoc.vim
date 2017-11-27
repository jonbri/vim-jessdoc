" jsdoc.vim - JSDoc shortcuts

" if exists("g:loaded_jsdoc") || &cp || v:version < 700
"   finish
" endif
" let g:loaded_jsdoc = 1

" 1 => truthy
" 0 => falsy
function! HasJSDocBlock()
  let line = line('.')
  return getline(line - 1) =~ '*'
endfunction

" 1 => truthy
" 0 => falsy
function! HasReturnTag(JSDocBlockStart, JSDocBlockEnd)
  let line = line('.')
  return getline(a:JSDocBlockEnd - 1) =~ 'return'
endfunction

" 1 => truthy
" 0 => falsy
function! HasParamTag(name, JSDocBlockStart, JSDocBlockEnd)
  return len(filter(getbufline(bufnr('%'), a:JSDocBlockStart, a:JSDocBlockEnd), 'v:val =~ "param[ ]*{.*".a:name'))
endfunction

function! AddJSDocBlock(line)
  let line = line('.')
  let l:leadingIndentationCharacters = GetLeadingIndentation(a:line)
  call append(line - 1, [
        \ l:leadingIndentationCharacters.'/**',
        \ l:leadingIndentationCharacters.' *',
        \ l:leadingIndentationCharacters.' */'
      \ ])
endfunction

function! AddParam(name, line, JSDocBlockStart, JSDocBlockEnd)
  let l:leadingIndentationCharacters = GetLeadingIndentation(a:line)
  call append(a:JSDocBlockEnd - 1, l:leadingIndentationCharacters.' * param {TODO} '.a:name.' TODO')
endfunction

" TODO:
" I need a better way to detect if a return tag is needed
" Turn this into a top-level function that can be invoked directly
function! AddReturn(line, JSDocBlockStart, JSDocBlockEnd)
  let l:leadingIndentationCharacters = GetLeadingIndentation(a:line)
  call append(a:JSDocBlockEnd - 1, l:leadingIndentationCharacters.' * return {TODO} TODO')
endfunction

function! GetStartJSDocBlockLineNumber()
  return search('\v^[ \t]*\/\*\*$', 'bn')
endfunction

function! GetEndJSDocBlockLineNumber()
  return search('\v^[ \t]+\*\/$', 'bn')
endfunction

function! GetLeadingIndentation(line)
  " TODO: why can't I use \s in the regexp below?
  return matchlist(getline(a:line), '\v(^[ \t]*)')[0]
endfunction

function! GetParams()
  let params = matchlist(getline('.'), '\v\((.*)\)')[1]
  return map(split(params, ','), 'Trim(v:val)')
endfunction

" https://stackoverflow.com/a/4479072/2295034
function! Trim(input_string)
  return substitute(a:input_string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

function! JessDocMain()
  let l:functionLineNumber = line('.')

  if (!HasJSDocBlock())
    call AddJSDocBlock(l:functionLineNumber)
  endif

  let l:startJSDocBlockLineNumber = GetStartJSDocBlockLineNumber()
  let l:endJSDocBlockLineNumber = GetEndJSDocBlockLineNumber()

  for param in reverse(GetParams())
    if (!HasParamTag(param, l:startJSDocBlockLineNumber, l:endJSDocBlockLineNumber))
      call AddParam(param, l:functionLineNumber, l:startJSDocBlockLineNumber, l:endJSDocBlockLineNumber)
    endif
  endfor
endfunction

exe "command! JessDoc :call JessDocMain()"
