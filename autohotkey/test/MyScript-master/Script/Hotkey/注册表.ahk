;#IfWinActive,ahk_class RegEdit_RegEdit
;!x::
ע�����·��:
ControlGet, hwnd, hwnd, , SysTreeView321,ע���༭��
ret:=TVPath_Get(hwnd, outPath)
if( ret = "")
{
StringGetPos,hpos,outPath,HKEY
StringTrimLeft, OutputVar, outPath, hpos
clipboard := OutputVar
TrayTip, ������,"%OutputVar%"�Ѿ����Ƶ������塣
SetTimer, RemoveTrayTip, 2500
}
Return
;#IfWinActive