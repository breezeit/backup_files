Cando_ע�����ת:
;�滻�ִ��е�һ������ ��Ϊ"\"
StringReplace,CandySel,CandySel,`,%A_Space%,\
;�滻�ִ��е�һ��������Ϊ"\"
StringReplace,CandySel,CandySel,`, ,\
IfInString, CandySel,HKLM
{
   StringTrimLeft, cutCandySel, CandySel, 4
   CandySel := "HKEY_LOCAL_MACHINE" . cutCandySel
}
IfInString, CandySel,HKCR
{
   StringTrimLeft, cutCandySel, CandySel, 4
   CandySel := "HKEY_CLASSES_ROOT" . cutCandySel
}
IfInString, CandySel,HKCC
{
   StringTrimLeft, cutCandySel, CandySel, 4
   CandySel := "HKEY_CURRENT_CONFIG" . cutCandySel
}
IfInString, CandySel,HKCU
{
   StringTrimLeft, cutCandySel, CandySel, 4
   CandySel := "HKEY_CURRENT_USER" . cutCandySel
}
IfInString, CandySel,HKU
{
   StringTrimLeft, cutCandySel, CandySel, 3
   CandySel := "HKEY_USERS" . cutCandySel
}
;���ִ��е����С��ܡ�(ȫ��)�滻Ϊ��\������ǣ�
StringReplace,CandySel,CandySel,��,\,All
StringReplace,CandySel,CandySel,%A_Space%\,\,All
StringReplace,CandySel,CandySel,\%A_Space%,\,All

;���ִ��е����С�\\���滻Ϊ��\��
StringReplace,CandySel,CandySel,\\,\,All

IfWinExist, ע���༭�� ahk_class RegEdit_RegEdit
{
IfNotInString, CandySel, �����\
CandySel := "�����\" . CandySel
WinActivate, ע���༭��
ControlGet, hwnd, hwnd, , SysTreeView321, ע���༭��
TVPath_Set(hwnd, CandySel, matchPath)
}
Else
{
RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Applets\Regedit, LastKey, %CandySel%
Run, regedit.exe -m
}