let s:save_cpo = &cpo
set cpo&vim

let s:source = {
            \ 'name' : 'codic',
            \ 'description' : 'search Codic dictionary',
            \ 'default_action' : {'common' : 'insert'},
            \ }

function! unite#sources#codic#define()
    return exists(':Codic') ? s:source : {}
endfunction

function! s:error_msg(msg)
    echohl ErrorMsg
    echomsg a:msg
    echohl None
endfunction

function! s:source.change_candidates(args, context)
    let word = matchstr(a:context.input, '^\S\+')
    if word == ''
        return []
    endif

    let top_items = codic#search(word, get(a:args, 0, 100))
    let candidates = []
    for top_item in top_items
        call add(candidates, { 'word' : '['. top_item.label . ']' })
        for value in top_item.values
            call add(candidates, {
                        \ 'word' : printf('  %s %s %s', top_item.label, value.word, value.desc),
                        \ 'abbr' : printf('  %s %s', value.word, value.desc),
                        \ 'action__text' : value.word
                        \ })
        endfor
    endfor
    return candidates
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
