" skip if filetype is sage.python
if match(&ft, '\v<sage>') != -1
    finish
endif

" Ensure that plugin/vimcmdline.vim was sourced
if !exists("g:cmdline_job")
    runtime plugin/vimcmdline.vim
endif


function! PythonSourceLines(lines)
    call VimCmdLineSendCmd(join(add(a:lines, ''), b:cmdline_nl))
endfunction


function! VimCmdLineSendFile()
    saveas %:t
    call VimCmdLineSendCmd("import importlib")
    call VimCmdLineSendCmd("import" . " " . expand('%:r'))
    call VimCmdLineSendCmd("importlib.reload(" . expand('%:r') . ")")
    call VimCmdLineSendCmd("from" . " " . expand('%:r') . " " . "import *")
endfunction


function! VimCmdLinePrintWord()
    :resize 0
    call VimCmdLineSendCmd("pd.set_option('display.min_rows', 42)")
    call VimCmdLineSendCmd("import os")
    call VimCmdLineSendCmd("os.system('cls')")")
    call VimCmdLineSendCmd("print(" . expand('<cword>') . ")")
    call VimCmdLineSendCmd("pd.reset_option('^display')")
endfunction


function! VimCmdLinePrintLength()
    call VimCmdLineSendCmd("len(" . expand('<cword>') . ")")
endfunction


function! PythonSendLine()
    let line = getline(".")
    if line =~ '^class ' || line =~ '^def '
        let lines = []
        let idx = line('.')
        while idx <= line('$')
            if line != ''
                let lines += [line]
            endif
            let idx += 1
            let line = getline(idx)
            if line =~ '^\S'
                break
            endif
        endwhile
        let lines += ['']
        call PythonSourceLines(lines)
        exe idx
        return
    endif
    if strlen(line) > 0 || b:cmdline_send_empty
        call VimCmdLineSendCmd(line)
    endif
    call VimCmdLineDown()
endfunction

if has("win32")
    let b:cmdline_nl = "\r\n"
else
    let b:cmdline_nl = "\n"
endif
if executable("python3")
    let b:cmdline_app = "python3"
else
    let b:cmdline_app = "python"
endif
let b:cmdline_quit_cmd = "quit()"
let b:cmdline_send = function('PythonSendLine')
let b:cmdline_source_fun = function("PythonSourceLines")
let b:cmdline_send_empty = 1
let b:cmdline_filetype = "python"

nmap <F10> :call VimCmdLineSendFile()<CR>
nmap <LocalLeader>rl :call VimCmdLinePrintLength()<CR>
nmap <LocalLeader>rp :call VimCmdLinePrintWord()<CR>

exe 'nmap <buffer><silent> ' . g:cmdline_map_start . ' :call VimCmdLineStartApp()<CR>'

call VimCmdLineSetApp("python")
