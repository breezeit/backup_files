;Cando �ű��еĽ���ͳһʹ�ñ��66
66GuiClose:
66Guiescape:
	Gui,66:Destroy
	if deltts
	{
		SoundPlay, none
		FileDelete, %A_SCRIPTDIR%\Settings\tmp\tts.mp3
		dletts=0
	}
Return

Cando_���浽����:
	FileAppend,%CandySel%,%A_Desktop%\%A_Now%.txt
return

Cando_���沢����:
	FileDelete,%A_Desktop%\temp.ahk
	FileAppend,%CandySel%`r`n,%A_Desktop%\temp.ahk
	Run,%A_Desktop%\temp.ahk,%A_Desktop%
Return

Cando_10��U��A�������򽻻�:
FileMove,% ahklu,% ahklu ".bak"
sleep,500
FileMove,% ahkla,% ahklu
tooltipnum=10
loop,10{
toolTip,%tooltipnum%s
tooltipnum--
sleep,1000
}
toolTip
tooltipnum=
FileMove,% ahklu,% ahkla
sleep,500
FileMove,% ahklu ".bak",% ahklu
return

Cando_10��U��Basic�������򽻻�:
FileMove,% ahklu,% ahklu ".bak"
sleep,800
FileMove,% ahk,% ahklu
tooltipnum=10
loop,10{
toolTip,%tooltipnum%s
tooltipnum--
sleep,1000
}
toolTip
tooltipnum=
FileMove,% ahklu,% ahk
sleep,800
FileMove,% ahklu ".bak",% ahklu
return

cando_Ѹ������:
StringGetPos,zpos,CandySel,/,R
zpos++
StringTrimLeft,sFile,CandySel,%zpos%
try {
	thunder := ComObjCreate("ThunderAgent.Agent")
	thunder.AddTask( CandySel ;���ص�ַ
			       , sFile  ;����ļ���
			       , "N:\"  ;����Ŀ¼
			       , sFile  ;����ע��
			       , ""  ;���õ�ַ
			       , 1 ;��ʼģʽ
			       , true  ;ֻ��ԭʼ��ַ����
			       , 10 )  ;��ԭʼ��ַ�����߳���
	thunder.CommitTasks()
}
Return

Cando_����·�����Ի���:
ControlSetText , edit1, %CandySel%, ahk_class #32770
return