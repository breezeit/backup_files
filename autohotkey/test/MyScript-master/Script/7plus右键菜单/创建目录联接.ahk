1008:
	sPara=/SRC
	SetTimer,����Ŀ¼����,-200
Return

1009:
	sPara=/DES
	SetTimer,����Ŀ¼����,-200
Return

����Ŀ¼����:
	Critical,On
	If(sPara="/SRC")
		Files := GetSelectedFiles()
	If(sPara="/DES") 
		Files:=GetCurrentFolder()
	If !Files
	{
		MsgBox,,,��ȡ�ļ�·��ʧ�ܡ�,3
		Return
	}
	Critical,Off
	SplitPath,Files, , , , , tempStr1
	DriveGet, tempStr, FS, %tempStr1%
	If (tempStr<>"NTFS") {
		Gui, +OwnDialogs
		MsgBox, 262192, ���̸�ʽ��ƥ��, ��ǰ���� %tempStr1% ���� NTFS �ļ�ϵͳ��ʽ���޷�����Ŀ¼���ӣ�
		Return
	}
	
	Gui,9:Destroy
	Gui,9:Default
	Gui,Add,Text,x10 y17, ��������(&N)
	Gui,Add,Edit,x90 y15 w250 vVL_Name,
	Gui,Add,Text,x10 y48, ����Ŀ¼(&P)
	Gui,Add,Edit,x90 y46 w250 vVL_Path,% temp:=((sPara="/DES")?Files:"")
	Gui,Add,Text,x10 y79, Ŀ��Ŀ¼(&T)
	Gui,Add,Edit,x90 y77 w250 vTG_Path,% temp:=((sPara="/SRC")?Files:"")
	Gui,Add,Button,x140 y110 w100 h25 Default gVL_OK, ȷ��(&S)
	Gui,Add,Button,x245 y110 w100 h25 gVL_Cancel, ȡ��(&X)
	If(sPara="/SRC")
	{
		GuiControl,disable,TG_Path
		If (StrLen(Files)=3) And (SubStr(Files, -1)=":\")
			tempStr:=Files
		Else
			SplitPath, Files, tempStr
		tempStr:="����ָ��Ŀ¼ [" . tempStr . "] ������"
	}
	Else
	{
		GuiControl,disable,VL_Path
		tempStr:="�ڵ�ǰλ�ô���Ŀ¼����"
	}
	Gui,show,,%tempStr%
Return

VL_OK:
	Gui,9:Default
	Gui,Submit,NoHide
	VL_Name:=Trim(VL_Name),VL_Path:=Trim(VL_Path,"\"),TG_Path:=Trim(TG_Path,"\"),errFlag := 0
	If (VL_Name="")
		errFlag:=1, tempStr:="δ������������"
	If (errFlag=0) And (VL_Path="")
		errFlag:=2, tempStr:="δ������������Ŀ¼" 
	If (errFlag=0) And (TG_Path="")
		errFlag:=3, tempStr:="δ����Ŀ��Ŀ¼" 
	If (errFlag=0) And (RegexMatch(VL_Name, "[\\/:\*\?""<>\|]")>0)
		errFlag:=4, tempStr:="�������Ʋ��ð������������ַ���\ / : * \ ? "" < > |"
	If (errFlag=0) And (FileExist(VL_Path)="")
		errFlag:=5, tempStr:= "����Ŀ¼������"
	If (errFlag=0) And (FileExist(TG_Path)="")
		errFlag:=6, tempStr:= "Ŀ��Ŀ¼������"
	If ((errFlag=0) And (sPara="/SRC")) 
	{
		SplitPath,VL_Path, , , , , tempStr1
		DriveGet, tempStr, FS, %tempStr1%
		If (tempStr<>"NTFS")
			errFlag:=7, tempStr:= "�������ڴ��� " tempStr1 " ���� NTFS �ļ�ϵͳ��ʽ���޷�����Ŀ¼����"
	}
		If ((errFlag=0) And (sPara="/DES")) 
	{
		SplitPath,TG_Path, , , , , tempStr1
		DriveGet, tempStr, FS, %tempStr1%
		If (tempStr<>"NTFS")
			errFlag:=8, tempStr:="����Ŀ¼���ڴ��� " tempStr1 " ���� NTFS �ļ�ϵͳ��ʽ���޷�����Ŀ¼����"
	}
	If (errFlag=0)
	{
		Gui, Destroy
		RunWait, %comspec% /c "mklink /j "%VL_Path%\%VL_Name%" "%TG_Path%" > "%A_Temp%\~MKLINK_DIR_SRC.TMP"",, Hide UseErrorLevel
		If(ErrorLevel="ERROR")
			errFlag:=1
		Else 
		{
			FileReadLine, tempStr, %A_Temp%\~MKLINK_DIR_SRC.TMP, 1
			If (ErrorLevel)
				errFlag:=1
			Else
			{
				tempStr=%tempStr%
				If (tempStr<>"Ϊ " . VL_Path . "\" . VL_Name . " <<===>> " . TG_Path . " ����������")
					errFlag:=1
			}
		}
		FileDelete, %A_Temp%\~MKLINK_DIR_SRC.TMP


		Gui, +OwnDialogs
		If (errFlag=0)
			MsgBox, 262208, ����Ŀ¼���ӳɹ�, % "�ɹ�����Ŀ¼���ӣ�`n����: " . VL_Path . "\" . VL_Name "`nָ��: " TG_Path
		Else
			MsgBox, 262192, ����, ����Ŀ¼���Ӵ�����������ԣ�
		Return
	} 
	Else 
	{
		Gui, +OwnDialogs
		MsgBox, 262192, ����Ŀ¼���Ӵ���, %tempStr%��
		If errFlag In 1,4
			GuiControl, Focus, VL_Name
		If errFlag In 2,5,7
			GuiControl, Focus, VL_Path
		Else If errFlag In 3,6,8
			GuiControl, Focus, TG_Path
	}
	errFlag:=tempStr:=""
Return

VL_Cancel:
9GuiClose:
9GuiEscape:
	Gui,9:Destroy
Return