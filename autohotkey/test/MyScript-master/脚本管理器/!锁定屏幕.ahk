;ԭ���ߣ���ң�����
;��Դ��С�������http://www.appinn.com
SetWorkingDir %A_ScriptDir%
#Persistent
#SingleInstance Force

W = %A_ScreenWidth%
fx := W//2-150

H = %A_ScreenHeight%
fy := H//2-20

ifexist, Lock.ico
	Menu, tray, icon, Lock.ico
ifnotexist, ������Ļ.ini
{
	inputbox, key, ����������,������������Ļ��Ľ�������
	IniWrite, %key%, ������Ļ.ini, setting, key
}
IniRead, key, ������Ļ.ini, setting, key
if key=""
{
	inputbox, key, ����������,������������Ļ��Ľ�������
	IniWrite, %key%, ������Ļ.ini, setting, key
}
gosub, makemenu
; �Ż��ڴ�
EmptyMem()
return

set:
        inputbox, key, ����������,������������Ļ��Ľ�������
        if ErrorLevel
           return
	IniWrite, %key%, ������Ļ.ini, setting, key
	menu, tray, Rename, %menukey%, ���룺%key%
	menukey=���룺%key%
Return

#L::
start:
	blockinput, MouseMove
	Gui, +AlwaysOnTop +Disabled -SysMenu +Owner -Caption +ToolWindow
        gui, font, s28
	gui, add, text,x%fx% y%fy% cred , ���Ѿ������˼��������`n��������ȷ�������Խ���
	CustomColor = 000000
	Gui, Color, %CustomColor%
	gui, show,X0 Y0 W%A_ScreenWidth% H%A_ScreenHeight%,������Ļ
        WinSet,Transparent,150,������Ļ
	hotkey, Lbutton, stop
	hotkey, Rbutton, stop
	hotkey, Mbutton, stop
	hotkey, LWin, stop
	hotkey, Rwin, stop
	hotkey, LAlt, stop
	hotkey, RAlt, stop
	hotkey, Ctrl, Stop
	hotkey, esc, stop
	hotkey, del, stop
	hotkey, f1, stop
	hotkey, f4, stop
	hotkey, tab, stop
	i:=1
	Loop
	{
		input, a, L1
		StringLeft, temp, key, %i%
		stringright, temp, temp, 1
		if a=%temp%
		{
			i++
		}else{
			i:=1
		}
		if (i=(strlen(key)+1))
		{
			blockinput, mousemoveoff
			gui, Destroy
			Gui, +AlwaysOnTop +Disabled -SysMenu +Owner -Caption +ToolWindow
			gui, add, text, , �ѽ��������򼴽��˳�
			CustomColor = 999A9B
			Gui, Color, %CustomColsor%
			gui, show
			sleep, 500
			gui, destroy
			Reload
		}
	}
Return

stop:
return

makemenu:
	menu, tray, NoStandard
	Menu, Tray, DeleteAll
	menu, tray, add, ������Ļ Win+L, start
	menu, tray, default, ������Ļ Win+L
		menukey=���룺%key%
	menu, tray, add, %menukey%, stop
	menu, tray, disable, %menukey%
	menu, tray, add, ����..., about
	menu, tray, add
	menu, tray, add, ��������, set
	menu, tray, add
	menu, tray, add, �˳�, exitit
Return

about:
	traytip, , by ��ң�����`nС�������http://www.appinn.com
Return

exitit:
	ExitApp
Return

EmptyMem(PID="AHK Rocks"){
    pid:=(pid="AHK Rocks") ? DllCall("GetCurrentProcessId") : pid
    h:=DllCall("OpenProcess", "UInt", 0x001F0FFF, "Int", 0, "Int", pid)
    DllCall("SetProcessWorkingSetSize", "UInt", h, "Int", -1, "Int", -1)
    DllCall("CloseHandle", "Int", h)
}