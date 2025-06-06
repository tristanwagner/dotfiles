function! functions#fckALEToggle(...)
    let s:fckALEStatus = {}
    let s:fckALEStatus['global'] = get(g:, 'ale_fix_on_save', 0)
    let s:fckALEStatus['buffer'] = get(b:, 'ale_fix_on_save', s:fckALEStatus['global'])
    let s:fckCurrentScope = get(a:, 1, 'global')
    if (s:fckALEStatus[s:fckCurrentScope] == 1)
        let s:fckALEStatus[s:fckCurrentScope]=0
    else
        let s:fckALEStatus[s:fckCurrentScope]=1
    endif
    let g:ale_fix_on_save=s:fckALEStatus['global']
    let b:ale_fix_on_save=s:fckALEStatus['buffer']
endfunction
