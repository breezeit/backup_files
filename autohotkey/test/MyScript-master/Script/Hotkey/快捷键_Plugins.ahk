;�ļ��������ļ���������
�ļ����������ļ�:
pppp:=GetCurrentFolder()
If(pppp)
{
	Old_ClipBoard := ClipboardAll    ;���ݼ�����
	Clipboard =                                  ;��ռ�����
	Clipboard := pppp
	run "%A_AhkPath%" "%A_ScriptDir%\Plugins\�ļ����������ļ�.ahk"
	Sleep,3000
	Clipboard := Old_ClipBoard        ;��ԭ������
	Old_ClipBoard =                          ;�����������
}
Return

;�����ļ����е�ĳ�����͵��ļ������Ƿ�����ַ�
�ļ��в����ַ�:
pppp:=GetCurrentFolder()
If InStr(FileExist(pppp), "D")
{
	IniWrite, % pppp, %run_iniFile%, �ļ��в����ַ�, ·��
	Run "%A_AhkPath%" "%A_ScriptDir%\Plugins\�ļ��в����ַ�.ahk"
}
Else
	Run "%A_AhkPath%" "%A_ScriptDir%\Plugins\�ļ��в����ַ�.ahk"
Return

;����Ѹ������
�°�Ѹ�׿�����������:
IfInString, Clipboard,://
{
	Run,"%A_AhkPath%" "%A_ScriptDir%\Plugins\�°�Ѹ�׿�����������.ahk" %Clipboard%
}
Else
{
	Old_ClipBoard := ClipboardAll
	Send, ^c
	Clipwait
	Run,%A_AhkPath% "%A_ScriptDir%\Plugins\�°�Ѹ�׿�����������.ahk" %Clipboard%
	Clipboard := Old_ClipBoard
	Old_ClipBoard = 
}
Return