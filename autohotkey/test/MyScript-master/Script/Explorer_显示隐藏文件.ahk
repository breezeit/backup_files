��ʾ�����ļ�:
	RegRead, HiddenFiles_Status, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden
	If HiddenFiles_Status = 2
	{
		Traytip,֪ͨ,��ʾ�����ļ�,,1
		SetTimer,RemoveTraytip, 2000
		RegWrite REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, ShowSuperHidden, 00000001
		RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 1
	}
	Else
	{
		Traytip,֪ͨ,�����ļ�,,1
		SetTimer,RemoveTraytip, 2000
		RegWrite REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, ShowSuperHidden, 00000000
		RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 2
	}
	; ǿ��ˢ��
	Send, {F5}

	If (A_OSVersion="WIN_XP"){
			; ����ˢ�²˵� XP��Ч����Win_7��Ч
		PostMessage, 0x111, 28931,,,ahk_class Progman
		PostMessage, 0x111, 28931,,,ahk_class WorkerW
		PostMessage, 0x111, 28931,,,ahk_class CabinetWClass
		PostMessage, 0x111, 28931,,,ahk_class ExploreWClass
	}
	else{
		; ����ˢ�²˵� Win_7
		PostMessage, 0x111, 41504,,,ahk_class Progman
		PostMessage, 0x111, 41504,,,ahk_class WorkerW
		PostMessage, 0x111, 41504,,,ahk_class CabinetWClass
		PostMessage, 0x111, 41504,,,ahk_class ExploreWClass
	}
	; ˢ������
	DllCall("Shell32\SHChangeNotify", "uint", 0x8000000, "uint", 0x1000, "uint", 0, "uint", 0)
Return

�ļ���չ���л�:
	RegRead, FileExt_Status, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced,HideFileExt
	If FileExt_Status = 0
	{
		Traytip,֪ͨ,�����ļ���չ��,,1
		SetTimer,RemoveTraytip, 2000
		RegWrite REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, HideFileExt, 00000001
	}
	Else
	{
		Traytip,֪ͨ,��ʾ�ļ���չ��,,1
		SetTimer,RemoveTraytip, 2000
		RegWrite REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, HideFileExt, 00000000
}
	; ǿ��ˢ��
	Send, {F5}

	If (A_OSVersion="WIN_XP"){
		; ����ˢ�²˵� XP��Ч����Win_7��Ч
		PostMessage, 0x111, 28931,,,ahk_class Progman
		PostMessage, 0x111, 28931,,,ahk_class WorkerW
		PostMessage, 0x111, 28931,,,ahk_class CabinetWClass
		PostMessage, 0x111, 28931,,,ahk_class ExploreWClass
	}
	else{
		; ����ˢ�²˵� Win_7
		PostMessage, 0x111, 41504,,,ahk_class Progman
		PostMessage, 0x111, 41504,,,ahk_class WorkerW
		PostMessage, 0x111, 41504,,,ahk_class CabinetWClass
		PostMessage, 0x111, 41504,,,ahk_class ExploreWClass
	}
	; ˢ������
	DllCall("Shell32\SHChangeNotify", "uint", 0x8000000, "uint", 0x1000, "uint", 0, "uint", 0)
Return

; ��ʱ�Ƴ�TrayTiP
RemoveTrayTip:
	SetTimer, RemoveTrayTip, Off
	TrayTip
return