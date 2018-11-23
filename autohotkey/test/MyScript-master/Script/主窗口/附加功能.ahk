_TrayEvent:
  XWN_FocusFollowsMouse := !XWN_FocusFollowsMouse
IniRead,Auto_Raise,%run_iniFile%,���ܿ���,Auto_Raise
IniRead,hover_any_window,%run_iniFile%,�Զ�����,hover_any_window
  If(Auto_Raise=1 && hover_any_window=1)
    Msgbox,,��ʾ,���ڡ�ѡ����Զ�����������Զ�������Զ����øù��ܡ�,5
  Else
  {
    Gosub, _ApplySettings
    Gosub, _MenuUpdate
  }
Return

_MenuUpdate:
	If ( XWN_FocusFollowsMouse )
		Menu, addf, Check, �Զ������(��ʱ)
	Else
		Menu, addf, UnCheck, �Զ������(��ʱ)
Return

_ApplySettings:
	If ( XWN_FocusFollowsMouse )
		SetTimer, XWN_FocusHandler, 1000
	Else
		SetTimer, XWN_FocusHandler, Off
Return

XWN_FocusHandler:
	CoordMode, Mouse, Screen
	MouseGetPos, XWN_MouseX, XWN_MouseY, XWN_WinID
	If ( !XWN_WinID )
		Return

	If ( (XWN_MouseX != XWN_MouseOldX) or (XWN_MouseY != XWN_MouseOldY) )
	{
		IfWinNotActive, ahk_id %XWN_WinID%
			XWN_FocusRequest = 1
		Else
			XWN_FocusRequest = 0
		XWN_MouseOldX := XWN_MouseX
		XWN_MouseOldY := XWN_MouseY
		XWN_MouseMovedTickCount := A_TickCount
	}
	Else
		If ( XWN_FocusRequest and (A_TickCount - XWN_MouseMovedTickCount > 500) )
		{
			WinGetClass, XWN_WinClass, ahk_id %XWN_WinID%
			If ( XWN_WinClass = "Progman" )
				Return

			WinGet, XWN_WinStyle, Style, ahk_id %XWN_WinID%
			If ( (XWN_WinStyle & 0x80000000) and !(XWN_WinStyle & 0x4C0000) )
				Return
			IfWinNotActive, ahk_id %XWN_WinID%
				WinActivate, ahk_id %XWN_WinID%
			XWN_FocusRequest = 0
		}
Return

runwithsys:
run_with_sys := !run_with_sys
IniWrite,%run_with_sys%,%run_iniFile%,���ܿ���,run_with_sys

	If ( run_with_sys=1 )
	{
		Menu, addf, Check, ��������
		RegWrite, REG_SZ, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows\CurrentVersion\Run, Run - Ahk, "%A_AhkPath%" "%A_ScriptFullPath%"
		}
	Else
	{
		Menu, addf, UnCheck, ��������
		RegDelete, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows\CurrentVersion\Run, Run - Ahk
		}
Return

AutoSaveDeskIcons:
Auto_SaveDeskIcons := !Auto_SaveDeskIcons
IniWrite,%Auto_SaveDeskIcons%,%run_iniFile%,���ܿ���,Auto_SaveDeskIcons
If  Auto_SaveDeskIcons=1
	Menu, addf, Check, ����ʱ��������ͼ��
	Else
	Menu, addf, UnCheck, ����ʱ��������ͼ��
Return

smartchooserbrowser:
  smartchooserbrowser := !smartchooserbrowser
  IniWrite,%smartchooserbrowser%,%run_iniFile%,���ܿ���,smartchooserbrowser
  If  smartchooserbrowser=1
  {
	  Menu, addf, Check, ���������
	  writeahkurl()
	}
	Else
	{
	  Menu, addf, UnCheck, ���������
	  delahkurl()
	}
Return

/*
�����ԭ�򣺽�ahkд��ע���ʱ��ĳЩ����ڴ���ҳʱ�����ò���ȷ���������ahk(�ƹ�)����ֱ�Ӵ�����������������exe�ļ�����ҳ�����Ա���Ϊexe�ļ�����ȶ�Щ��
��Դ�����������ļ��� �����.exe ��? �����ʡ�
			����Ҫ��%1% ��� ˫����  �� qq = "%1%"
����д��ע���ʧ��ԭ��  360�����������
*/

writeahkurl(){
/*
appurl= "%A_AhkPath%" "%A_ScriptDir%\smartchooserbrowser.ahk" "`%1"

RegRead AhkURL, HKCR, Ahk.URL\shell\open\command
IfNotInString,AhkURL,smartchooserbrowser.ahk
{
	RegWrite, REG_SZ, HKCR, Ahk.URL
	RegWrite, REG_SZ, HKCR, Ahk.URL\shell,,open
	RegWrite, REG_SZ, HKCR, Ahk.URL\shell\open\command, ,%appurl%
}
*/

  appurl= "%A_ScriptDir%\Bin\smartchooserbrowser.exe" "`%1"

  RegRead AhkURL, HKCR, Ahk.URL\shell\open\command
  IfNotInString,AhkURL,smartchooserbrowser.exe
  {
	  RegWrite, REG_SZ, HKCR, Ahk.URL
	  RegWrite, REG_SZ, HKCR, Ahk.URL\shell,,open
	  RegWrite, REG_SZ, HKCR, Ahk.URL\shell\open\command, ,%appurl%
  }

  ; ����Ƿ���ڱ��ݣ������������ȡϵͳĬ�ϣ���ֹ�����˳���
  RegRead old_FTP, HKCU, Software\Microsoft\Windows\Shell\Associations\UrlAssociations\ftp\UserChoice, URL.LastFound
if ErrorLevel
	RegRead old_FTP, HKCU, Software\Microsoft\Windows\Shell\Associations\UrlAssociations\ftp\UserChoice, Progid

  RegRead old_HTTP, HKCU, Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice, URL.LastFound
if ErrorLevel
	RegRead old_HTTP, HKCU, Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice, Progid

  RegRead old_HTTPS, HKCU, Software\Microsoft\Windows\Shell\Associations\UrlAssociations\https\UserChoice, URL.LastFound
if ErrorLevel
	RegRead old_HTTPS, HKCU, Software\Microsoft\Windows\Shell\Associations\UrlAssociations\https\UserChoice, Progid

  ; д�뱸�����ã���ֹ�����˳���
  RegWrite REG_SZ, HKCU, Software\Microsoft\Windows\Shell\Associations\UrlAssociations\ftp\UserChoice, URL.LastFound, %old_FTP%
  RegWrite REG_SZ, HKCU, Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice, URL.LastFound, %old_HTTP%
  RegWrite REG_SZ, HKCU, Software\Microsoft\Windows\Shell\Associations\UrlAssociations\https\UserChoice, URL.LastFound, %old_HTTPS%

  ; ������ʱ��ֵ
  RegWrite REG_SZ, HKCU, Software\Microsoft\Windows\Shell\Associations\UrlAssociations\ftp\UserChoice, Progid, Ahk.URL
  RegWrite REG_SZ, HKCU, Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice, Progid, Ahk.URL
  RegWrite REG_SZ, HKCU, Software\Microsoft\Windows\Shell\Associations\UrlAssociations\https\UserChoice, Progid, Ahk.URL
}


delahkurl()
{
  RegRead old_FTP, HKCU, Software\Microsoft\Windows\Shell\Associations\UrlAssociations\ftp\UserChoice, URL.LastFound
  RegRead old_HTTP, HKCU, Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice, URL.LastFound
  RegRead old_HTTPS, HKCU, Software\Microsoft\Windows\Shell\Associations\UrlAssociations\https\UserChoice, URL.LastFound

  RegWrite REG_SZ, HKCU, Software\Microsoft\Windows\Shell\Associations\UrlAssociations\ftp\UserChoice, Progid, %old_FTP%
  RegWrite REG_SZ, HKCU, Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice, Progid, %old_HTTP%
  RegWrite REG_SZ, HKCU, Software\Microsoft\Windows\Shell\Associations\UrlAssociations\https\UserChoice, Progid, %old_HTTPS%

  ; ɾ����������
  RegDelete HKCU, Software\Microsoft\Windows\Shell\Associations\UrlAssociations\ftp\UserChoice, URL.LastFound
  RegDelete HKCU, Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice, URL.LastFound
  RegDelete HKCU, Software\Microsoft\Windows\Shell\Associations\UrlAssociations\https\UserChoice, URL.LastFound
}
