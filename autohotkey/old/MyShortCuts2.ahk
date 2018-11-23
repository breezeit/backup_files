;@version:2017-03-21
;================================

;变量调整
volStep := 5				;音量标量

;热键设定
Hotkey,#up,volUp 			;音量提升
hotkey,#down,volDown 		;音量降低
hotkey,#h,helpToolTip		;脚本内容帮助显示
hotkey,#F1,runHelpSpy		;启动AHK帮助和SPY
hotkey,#left,toLeft			;靠左
hotkey,#right,toRight		;靠右
hotkey,#p,atTransparent		;鼠标所指窗口透明化220
hotkey,#i,atTransparent2	;鼠标所指窗口透明化180
hotkey,#o,closeTransparent	; 关闭鼠标所指窗口的透明效果
hotkey,#t,toggleTop 		;鼠标所指窗口置顶
hotkey,#y,youdaoDict		;复制单词，自动在有道词典里查找
hotkey,#c,myComputer		;打开我的电脑
return
;====================================

;音量控制
volUp:
soundSet,+%volStep%
gosub,soundShow
return

volDown:
soundSet,-%volStep%
gosub,soundShow
return

;音量显示提示
soundShow:
soundget,master_volume
intVol := ceil(master_volume)
tooltip,当前音量： %intVol%
gosub, tooltiptimer
return
;===============================

;tooltip定时器

RemoveToolTip:
SetTimer, RemoveToolTip, Off
ToolTip
return

tooltiptimer:
#Persistent
SetTimer, RemoveToolTip, 1000
return

tooltiptimer2:
#Persistent
SetTimer, RemoveToolTip, 6000
return
;==================================

helpToolTip: ;脚本内容帮助显示
Tooltip,
(
win-F1:启动AHK帮助和SPY`n
win-p: 鼠标所指窗口透明化220
win-i:鼠标所指窗口透明化180
win-o: 关闭鼠标所指窗口的透明效果 `n
win-t: 切换鼠标所指窗口置顶 `n
win-y:复制单词，自动在有道词典里查找 `n
win-left:靠左 指定大小
win-right:靠右指定大小
win-up:音量提升
win-down:音量降低
) ;()表示多行文本
gosub tooltiptimer2
return
;======================================

runHelpSpy: ;启动AHK帮助和SPY
;DetectHiddenWindows, On
IfWinNotExist, AutoHotkey 中文帮助
	{
		run C:\backup_files\autohotkey\AutoHotkey Help v1.1.chm
	}
IfWinNotExist, Active Window Info
	{
		run C:\Program Files\AutoHotkey\AU3_Spy.exe
	}
;DetectHiddenWindows, off
Return
;===========================================
;窗口左右移动
toLeft:
WinGet, active_id, ID, A
winmove,ahk_id %active_id%, ,0 , 0 , 1210 , 1040
ToolTip,靠左
gosub tooltiptimer
Return

toRight:
WinGet, active_id, ID, A
winmove,ahk_id %active_id%, ,1210 , 0 , 710 ,1040
ToolTip,靠右
gosub tooltiptimer
Return

;===========================================

atTransparent: ;鼠标所指窗口透明化
MouseGetPos, MouseX, MouseY, MouseWin
WinSet, Transparent, 220, ahk_id %MouseWin% ; 0-255,255完全不透明
ToolTip,鼠标所指窗口透明化220
gosub tooltiptimer
return

atTransparent2: ;鼠标所指窗口透明化
MouseGetPos, MouseX, MouseY, MouseWin
WinSet, Transparent, 180, ahk_id %MouseWin% ; 0-255,255完全不透明
ToolTip,鼠标所指窗口透明化180
gosub tooltiptimer
return

closeTransparent:  ; 关闭鼠标所指窗口的透明效果
MouseGetPos,,, MouseWin
WinSet, Transparent, Off, ahk_id %MouseWin%
WinSet, TransColor, Off, ahk_id %MouseWin%
ToolTip,关闭鼠标所指窗口的透明
gosub tooltiptimer
return

;================================================
setTop: ;鼠标所指窗口置顶
MouseGetPos, MouseX, MouseY, MouseWin
WinSet ,AlwaysOnTop ,on,ahk_id %MouseWin%
ToolTip,鼠标所指窗口置顶
gosub tooltiptimer
return

unSetTop: ;取消鼠标所指窗口置顶
MouseGetPos, MouseX, MouseY, MouseWin
WinSet ,AlwaysOnTop ,off,ahk_id %MouseWin%
ToolTip,取消鼠标所指窗口置顶
gosub tooltiptimer
return

toggleTop: ;切换鼠标所指窗口置顶
MouseGetPos, MouseX, MouseY, MouseWin
WinSet ,AlwaysOnTop ,Toggle,ahk_id %MouseWin%
ToolTip,切换鼠标所指窗口置顶
gosub tooltiptimer
return
;=================================================

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
		;ControlClick,Chrome_RenderWidgetHostHWND1
		;MouseMove,340,180,0
		return
	}
	else
		{	;msgbox 没有启动有道词典
	            	run C:\Program Files\Youdao\Dict\YoudaoDict.exe
	            	sleep 2000
	            	WinActivate,ahk_class YodaoMainWndClass,,,
					send ^v
					sleep 500
					send {enter}
					sleep 500
	            	return
		}
return
;=====================================

myComputer:
	run,::{20d04fe0-3aea-1069-a2d8-08002b30309d}	;我的电脑
return
