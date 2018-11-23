GuiDropFiles_Begin:
	CoverControl(hComBoBox)
Return

GuiDropFiles_End:
	CoverControl()

	If GuiDropFiles_FileFullPath
	{
		MouseGetPos,,,,hwnd,2
		If hwnd in %hComBoBox%,%hComBoBoxEdit%
			Gosub ShowFileFullPath
		Else
			Gosub movedropfile
	}
Return

CoverControl(hwnd_CsvList = ""){
	static handler := {__New: "test"}
	static _ := new handler
	static HGUI2
	If !HGUI2{
		Gui,New,+LastFound +hwndHGUI2 -Caption +E0x20 +ToolWindow +AlwaysOnTop
		Gui,Color,00FF00
		Gui,1:Default
		WinSet,Transparent,50
	}

	If (hwnd_CsvList = ""){
		Gui,%HGUI2%:Cancel
		Return
	}

	WinGetPos,x,y,w,h,ahk_id %hwnd_CsvList%
	Gui,%HGUI2%:Show,X%x% Y%y% w%w% h%h% NA
}

ShowFileFullPath:
;�ɽ��û�ѡ���ѡ���Ϊ����Ŀ��λ�ö����Ǹ�ѡ������ơ����û��ѡ����Ŀ������ ComboBox ������༭���е�����
	GuiControl,,Dir,%GuiDropFiles_FileFullPath%
	GuiControl,Choose,Dir,%GuiDropFiles_FileFullPath%
Return

movedropfile:
	;���Ƚ�Ŀ���ļ�����ק������
	;�ж���ק���Ƿ����ļ���
	If InStr(FileExist(GuiDropFiles_FileFullPath),"D")
	{
		TargetFolder := GuiDropFiles_FileFullPath
		IniWrite,%TargetFolder%,%run_iniFile%,����,TargetFolder
		MsgBox,,,Ŀ���ļ�������Ϊ %TargetFolder% ��,3
		Return
	}
	FileFullPath:=GuiDropFiles_FileFullPath
	;�ָ��ļ�·��
	SplitPath,FileFullPath,FileName,,FileExtension,FileNameNoExt

	IfInString,FileNameNoExt,foo_
	{
		;�ļ������� foo_lick_1.0.3.zip  ���ƶ��� H:\foobar2000 v1.1.x\foo_lick
		StringGetPos,v_pos,FileNameNoExt,_,1
		StringLeft,FileNameNoExt,FileNameNoExt,%v_pos%

		TargetFile = H:\foobar2000 v1.1.x\%FileNameNoExt%\%FileName%
		IfNotExist,H:\foobar2000 v1.1.x\%FileNameNoExt%
			FileCreateDir,H:\foobar2000 v1.1.x\%FileNameNoExt%
		ifExist,%TargetFile%
		{
			MsgBox,ָ���ļ������Ѵ���ͬ���ļ�!
			Return
		}
		Else
		{
			;Run,%comspec% /c move "%A_LoopField%" "H:\foobar2000 v1.1.x\%FileNameNoExt%"
			FileMove,%FileFullPath%,H:\foobar2000 v1.1.x\%FileNameNoExt%
			Return
		}
	}
	If InStr(FileExist(TargetFolder),"D")
	{
	;��ͬ���ļ�ʱ���Զ��������ļ�
		TargetFile = %TargetFolder%\%FileName%
		ifExist,%TargetFile%
		{
			ind = 1
			Loop,100
			{
				TargetFile = %TargetFolder%\%FileNameNoExt%_(%ind%).%FileExtension%
				IfExist,%TargetFile%
				{
					ind += 1
					Continue
				}
				Else
				{
					;Run,%comspec% /c move "%A_LoopField%" "%TargetFile%"
					FileMove,%FileFullPath%,%TargetFile%
					TrayTip,�ƶ��ļ�,�ļ� %FileFullPath% �����������ƶ����ļ��� %TargetFolder% ��,2
					break
				}
			}
			return
		}
	; ��ͬ���ļ�ʱ�������ļ�
		Else
		{
			;Run,%comspec% /c move "%A_LoopField%" "%TargetFolder%"
			FileMove,%FileFullPath%,%TargetFolder%
			TrayTip,�ƶ��ļ�,�ļ� %FileFullPath% ���ƶ����ļ��� %TargetFolder% ��,2
		}
	}
	Else
	{
		TrayTip,�ƶ��ļ�,Ŀ���ļ���û�����ã��ļ������ƶ���`n���Ҫ�ƶ��ļ���������ק�ļ��е����ڻ�ѡ��һ���ļ��С�,5
	}
Return