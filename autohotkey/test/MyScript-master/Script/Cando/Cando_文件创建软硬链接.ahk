Cando_�ļ�����������:
sPara=/S
gosub Cando_�ļ�������Ӳ����
return

Cando_�ļ�����Ӳ����:
sPara=/H
gosub Cando_�ļ�������Ӳ����
return

Cando_�ļ�������Ӳ����:
	SplitPath,CandySel, , , , , tempStr1
	DriveGet, tempStr, FS, %tempStr1%
	If (tempStr<>"NTFS") {
		Gui, +OwnDialogs
		MsgBox, 262192, ���̸�ʽ��ƥ��, ��ǰ���� %tempStr1% ���� NTFS �ļ�ϵͳ��ʽ���޷������ļ����ӣ�
		Return
	}
	Gui,9:Destroy
	Gui,9:Default
	Gui,Add,Text,x10 y17, ��������(&N)
	Gui,Add,Edit,x90 y15 w300 vSH_Name,
	Gui,Add,Text,x10 y48, ����Ŀ¼(&P)
	Gui,Add,Edit,x90 y46 w300 vSH_Path,
	Gui,Add,Text,x10 y79, Ŀ���ļ�(&T)
	Gui,Add,Edit,x90 y77 w300 vSHTG_Path,% CandySel
	Gui,Add,Button,x140 y110 w100 h25 Default gSH_OK, ȷ��(&S)
	Gui,Add,Button,x245 y110 w100 h25 gSH_Cancel, ȡ��(&X)
	SplitPath, CandySel, tempStr
If(sPara="/S")
		tempStr:="����ָ���ļ� [ " . tempStr . " ] �ķ���(��)����"
	Else
		tempStr:="����ָ���ļ� [ " . tempStr . " ] ��Ӳ����"
	Gui,show,,%tempStr%
Return

SH_OK:
	Gui,9:Default
	Gui,Submit,NoHide
	SH_Name:=Trim(SH_Name),SH_Path:=Trim(SH_Path,"\"),errFlag := 0
	If (SH_Name="")
		errFlag:=1, tempStr:="δ������������"
	If (errFlag=0) And (SH_Path="")
		errFlag:=2, tempStr:="δ������������Ŀ¼" 
	If (errFlag=0) And (RegexMatch(SH_Name, "[\\/:\*\?""<>\|]")>0)
		errFlag:=3, tempStr:="�������Ʋ��ð������������ַ���\ / : * \ ? "" < > |"
	If (errFlag=0) And (FileExist(SH_Path)="")
		errFlag:=4, tempStr:= "����Ŀ¼������"
	If (errFlag=0) And (FileExist(SHTG_Path)="") and  !InStr(FileExist(SHTG_Path), "D")
		errFlag:=5, tempStr:= "Ŀ���ļ�������"
	If ((errFlag=0) And (sPara="/S")) 
	{
		SplitPath,SH_Path, , , , , tempStr1
		DriveGet, tempStr, FS, %tempStr1%
		If (tempStr<>"NTFS")
			errFlag:=6, tempStr:= "�������ڴ��� " tempStr1 " ���� NTFS �ļ�ϵͳ��ʽ���޷������ļ�����"
	}
		If ((errFlag=0) And (sPara="/H")) 
	{
		SplitPath,SH_Path, , , , , tempStr1
		SplitPath,CandySel, , , , , tempStr2
		If (tempStr1 <> tempStr2)
			errFlag:=7, tempStr:="Ӳ������Ŀ���ļ�����ͬһ�̷����޷�����Ӳ����"
	}
	If (errFlag=0) 
	{
		Gui, Destroy
		If(sPara="/S")
			RunWait, %comspec% /c "mklink "%SH_Path%\%SH_Name%" "%SHTG_Path%" > "%A_Temp%\~MKLINK.TMP"",, Hide UseErrorLevel
		If(sPara="/H")
			RunWait, %comspec% /c "mklink /H "%SH_Path%\%SH_Name%" "%SHTG_Path%" > "%A_Temp%\~MKLINK.TMP"",, Hide UseErrorLevel
		If(ErrorLevel="ERROR")
			errFlag:=1
		Else 
		{
			FileReadLine, tempStr, %A_Temp%\~MKLINK.TMP, 1
			If (ErrorLevel)
				errFlag:=1
			Else
			{
				tempStr=%tempStr%
If(sPara="/S")
{
				If (tempStr<>"Ϊ " . SH_Path . "\" . SH_Name . " <<===>> " . SHTG_Path . " �����ķ�������")
					errFlag:=1
}
		If(sPara="/H")
{
				If (tempStr<>"Ϊ " . SH_Path . "\" . SH_Name . " <<===>> " . SHTG_Path . " ������Ӳ����")
					errFlag:=1
}
			}
		}
		FileDelete, %A_Temp%\~MKLINK.TMP


		Gui, +OwnDialogs
		If (errFlag=0)
			MsgBox, 262208, �����ļ����ӳɹ�, % "�ɹ������ļ����ӣ�`n����: " . SH_Path . "\" . SH_Name "`nָ��: " SHTG_Path
		Else
			MsgBox, 262192, ����, �����ļ����Ӵ�����������ԣ�
		Return
	} 
	Else 
	{
		Gui, +OwnDialogs
		MsgBox, 262192, �����ļ����Ӵ���, %tempStr%��
		If errFlag In 1,3
			GuiControl, Focus, SH_Name
		If errFlag In 2,4,6,7
			GuiControl, Focus, SH_Path
		Else If errFlag In 5
			GuiControl, Focus, SHTG_Path
	}
	errFlag:=tempStr:=tempStr1:=tempStr2:=""
Return

SH_Cancel:
	Gui,9:Destroy
Return