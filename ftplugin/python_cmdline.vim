function! PythonSourceLines(lines)

    call VimCmdLineSendCmd(join(add(a:lines, ''), b:cmdline_nl))
    call VimCmdLineSendCmd("")
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
        call VimCmdLineSendCmd("")
    endif
    call VimCmdLineDown()
endfunction


function! VimCmdLineSendFile()
    saveas %:p
    call VimCmdLineSendCmd("exec(open(" . "r'" . expand('%:p') . "'" . ").read())")
    call VimCmdLineSendCmd("")
endfunction


function! VimCmdLinePrintWORD()
    call VimCmdLineSendCmd("print(" . expand('<cWORD>') . ")")
    call VimCmdLineSendCmd("")
endfunction


function! VimCmdLinePrintWord()
    call VimCmdLineSendCmd("print(" . expand('<cword>') . ")")
    call VimCmdLineSendCmd("")
endfunction


function! s:VimCmdLinePrintWORDFullScreen()
    let b:cmdline_fullscreen = 1
    :resize 0
    call VimCmdLineSendCmd("import pandas as pd")
    call VimCmdLineSendCmd("pd.set_option('display.min_rows', 42)")
    call VimCmdLineSendCmd("print(" . expand('<cWORD>') . ")")
    sleep 50m
    call VimCmdLineSendCmd("")
endfunction


function! s:VimCmdLinePrintWordFullScreen()
    let b:cmdline_fullscreen = 1
    :resize 0
    call VimCmdLineSendCmd("import pandas as pd")
    call VimCmdLineSendCmd("pd.set_option('display.min_rows', 42)")
    call VimCmdLineSendCmd("print(" . expand('<cword>') . ")")
    sleep 50m
    call VimCmdLineSendCmd("")
endfunction


function! s:VimCmdLinePrintHEADFullScreen()
    let b:cmdline_fullscreen = 1
    :resize 0
    call VimCmdLineSendCmd("pd.set_option('display.max_rows', None)")
    call VimCmdLineSendCmd("print(" . expand('<cWORD>') . ".head().transpose())")
    sleep 50m
    call VimCmdLineSendCmd("")
endfunction


function! s:VimCmdLinePrintHeadFullScreen()
    let b:cmdline_fullscreen = 1
    :resize 0
    call VimCmdLineSendCmd("pd.set_option('display.max_rows', None)")
    call VimCmdLineSendCmd("print(" . expand('<cword>') . ".head().transpose())")
    sleep 50m
    call VimCmdLineSendCmd("")
endfunction


function! VimCmdLinePlot()
    call VimCmdLineSendCmd("import matplotlib.pyplot as plt")
    call VimCmdLineSendCmd("import seaborn as sns")
    call VimCmdLineSendCmd("sns.displot(" . expand('<cWORD>') . ")")
    call VimCmdLineSendCmd("plt.show()")
    sleep 50m
    call VimCmdLineSendCmd("")
endfunction


function! VimCmdLinePlotOutlier()
    call VimCmdLineSendCmd("import matplotlib.pyplot as plt")
    call VimCmdLineSendCmd("import seaborn as sns")
    call VimCmdLineSendCmd("x = " . expand('<cWORD>'))
    call VimCmdLineSendCmd("x = x[x.between(x.quantile(.10), x.quantile(.90))]")
    call VimCmdLineSendCmd("sns.displot(x, bins=30)")
    call VimCmdLineSendCmd("plt.show()")
    sleep 50m
    call VimCmdLineSendCmd("")
endfunction


function! VimCmdLinePrintLength()
    call VimCmdLineSendCmd("len(" . expand('<cword>') . ")")
    call VimCmdLineSendCmd("")
endfunction


function! VimCmdLinePrintInfo()
    call VimCmdLineSendCmd(expand('<cWORD>') . ".info()")
    call VimCmdLineSendCmd("")
endfunction


function! VimCmdLinePrintTable()
    call VimCmdLineSendCmd(expand('<cWORD>') . ".value_counts()")
    call VimCmdLineSendCmd("")
endfunction


function! VimCmdLinePrintSummary()
    call VimCmdLineSendCmd(expand('<cWORD>') . ".describe()")
    call VimCmdLineSendCmd("")
endfunction


function! VimCmdLinePrintSUMMARY()
    call VimCmdLineSendCmd(expand('<cWORD>') . ".describe()")
    call VimCmdLineSendCmd("")
endfunction


function! VimCmdLinePrintBrowser()
    call VimCmdLineSendCmd("import webbrowser")
    call VimCmdLineSendCmd("import os")
    call VimCmdLineSendCmd("import time")
    call VimCmdLineSendCmd("html = " . expand('<cWORD>') . ".to_html()")
    call VimCmdLineSendCmd("text_file = open('index.html', 'w')")
    call VimCmdLineSendCmd("text_file.write(html)")
    call VimCmdLineSendCmd("text_file.close()") 
    call VimCmdLineSendCmd("webbrowser.open(" . "'file://'" . "+ os.path.realpath('index.html')" .")") 
    call VimCmdLineSendCmd("time.sleep(5)")
    call VimCmdLineSendCmd("os.remove('index.html')")
    call VimCmdLineSendCmd("")
endfunction


function! VimCmdLineToCSV()
    call VimCmdLineSendCmd(expand('<cWORD>') . ".to_csv('~/OneDrive/Desktop/df.csv')")
    call VimCmdLineSendCmd("")
endfunction


function! VimCmdLineToExcel()
    call VimCmdLineSendCmd(expand('<cWORD>') . ".to_excel('~/OneDrive/Desktop/df.xlsx')")
    call VimCmdLineSendCmd("")
endfunction

function! s:VimCmdLineSizeDown()
    unlet b:cmdline_fullscreen
    call VimCmdLineSendCmd("import pandas as pd")
    call VimCmdLineSendCmd("pd.reset_option('^display')")
    call VimCmdLineSendCmd("")
    resize +38
endfunction


function! VimCmdLineShowVariables()
    call VimCmdLineSendCmd('%who_ls')
    call VimCmdLineSendCmd("")
endfunction


function! VimCmdLineResetSize()
    :resize -9
endfunction


function! VimCmdLineDeleteVariables()
    :resize +52
    call VimCmdLineSendCmd('%reset -f')
    call VimCmdLineSendCmd("")
    sleep 50m
    call VimCmdLineResetSize()
endfunction


function! s:TogglePrintWordFullScreen()
    if !exists('b:cmdline_fullscreen') | cal s:VimCmdLinePrintWordFullScreen() | el | cal s:VimCmdLineSizeDown() | en  
endfunction


function! s:TogglePrintWORDFullScreen()
    if !exists('b:cmdline_fullscreen') | cal s:VimCmdLinePrintWORDFullScreen() | el | cal s:VimCmdLineSizeDown() | en  
endfunction


function! s:TogglePrintHeadFullScreen()
    if !exists('b:cmdline_fullscreen') | cal s:VimCmdLinePrintHeadFullScreen() | el | cal s:VimCmdLineSizeDown() | en  
endfunction


function! s:TogglePrintHEADFullScreen()
    if !exists('b:cmdline_fullscreen') | cal s:VimCmdLinePrintHEADFullScreen() | el | cal s:VimCmdLineSizeDown() | en  
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
nmap <LocalLeader>rP :call VimCmdLinePrintWord()<CR>
nmap <LocalLeader>rp :call VimCmdLinePrintWORD()<CR>
nmap <LocalLeader>rV :call <SID>TogglePrintWordFullScreen()<CR>
nmap <LocalLeader>rv :call <SID>TogglePrintWORDFullScreen()<CR>
nmap <LocalLeader>rH :call <SID>TogglePrintHeadFullScreen()<CR>
nmap <LocalLeader>rh :call <SID>TogglePrintHEADFullScreen()<CR>
nmap<LocalLeader>ri :call VimCmdLinePrintInfo()<CR>
nmap<LocalLeader>rs :call VimCmdLinePrintSummary()<CR>
nmap<LocalLeader>rS :call VimCmdLinePrintSUMMARY()<CR>
nmap<LocalLeader>rt :call VimCmdLinePrintTable()<CR>
nmap<LocalLeader>rg :call VimCmdLinePlot()<CR>
nmap<LocalLeader>rG :call VimCmdLinePlotOutlier()<CR>
nmap<LocalLeader>rb :call VimCmdLinePrintBrowser()<CR>
nmap<LocalLeader>rc :call VimCmdLineToCSV()<CR>
nmap<LocalLeader>rC :call VimCmdLineToExcel()<CR>
nmap<LocalLeader>rw :call VimCmdLineShowVariables()<CR>
nmap<LocalLeader>rW :call VimCmdLineDeleteVariables()<CR>

exe 'nmap <buffer><silent> ' . g:cmdline_map_start . ' :call VimCmdLineStartApp()<CR>'

call VimCmdLineSetApp("python")
