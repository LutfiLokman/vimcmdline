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
    call VimCmdLineSendCmd("import pandas as pd")
    call VimCmdLineSendCmd("pd.set_option('display.min_rows', 42)")
    call VimCmdLineSendCmd("import os")
    call VimCmdLineSendCmd("os.system('cls')")")
    call VimCmdLineSendCmd("print(" . expand('<cWORD>') . ")")
endfunction


function! VimCmdLinePlot()
    call VimCmdLineSendCmd("import matplotlib.pyplot as plt")
    call VimCmdLineSendCmd("import seaborn as sns")
    call VimCmdLineSendCmd("sns.displot(" . expand('<cWORD>') . ")")
    call VimCmdLineSendCmd("plt.show()")
endfunction


function! VimCmdLinePlotOutlier()
    call VimCmdLineSendCmd("import matplotlib.pyplot as plt")
    call VimCmdLineSendCmd("import seaborn as sns")
    call VimCmdLineSendCmd("x = " . expand('<cWORD>'))
    call VimCmdLineSendCmd("x = x[x.between(x.quantile(.10), x.quantile(.90))]")
    call VimCmdLineSendCmd("sns.displot(x, bins=30)")
    call VimCmdLineSendCmd("plt.show()")
endfunction


function! VimCmdLinePrintLength()
    call VimCmdLineSendCmd("len(" . expand('<cword>') . ")")
endfunction


function! VimCmdLinePrintInfo()
    call VimCmdLineSendCmd(expand('<cword>') . ".info()")
endfunction


function! VimCmdLinePrintTable()
    call VimCmdLineSendCmd(expand('<cWORD>') . ".value_counts()")
endfunction


function! VimCmdLinePrintSummary()
    call VimCmdLineSendCmd(expand('<cWORD>') . ".describe()")
endfunction


function! VimCmdLineSizeDown()
    call VimCmdLineSendCmd("import pandas as pd")
    call VimCmdLineSendCmd("pd.reset_option('^display')")
    resize +38
endfunction


function! VimCmdLineClear()
    call VimCmdLineSendCmd("import os")
    call VimCmdLineSendCmd("os.system('cls')")")
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
nmap<LocalLeader>ri :call VimCmdLinePrintInfo()<CR>
nmap<LocalLeader>rs :call VimCmdLinePrintSummary()<CR>
nmap<LocalLeader>rt :call VimCmdLinePrintTable()<CR>
nmap<LocalLeader>rr :call VimCmdLineClear()<CR>
nmap<LocalLeader>rg :call VimCmdLinePlot()<CR>
nmap<LocalLeader>rG :call VimCmdLinePlotOutlier()<CR>


noremap <LocalLeader>= :resize -38<CR>
noremap <LocalLeader>- :call VimCmdLineSizeDown()<CR>

exe 'nmap <buffer><silent> ' . g:cmdline_map_start . ' :call VimCmdLineStartApp()<CR>'

call VimCmdLineSetApp("python")
call VimCmdLineStartApp()
:resize 40
