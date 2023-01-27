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
    call VimCmdLineSendCmd("pd.set_option('display.max_rows', 5)")
    call VimCmdLineSendCmd("print(" . expand('<cWORD>') . ")")
    sleep 50m
    call VimCmdLineSendCmd("")
endfunction


function! VimCmdLinePrintWord()
    call VimCmdLineSendCmd("pd.set_option('display.max_rows', 5)")
    call VimCmdLineSendCmd("print(" . expand('<cword>') . ")")
    sleep 50m
    call VimCmdLineSendCmd("")
endfunction


function! VimCmdLinePrintWORDFullScreen()
    :resize 0
    call VimCmdLineSendCmd("pd.set_option('display.max_rows', 20)")
    call VimCmdLineSendCmd("pd.set_option('display.min_rows', 20)")
    call VimCmdLineSendCmd("print(" . expand('<cWORD>') . ")")
    sleep 50m
    call VimCmdLineSendCmd("")
endfunction


function! VimCmdLinePrintWordFullScreen()
    :resize 0
    call VimCmdLineSendCmd("pd.set_option('display.max_rows', 20)")
    call VimCmdLineSendCmd("pd.set_option('display.min_rows', 20)")
    call VimCmdLineSendCmd("print(" . expand('<cword>') . ")")
    sleep 50m
    call VimCmdLineSendCmd("")
endfunction


function! VimCmdLinePrintHEADFullScreen()
    :resize 0
    call VimCmdLineSendCmd("pd.set_option('display.max_rows', None)")
    sleep 50m
    call VimCmdLineSendCmd("print(" . expand('<cWORD>') . ".head().transpose())")
    sleep 50m
    call VimCmdLineSendCmd("")
endfunction


function! VimCmdLinePrintHeadFullScreen()
    :resize 0
    call VimCmdLineSendCmd("pd.set_option('display.max_rows', None)")
    call VimCmdLineSendCmd("print(" . expand('<cword>') . ".head().transpose())")
    sleep 50m
    call VimCmdLineSendCmd("")
endfunction


function! VimCmdLinePlot()
    call VimCmdLineSendCmd("sns.displot(" . expand('<cWORD>') . ")")
    call VimCmdLineSendCmd("plt.show()")
    sleep 50m
    call VimCmdLineSendCmd("")
endfunction


function! VimCmdLinePlotOutlier()
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


function! VimCmdLinePrintColumns()
    call VimCmdLineSendCmd(expand('<cword>') . ".columns")
    call VimCmdLineSendCmd("")
endfunction

function! VimCmdLinePrintInfo()
    call VimCmdLineSendCmd(expand('<cword>') . ".info()")
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
    call VimCmdLineSendCmd("string = " . expand('<cWORD>') . ".to_html()")
    call VimCmdLineSendCmd("html = '<head><link rel=\"stylesheet\" href=\"styles.css\"></head>' + string")
    call VimCmdLineSendCmd("text_file = open(" . "r'" . stdpath('data') . "/plugged/vimcmdline/site/index.html', 'w')")
    call VimCmdLineSendCmd("text_file.write(html)")
    call VimCmdLineSendCmd("text_file.close()") 
    call VimCmdLineSendCmd("webbrowser.open(" . "r'" . stdpath('data') . "/plugged/vimcmdline/site/index.html', 'w')") 
    sleep 50m
    call VimCmdLineSendCmd("")
endfunction


function! VimCmdLinePrintBrowserLimit()
    call VimCmdLineSendCmd("string = " . expand('<cWORD>') . ".head().to_html()")
    call VimCmdLineSendCmd("html = '<head><link rel=\"stylesheet\" href=\"styles.css\"></head>' + string")
    call VimCmdLineSendCmd("text_file = open(" . "r'" . stdpath('data') . "/plugged/vimcmdline/site/index.html', 'w')")
    call VimCmdLineSendCmd("text_file.write(html)")
    call VimCmdLineSendCmd("text_file.close()") 
    call VimCmdLineSendCmd("webbrowser.open(" . "r'" . stdpath('data') . "/plugged/vimcmdline/site/index.html', 'w')") 
    sleep 50m
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


function! VimCmdLineShowVariables()
    call VimCmdLineSendCmd('%who_ls')
    call VimCmdLineSendCmd("")
endfunction


function! VimCmdLineResetSize()
    :resize +100
    sleep 100m
    :resize -9
endfunction


function! VimCmdLineDeleteVariables()
    :resize +100
    call VimCmdLineSendCmd('%reset -f')
    call VimCmdLineSendCmd("import pandas as pd")
    call VimCmdLineSendCmd("import matplotlib.pyplot as plt")
    call VimCmdLineSendCmd("import seaborn as sns")
    call VimCmdLineSendCmd("import webbrowser")
    call VimCmdLineSendCmd("import time")
    call VimCmdLineSendCmd("")
    sleep 100m
    :resize -11
endfunction


if has("win32")
    let b:cmdline_nl = "\r"
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
nmap <F5> :call VimCmdLineResetSize()<CR>
nmap <LocalLeader>rl :call VimCmdLinePrintLength()<CR>
nmap <LocalLeader>rP :call VimCmdLinePrintWord()<CR>
nmap <LocalLeader>rp :call VimCmdLinePrintWORD()<CR>
nmap <LocalLeader>rV :call VimCmdLinePrintWordFullScreen()<CR>
nmap <LocalLeader>rv :call VimCmdLinePrintWORDFullScreen()<CR>
nmap <LocalLeader>rH :call VimCmdLinePrintHeadFullScreen()<CR>
nmap <LocalLeader>rh :call VimCmdLinePrintHEADFullScreen()<CR>
nmap<LocalLeader>ri :call VimCmdLinePrintColumns()<CR>
nmap<LocalLeader>rI :call VimCmdLinePrintInfo()<CR>
nmap<LocalLeader>rs :call VimCmdLinePrintSummary()<CR>
nmap<LocalLeader>rS :call VimCmdLinePrintSUMMARY()<CR>
nmap<LocalLeader>rt :call VimCmdLinePrintTable()<CR>
nmap<LocalLeader>rg :call VimCmdLinePlot()<CR>
nmap<LocalLeader>rG :call VimCmdLinePlotOutlier()<CR>
nmap<LocalLeader>rb :call VimCmdLinePrintBrowser()<CR>
nmap<LocalLeader>rB :call VimCmdLinePrintBrowserLimit()<CR>
nmap<LocalLeader>rc :call VimCmdLineToCSV()<CR>
nmap<LocalLeader>rC :call VimCmdLineToExcel()<CR>
nmap<LocalLeader>rw :call VimCmdLineShowVariables()<CR>
nmap<LocalLeader>rW :call VimCmdLineDeleteVariables()<CR>

exe 'nmap <buffer><silent> ' . g:cmdline_map_start . ' :call VimCmdLineStartApp()<CR>'

call VimCmdLineSetApp("python")
