Link = C:\backup_files\autohotkey\Links

Loop, %Link%\*.lnk
{
runwait %Link%\%A_LoopFileName%
; runwait 命令，等一个程序启动完成之后再循环启动下一个程序，直到循环自动退出。
}

ExitApp
; 自动退出