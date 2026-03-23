command! ALEDisableFixers       let g:ale_fix_on_save=0
command! ALEEnableFixers        let g:ale_fix_on_save=1
command! ALEDisableFixersBuffer let b:ale_fix_on_save=0
command! ALEEnableFixersBuffer  let b:ale_fix_on_save=0
command! ALEToggleFixers call functions#fckALEToggle('global')
command! ALEToggleFixersBuffer call functions#fckALEToggle('buffer')
