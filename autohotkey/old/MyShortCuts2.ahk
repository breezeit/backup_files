;@version:2017-03-21
;================================

;��������
volStep := 5				;��������

;�ȼ��趨
Hotkey,#up,volUp 			;��������
hotkey,#down,volDown 		;��������
hotkey,#h,helpToolTip		;�ű����ݰ�����ʾ
hotkey,#F1,runHelpSpy		;����AHK������SPY
hotkey,#left,toLeft			;����
hotkey,#right,toRight		;����
hotkey,#p,atTransparent		;�����ָ����͸����220
hotkey,#i,atTransparent2	;�����ָ����͸����180
hotkey,#o,closeTransparent	; �ر������ָ���ڵ�͸��Ч��
hotkey,#t,toggleTop 		;�����ָ�����ö�
hotkey,#y,youdaoDict		;���Ƶ��ʣ��Զ����е��ʵ������
hotkey,#c,myComputer		;���ҵĵ���
return
;====================================

;��������
volUp:
soundSet,+%volStep%
gosub,soundShow
return

volDown:
soundSet,-%volStep%
gosub,soundShow
return

;������ʾ��ʾ
soundShow:
soundget,master_volume
intVol := ceil(master_volume)
tooltip,��ǰ������ %intVol%
gosub, tooltiptimer
return
;===============================

;tooltip��ʱ��

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

helpToolTip: ;�ű����ݰ�����ʾ
Tooltip,
(
win-F1:����AHK������SPY`n
win-p: �����ָ����͸����220
win-i:�����ָ����͸����180
win-o: �ر������ָ���ڵ�͸��Ч�� `n
win-t: �л������ָ�����ö� `n
win-y:���Ƶ��ʣ��Զ����е��ʵ������ `n
win-left:���� ָ����С
win-right:����ָ����С
win-up:��������
win-down:��������
) ;()��ʾ�����ı�
gosub tooltiptimer2
return
;======================================

runHelpSpy: ;����AHK������SPY
;DetectHiddenWindows, On
IfWinNotExist, AutoHotkey ���İ���
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
;���������ƶ�
toLeft:
WinGet, active_id, ID, A
winmove,ahk_id %active_id%, ,0 , 0 , 1210 , 1040
ToolTip,����
gosub tooltiptimer
Return

toRight:
WinGet, active_id, ID, A
winmove,ahk_id %active_id%, ,1210 , 0 , 710 ,1040
ToolTip,����
gosub tooltiptimer
Return

;===========================================

atTransparent: ;�����ָ����͸����
MouseGetPos, MouseX, MouseY, MouseWin
WinSet, Transparent, 220, ahk_id %MouseWin% ; 0-255,255��ȫ��͸��
ToolTip,�����ָ����͸����220
gosub tooltiptimer
return

atTransparent2: ;�����ָ����͸����
MouseGetPos, MouseX, MouseY, MouseWin
WinSet, Transparent, 180, ahk_id %MouseWin% ; 0-255,255��ȫ��͸��
ToolTip,�����ָ����͸����180
gosub tooltiptimer
return

closeTransparent:  ; �ر������ָ���ڵ�͸��Ч��
MouseGetPos,,, MouseWin
WinSet, Transparent, Off, ahk_id %MouseWin%
WinSet, TransColor, Off, ahk_id %MouseWin%
ToolTip,�ر������ָ���ڵ�͸��
gosub tooltiptimer
return

;================================================
setTop: ;�����ָ�����ö�
MouseGetPos, MouseX, MouseY, MouseWin
WinSet ,AlwaysOnTop ,on,ahk_id %MouseWin%
ToolTip,�����ָ�����ö�
gosub tooltiptimer
return

unSetTop: ;ȡ�������ָ�����ö�
MouseGetPos, MouseX, MouseY, MouseWin
WinSet ,AlwaysOnTop ,off,ahk_id %MouseWin%
ToolTip,ȡ�������ָ�����ö�
gosub tooltiptimer
return

toggleTop: ;�л������ָ�����ö�
MouseGetPos, MouseX, MouseY, MouseWin
WinSet ,AlwaysOnTop ,Toggle,ahk_id %MouseWin%
ToolTip,�л������ָ�����ö�
gosub tooltiptimer
return
;=================================================

;���Ƶ��ʣ��Զ����е��ʵ������
youdaoDict:
send ^c
ifwinexist,ahk_class YodaoMainWndClass,,, ;�е�������
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
		{	;msgbox û�������е��ʵ�
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
	run,::{20d04fe0-3aea-1069-a2d8-08002b30309d}	;�ҵĵ���
return
