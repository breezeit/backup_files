WM_QUERYENDSESSION(wParam, lParam)
{
   global ShutdownBlock
   If not ShutdownBlock
      Exit
   SetTimer, ShutdownDialog, 30
   Return false
   /*   ;XP
    ENDSESSION_LOGOFF = 0x80000000
    If (lParam & ENDSESSION_LOGOFF)  ; �û�����ע��
        EventType = ע��
    Else  ; ϵͳ���ڹرջ�������
        EventType = �ػ�
   Return false
    MsgBox, 4,, ����%EventType%���Ƿ�����
    IfMsgBox Yes
        Return true  ; ���߲���ϵͳ������ �ػ�/ע�� ����������
    Else
    {
    DllCall("ShutdownBlockReasonDestroy","Uint",hAhk)
    Return false  ; ���߲���ϵͳ��ֹ �ػ�/ע����
     }
     */
}

ShutdownDialog:
WinWait, ahk_class BlockedShutdownResolver
If not ErrorLevel
{
   WinClose, ahk_class BlockedShutdownResolver
   WinWaitClose, ahk_class BlockedShutdownResolver
   IfNotEqual, ErrorLevel, 1, WinClose, ahk_class Progman
   SetTimer, ShutdownDialog, off
}
Return

#IfWinActive, �ر� Windows ahk_class #32770
Enter::
Space::
ControlGet, Choice, Choice, , ComboBox1
ControlGetFocus, Focus
If Choice in ע��,��������,�ػ�,��װ���²��ػ�
{
   If (Focus = "ComboBox1" && A_ThisHotkey = "Enter")
      or (Focus = "Button3")
      ShutdownBlock := false
}
SendInput, % "{" . A_ThisHotkey . "}"
Return
#IfWinActive

HookProc(hWinEventHook2, Event, hWnd)
{
	global ShutdownBlock
	static hShutdownDialog
	Event += 0
	if Event = 8 ; EVENT_SYSTEM_CAPTURESTART
	{
		WinGetClass, Class, ahk_id %hWnd%
		WinGetTitle, Title, ahk_id %hWnd%
		if (Class = "Button" and Title = "ȷ��")
		{
			ControlGet, Choice, Choice, , ComboBox1, ahk_id %hShutdownDialog%
			if Choice in ע��,��������,�ػ�,��װ���²��ػ�
				ShutdownBlock := false
		}
	}
	if Event = 9
	{
		ifWinActive, �ر� Windows ahk_class #32770
		{
			sleep,2000
			ShutdownBlock := true
		}
	}
	else if Event = 16 ; EVENT_SYSTEM_DIALOGSTART
	{
		WinGetClass, Class, ahk_id %hWnd%
		WinGetTitle, Title, ahk_id %hWnd%
		If (Class = "#32770" and Title = "�ر� Windows")
			hShutdownDialog := hWnd
	}
	else if Event = 17 ; EVENT_SYSTEM_DIALOGEND
		hShutdownDialog =
}