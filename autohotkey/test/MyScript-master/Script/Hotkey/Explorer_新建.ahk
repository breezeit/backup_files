; Explorer Windows Manipulations - Sean
; http://www.autohotkey.com/forum/topic20701.html
; 7plus - fragman
; http://code.google.com/p/7plus/
; https://github.com/7plus/7plus

�½��ļ���:
IfWinActive,ahk_group ccc
{
	If(A_OSVersion="Win_XP" && !IsRenaming())
		CreateNewFolder()
	Else If !IsRenaming()
		Send ^+n
}
Return

�½��ı��ĵ�:
IfWinActive,ahk_group ccc
{
	if !IsRenaming()
		CreateNewTextFile()
}
return