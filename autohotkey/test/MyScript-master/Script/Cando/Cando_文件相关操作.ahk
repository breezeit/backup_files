Cando_С˵����:
FileReadLine,x,%CandySel%,1
FileMove,%CandySel%,%CandySel_ParentPath%\%x%.txt
Return

Cando_�ϲ��ı��ļ�:
	loop, parse, CandySel, `n,`r
	{
		SplitPath, A_LoopField, , , ext, ,
		If(ext="txt"||ext="ahk"||ext="ini")
		{
			Fileread, text, %A_loopfield%
			all_text=%all_text%%A_loopfield%`r`n`r`n%text%`r`n`r`n
		}
	}
	FileAppend, %all_text%, %A_Desktop%\�ϲ�.txt
Return

Cando_�ļ��б�:
   ; dateCut := A_Now
   ; EnvAdd, dateCut, -1, days       ; sets a date -24 hours from now
   �б�������ļ�=%A_Temp%\���������ļ��б���ʱ�ļ�_%A_now%.txt
;    MsgBox %CandySel%
   loop, %CandySel%\*.*, 1, 1   ; change the folder name
   {
   ;    if (A_LoopFileTimeModified >= dateCut)
         str .= A_LoopFileFullPath "`n"
   }
   FileAppend,%str%,%�б�������ļ�%
;    Sleep,50
   Run,notepad.exe %�б�������ļ�%
   Return

Cando_�����ļ���:
SwapName(CandySel)
Return

Swapname(Filelist)
{
	StringSplit,File_,Filelist,`n
	SplitPath,File_1,FN1,Dir
	SplitPath,File_2,FN2
	RunWait,%ComSpec% /c ren `"%File_1%`" `"temp`",,Hide
	RunWait,%ComSpec% /c ren `"%File_2%`" `"%FN1%`",,Hide
	RunWait,%ComSpec% /c ren `"%Dir%\temp`" `"%FN2%`",,Hide
	return,0
	}

cando_���ļ������ļ���:
clip := ""
Loop, Parse, CandySel, `n,`r 
{
SplitPath, A_LoopField,outfilename
clip .= (clip = "" ? "" : "`r`n") outfilename
}
clipboard:=clip
	return

cando_���ļ�����·��:
clip := ""
Loop, Parse, CandySel, `n,`r 
{
SplitPath, A_LoopField,outfilename
clip .= (clip = "" ? "" : "`r`n") outfilename
}
clipboard:=clip
	return

Cando_���ɿ�ݷ�ʽ:
FileCreateShortcut,%CandySel%,%CandySel_ParentPath%\%CandySel_FileNameNoExt%.lnk
    Return

Cando_���ɿ�ݷ�ʽ��ָ��Ŀ¼:
	Gui,66:Destroy
	Gui,66:Default
	Gui,Add,Text,x10 y17, Ŀ���ļ�(&T)
	Gui,Add,Edit,x110 y15 w300 readonly vSHLTG_Path,% CandySel
	Gui,Add,Text,x10 y48, ��ݷ�ʽĿ¼(&P)
	Gui,Add,Edit,x110 y46 w300 vSHL_Path,
	Gui,Add,CheckBox,x20 y70 w50 h30 vSHL_Desktop,����
	Gui,Add,CheckBox,x90 y70 w80 h30 vSHL_QL,����������
	Gui,Add,CheckBox,x180 y70 w80 h30 vSHL_Fav,�ű��ղؼ�
	Gui,Add,Text,x10 y110, ��ݷ�ʽ����(&N)
	Gui,Add,Edit,x110 y108 w300 vSHL_Name,%CandySel_FileNameNoExt%
	Gui,Add,Button,x220 y140 w80 h25 Default gSHL_OK, ȷ��(&S)
	Gui,Add,Button,x320 y140 w80 h25 g66GuiClose, ȡ��(&X)
	Gui,show,,Ϊ�ļ�[%CandySel_FileNameWithExt%]������ݷ�ʽ
Return

SHL_OK:
	Gui,66:Default
	Gui,Submit,NoHide
	SHL_Name:=Trim(SHL_Name),SHL_Path:=Trim(SHL_Path,"\"),errFlag := 0
	If (SHL_Name="")
		errFlag:=1, tempStr:="δ���ÿ�ݷ�ʽ����"
	If (errFlag=0) And (RegexMatch(SHL_Name, "[\\/:\*\?""<>\|]")>0)
		errFlag:=2, tempStr:="��ݷ�ʽ���Ʋ��ð������������ַ���\ / : * \ ? "" < > |"
	If (errFlag=0) And (SHL_Path !="") And !InStr(FileExist(SHL_Path), "D")
		errFlag:=3, tempStr:= "��ݷ�ʽĿ¼������"
	If (errFlag=0) And (FileExist(SHLTG_Path)="")
		errFlag:=4, tempStr:= "Ŀ���ļ�������"
	If (errFlag=0) 
	{
		Gui, Destroy
		if (SHL_Path !="")
			FileCreateShortcut, % SHLTG_Path,%SHL_Path%\%SHL_Name%.lnk
		if SHL_Desktop
			FileCreateShortcut, % SHLTG_Path,%A_desktop%\%SHL_Name%.lnk
		if SHL_QL
			FileCreateShortcut, % SHLTG_Path,%A_AppData%\Microsoft\Internet Explorer\Quick Launch\%SHL_Name%.lnk
		if SHL_Fav
			FileCreateShortcut, % SHLTG_Path,%A_ScriptDir%\favorites\%SHL_Name%.lnk
	}
	Else 
	{
		Gui, +OwnDialogs
		MsgBox, 262192, ������ݷ�ʽ����, %tempStr%��
		If errFlag In 1,2
			GuiControl, Focus, SHL_Name
		If errFlag In 3
			GuiControl, Focus, SHL_Path
		If errFlag In 4
			GuiControl, Focus, SHLTG_Path
}
	errFlag:=tempStr:=SHLTG_Path:=SHL_Name:=SHL_Path:=""
return