; ����: ��˸����ͼ��
; ����:
; 	ms_loop - ��˸��������룩�����Ϊ 0����ֹͣ��˸��
; 	s_stop  - �������ֹͣ��˸
FlashTrayIcon(ms_loop = 500, s_stop = 0) {
	static defaultIcon, blankIcon

	defaultIcon := A_IconFile ? A_IconFile : A_IsCompiled ? %A_ScriptDir% "\pic\run.ico"

	SetTimer, __FlashTrayIcon_Timer, % ms_loop ? ms_loop : "Off"
	SetTimer, __FlashTrayIcon_StopTimer, % s_stop ? (s_stop * 1000) : "Off"
	Return
	
	__FlashTrayIcon_Timer:
		blankIcon := !blankIcon
		
		If blankIcon
			Menu, Tray, Icon, SHELL32.dll, 50
		Else
			Menu, Tray, Icon, % defaultIcon
	Return
	
	__FlashTrayIcon_StopTimer:
		SetTimer, __FlashTrayIcon_Timer, Off
		Menu, Tray, Icon, % defaultIcon
	Return
}
