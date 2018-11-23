;@version:2017-03-22
;@content:some labels rewrite for functions

;全局
global volStep := 5                   ;音量标量
global leftWinWidth := 1360           ;左窗口宽度
global screenWidth := 1920            ;屏幕总宽度
global rightWinWidth := % screenWidth-leftWinWidth
global winHeight := 1047              ;窗口高度

;快捷键
hotkey,#F1,runHelpSpy                 ;启动AHK帮助和SPY
hotkey,#h,helpToolTip                 ;脚本内容帮助显示
;Hotkey,#up,volUp                      ;音量提升
;hotkey,#down,volDown                  ;音量降低
hotkey,#!left,toLeft                   		;靠左
hotkey,#!right,toRight                 		;靠右
;hotkey,#left,toLeft                   ;靠左
;hotkey,#right,toRight                 ;靠右
hotkey,#p,beTransparent220            ;鼠标所指窗口透明化220
hotkey,#i,beTransparent180            ;鼠标所指窗口透明化180
hotkey,#o,closeTransparent            ;关闭鼠标所指窗口的透明效果
hotkey,#t,toggleTop                   ;鼠标所指窗口置顶
hotkey,#y,youdaoDict                  ;复制单词，自动在有道词典里查找
hotkey,#m,myComputer                  ;打开我的电脑
hotkey,#c,calculator                  ;打开计算器
return
;====================================
helpToolTip: ;脚本内容帮助显示
    Tooltip,
    (
    win-F1:启动AHK帮助和SPY
    win-up:音量提升
    win-down:音量降低
    win-left:靠左指定大小
    win-right:靠右指定大小
    win-p:鼠标所指窗口不透明化220
    win-i:鼠标所指窗口不透明化180
    win-o:关闭鼠标所指窗口的透明效果
    win-t:切换鼠标所指窗口置顶
    win-y:复制单词，自动在有道词典里查找
    win-m:打开我的电脑
    win-c:打开计算器
    ) ;()表示多行文本
    toolTipTimer(6000)
return
;=======================================
;tooltip定时器
removeToolTip(){
    SetTimer, removeToolTip, Off
    ToolTip
}
toolTipTimer(time){     ;time:毫秒数字
    #Persistent
    SetTimer,removeToolTip,%time%
}

;音量控制
volUp(){
    soundSet,+%volStep%
    soundShow()
}
volDown(){
    soundSet,-%volStep%
    soundShow()
}
;音量显示提示
soundShow(){
    soundget,master_volume
    intVol := ceil(master_volume)
    tooltip,当前音量： %intVol%
    toolTipTimer(1000)
}

runHelpSpy: ;启动AHK帮助和SPY
    IfWinNotExist, AutoHotkey 中文帮助
        {
            run C:\backup_files\autohotkey\AutoHotkey Help v1.1.chm
        }
    IfWinNotExist, Active Window Info
        {
            run C:\Program Files\AutoHotkey\AU3_Spy.exe
        }
Return

;窗口左移动
toLeft(){
    WinGet, active_id, ID, A
    WinRestore,ahk_id %active_id%
    winmove,ahk_id %active_id%, ,0 , 0 , %leftWinWidth% , %winHeight%
    ToolTip,靠左
    tooltiptimer(1000)
}
;窗口右移动
toRight(){
    WinGet, active_id, ID, A
    WinRestore,ahk_id %active_id%
    winmove,ahk_id %active_id%, ,%leftWinWidth% , 0 , %rightWinWidth% ,%winHeight%
    ToolTip,靠右
    tooltiptimer(1000)
}

;鼠标所指窗口透明化
beTransparent(opa){
    MouseGetPos, MouseX, MouseY, MouseWin
    WinSet, Transparent, %opa%, ahk_id %MouseWin% ; 0-255,255完全不透明
    ToolTip,鼠标所指窗口不透明度：%opa%
    tooltiptimer(1000)
    }
; 关闭鼠标所指窗口的透明效果
closeTransparent(){
    MouseGetPos,,, MouseWin
    WinSet, Transparent, Off, ahk_id %MouseWin%
    WinSet, TransColor, Off, ahk_id %MouseWin%
    ToolTip,关闭鼠标所指窗口的透明
    tooltiptimer(1000)
    }
beTransparent220:
    beTransparent(220)
return
beTransparent180:
    beTransparent(180)
return

toggleTop(){ ;切换鼠标所指窗口置顶
    MouseGetPos, MouseX, MouseY, MouseWin
    WinSet ,AlwaysOnTop ,Toggle,ahk_id %MouseWin%
    ToolTip,切换鼠标所指窗口置顶
    tooltiptimer(1000)
}

;复制单词，自动在有道词典里查找
youdaoDict:
    send ^c
    ifwinexist,ahk_class YodaoMainWndClass,,, ;有道主窗口
        {
            WinActivate,ahk_class YodaoMainWndClass,,,
            send ^v
            sleep 500
            send {enter}
            sleep 500
        }
        else
        {                                      ;启动有道词典
            run C:\Program Files\Youdao\Dict\YoudaoDict.exe
            sleep 2000
            WinActivate,ahk_class YodaoMainWndClass,,,
            send ^v
            sleep 500
            send {enter}
            sleep 500
        }
return


myComputer:
    run,::{20d04fe0-3aea-1069-a2d8-08002b30309d}    ;我的电脑
return

calculator:
    run calc.exe    ;计算器
return
;f1::
 ;   ifwinexist,ahk_class XLMAIN,,,
  ;      {
   ;         send {Click 2}
    ;        sleep 100
     ;       send !{enter}
      ;      sleep 100
       ;     send {enter}
        ;}
;return
