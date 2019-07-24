" Load once
if exists('g:vim_autobackup')
    finish
endif

let g:vim_autobackup = 1

let g:vim_autobackup_dir = '~/.vim/backups'
let g:vim_autobackup_time = 300000

" if ! isdirectory(g:vim_autobackup_dir)
"     call mkdir(g:vim_autobackup_dir, 'p')
" endif


function! s:IsUntitledBuffer(file_path)

    if a:file_path =~ '%untitled-buffer~'
        echo "true"
        return 0
    endif

    echo "false"
    return 1

endfunction


function! s:GenerateBackupFileName(file_path, directory)

    if empty(a:file_path)
        let l:backup_file_path = substitute(a:directory, "/" , "%" , "g") . '%untitled-buffer'
    else
        let l:backup_file_path = substitute(a:file_path, "/" , "%" , "g")
    endif

    let l:backup_file_path = l:backup_file_path . '~' . strftime("%Y.%m.%d.%H.%M.%S")
    let l:backup_file_path = g:vim_autobackup_dir . '/' . l:backup_file_path

    return l:backup_file_path

endfunction


let timer = timer_start(g:vim_autobackup_time, 'SaveBackupFile',{'repeat':-1})


function! SaveBackupFile(timer)

    let l:current_file_path = expand('%:p')
    let l:current_directory = expand('%:p:h')

    let l:backup_file_path = s:GenerateBackupFileName(l:current_file_path, l:current_directory)

    silent! execute "w! " . fnameescape(l:backup_file_path)

endfunction
