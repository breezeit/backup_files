;��Դ Ahk QQȺ
Windy:
Label_Windy_Start_Inside:   ;�ڲ�������ڣ���Windy�����ڡ�#if��ģʽ�����С�
	Sksub_Clear_WindyVar()                ;ÿ��������ʱ�������������Windy�����õ��ı���
	MouseGetPos,  Windy_X,Windy_Y,Windy_CurWin_id,Windy_CurWin_ClassNN,                 ;��ǰ����µĴ���
	WinGet,        Windy_CurWin_Pid,PID,Ahk_ID %Windy_CurWin_id%                                ;��ǰ���ڵ�Pid
	WinGet,        Windy_CurWin_Fullpath,ProcessPath,Ahk_ID %Windy_CurWin_id%           ;��ǰ���ڵĽ���·��
	SplitPath,     Windy_CurWin_Fullpath,,Windy_CurWin_ParentPath,,Windy_CurWin_ProcName            ;��ǰ���ڵĽ������ƣ�������׺
	if (Windy_CurWin_ProcName="explorer")
		Windy_CurWin_FolderPath:=GetCurrentFolder()
	WinGetClass,  Windy_CurWin_Class, Ahk_ID %Windy_CurWin_id%                                ;��ǰ���ڵ�Class
	WinGetTitle,  Windy_CurWin_Title, Ahk_ID %Windy_CurWin_id%                                  ;��ǰ���ڵ�title

;[������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������]
;
; �۵���λ�ã��ж�����
;
;[������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������]
Label_Windy_Set_Pos_or_WinArea:
	;Gosub Label_Windy_The_Position        ;���̶ֹ���λ����

	If ( Windy_The_Position!="")  ;����ǹ̶�����
	{
		IniRead,Windy_Cmd,%Windy_Profile_Ini%,λ����,%Windy_The_Position%
		If(Windy_Cmd="Error") ; ���û�ж��壬�򿴿�AnyWindow�Ķ���
		{
			IfExist,%Windy_Profile_Dir%\λ����\%Windy_The_Position%.ini
			{
				Windy_Cmd:="menu|λ����|" Windy_The_Position
			}
			Else
				Return
		}
	}
	Else    ;�Ա��������Ի��������� �������       ;�ý��������л��ֶ���
	{
		;Windy_Window_Area:= Is_Title="Caption" ? "������" : ( SkSub_IsDialog( Windy_CurWin_id ) ?  "�Ի���" : "������")
		Windy_Window_Area:="������"

		IniRead,Windy_Disabled_Win,%Windy_Profile_Ini%,%Windy_Window_Area%,Windy_Disabled
		IfInString,Windy_Disabled_Win,%Windy_CurWin_ProcName%
		{
			MouseClick, Middle
			Return
		}
		Else
		{
			;������Windy.ini��[������]�²��ҽ�������Ӧ������
			Windy_Cmd:=SkSub_Regex_IniRead(Windy_Profile_Ini, Windy_Window_Area , "i)(^|\|)\Q" Windy_CurWin_ProcName "\E($|\|)")
			If(Windy_Cmd="Error") 
			{
				;���û�ж��壬�򿴿�Any�Ķ���
				IniRead,Windy_Cmd,%Windy_Profile_Ini%,%Windy_Window_Area%,Any
				If(Windy_Cmd="Error") ;���Anyû�ж��壬����ҡ������塱�ļ����µ��ļ�
				{
					IfExist,%Windy_Profile_Dir%\%Windy_Window_Area%\%Windy_CurWin_ProcName%.ini
					{
						Windy_Cmd:="menu|" Windy_CurWin_ProcName "|menu"
					}
					Else IfExist,%Windy_Profile_Dir%\%Windy_Window_Area%\Any.ini
					{
						Windy_Cmd:="menu|any|menu"
					}
					Else
						Return
				}
			}
		}
	}
	If !(RegExMatch(Windy_Cmd,"i)^Menu\|"))
	{
		Goto Label_Windy_RunCommand            ;�������menuָ�ֱ������Ӧ�ó���
	}

;[������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������]
;
; �������˵�
;
;[������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������]
Label_Windy_DrawMenu:
	Menu,Windymenubywannianshuyao,add
	Menu,Windymenubywannianshuyao,DeleteAll

	IniRead,Windy_IconDir,%Windy_Profile_Ini%,Windy_Settings,icons_path                           ;ͼ���ļ���λ��
	If Windy_The_Position!=      ;�й̶��ĵ�һ�У����ù̶��ĵ�һ�У����硰���ϲ���֮��
	{
		; �ӵ�һ�в˵���������ʾѡ�е����ݣ��ò˵����㿽��������
		Menu Windymenubywannianshuyao,Add,��%Windy_The_Position%��,Label_Windy_Editconfig
		Menu Windymenubywannianshuyao,Icon,��%Windy_The_Position%��,%Windy_IconDir%\Windyλ����\%Windy_The_Position%.ico,,%MenuIconSizeGlobal%
		Menu Windymenubywannianshuyao,Add
	}
	Else If Windy_CurWin_ProcName!=          ;���ѡ����ĳ�����ڣ���Ѹô������Ƽӵ���һ��
	{
		; �ӵ�һ�в˵���������ʾѡ�е����ݣ��ò˵����㿽��������
		Menu Windymenubywannianshuyao,Add,��%Windy_CurWin_ProcName%��,Label_Copy_WinPath_Windy
		Menu Windymenubywannianshuyao,icon,��%Windy_CurWin_ProcName%��,%Windy_CurWin_Fullpath%,,%MenuIconSizeGlobal%
		Menu Windymenubywannianshuyao,Add
	}

	StringSplit,WindyMenuFrom,Windy_Cmd,|    ; menu�Ķ��巽��Ϊ menu|�ļ���|����
	WindyMenu_ini:= WindyMenuFrom2="" ? Windy_Profile_Ini_NameNoext : WindyMenuFrom2
	WindyMenu_sec:= WindyMenuFrom3="" ? "Menu" : WindyMenuFrom3

	szMenuIdx:={}
	szMenuContent:={}
	szMenuWhichFile:={} 
	_GetMenuItem(Windy_Profile_Dir "\" Windy_Window_Area,WindyMenu_ini,WindyMenu_sec,"Windymenubywannianshuyao","")
	_DeleteSubMenus("Windymenubywannianshuyao")

	For,k,v in szMenuIdx
	{
		_CreateMenu(v,"Windymenubywannianshuyao","Label_Windy_HandleMenu")
	}
	MouseGetPos,WindyMenu_X, WindyMenu_Y
	MouseMove,WindyMenu_X,WindyMenu_Y,0
	MouseMove,WindyMenu_X,WindyMenu_Y,0
	Menu,Windymenubywannianshuyao,show
Return

;================�˵�����================================
Label_Windy_HandleMenu:
	If GetKeyState("Ctrl")			    ;[��סCtrl���ǽ�������]
	{
		Windy_ctrl_ini_fullpath:=Windy_Profile_Dir . "\" . Windy_Window_Area . "\" . szMenuWhichFile[ A_thisMenu "/" A_ThisMenuItem] . ".ini"
		Windy_Ctrl_Regex:="=\s*\Q" szMenuContent[ A_thisMenu "/" A_ThisMenuItem] "\E\s*$"
		SkSub_EditConfig(Windy_ctrl_ini_fullpath,Windy_Ctrl_Regex)
	}
	else
	{
		Windy_Cmd := szMenuContent[ A_thisMenu "/" A_ThisMenuItem]
		WindyError_From_Menu:=1
		Goto Label_Windy_RunCommand
	}
return

Label_Copy_WinPath_Windy:
	If GetKeyState("Ctrl")    ; [��סCtrl���ǽ�������]
		Goto Label_Windy_Editconfig
	Else
		Clipboard:=Windy_CurWin_Fullpath
Return

;[������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������]
;
; �ޱ����滻
;
;[������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������]
Label_Windy_RunCommand:
	;If(RegExMatch(Windy_Cmd,"i)^(clip\|)")) ;clip|��ͷ�����̫�����ˣ����ܲ�������ġ����
	;{
		;Goto Windo_Send_Clip
		;Return
	;}
	Windy_Cmd:=Sksub_EnvTrans(Windy_Cmd) ; �滻�Ա����Լ�ϵͳ����,Ini������~%��ʾһ��%,��Ȼ����~~%����ʾһ��ԭ���~%
	; ��ǰ���ڵ������Ϣ
	StringReplace,Windy_Cmd,Windy_Cmd,{Win:class}            ,%Windy_CurWin_class%,All
	StringReplace,Windy_Cmd,Windy_Cmd,{Win:FolderPath}            ,%Windy_CurWin_FolderPath%,All
	StringReplace,Windy_Cmd,Windy_Cmd,{Win:pid}              ,%Windy_CurWin_pids%,All
	StringReplace,Windy_Cmd,Windy_Cmd,{Win:id}                ,%Windy_CurWin_ids%,All
	StringReplace,Windy_Cmd,Windy_Cmd,{Win:title}             ,%Windy_CurWin_title%,All
	StringReplace,Windy_Cmd,Windy_Cmd,{Win:Windy_hide_winid} ,%Windy_CurWin_Windy_hide_winid%
	StringReplace,Windy_Cmd,Windy_Cmd,{Win:Processname} ,%Windy_CurWin_ProcName%,All
	StringReplace,Windy_Cmd,Windy_Cmd,{Win:Fullpath}         ,%Windy_CurWin_Fullpath%
	StringReplace,Windy_Cmd,Windy_Cmd,{Win:parentpath}     ,%Windy_CurWin_ParentPath%
	If RegexMatch(Windy_Cmd, "i)\{date\:.*\}")    ;ʱ��������巽��Ϊ:{date:yyyy_MM_dd} ð��:����Ĳ��ֿ������ⶨ��
	{
		Windy_Time_Mode:=RegExReplace(Windy_Cmd,"i).*\{date\:(.*?)\}.*","$1")
		FormatTime,Windy_Time_Formated,%A_now%,%Windy_Time_Mode%
		Windy_Cmd:=RegExReplace(Windy_Cmd,"i)\{date\:(.*?)\}",Windy_Time_Formated)
	}
;-----------------------------------------------------------------------------------------------------------------------------
	; �ر�Ĳ���:����prompt��ʾ���ֵ�input ����{Input:�������ӳ�ʱ�䣬��msΪ��λ},֧�ֶ��input����
	; ���Ҫ�������룬��д��{input:��ʾ����:hide}
	If RegexMatch(Windy_Cmd, "i)\{Input\:.*\}")
	{
		Windy_input_pos=1
		Windy_input_list:=
		While	Windy_input_pos :=	RegexMatch(Windy_Cmd, "i)\{input\:(.*?)\}", Windy_Input_m, Windy_input_pos+strlen(Windy_Input_m))
			Windy_input_list .=	(!Windy_input_list ? "" : chr(3)) Windy_Input_m
		Loop, parse, Windy_input_list, % chr(3)
		{
			Windy_Input_Prompt_and_type:= RegExReplace(A_LoopField,"i).*\{input\:(.*?)\}.*","$1")
			Windy_Is_Password:= Regexmatch(Windy_Input_Prompt_and_type,"i)\:hide$") ? "hide":""
			Windy_Input_Prompt:=Regexmatch(Windy_Input_Prompt_and_type,"i)\:hide$") ? RegExReplace(Windy_Input_Prompt_and_type,"i)\:hide$"):Windy_Input_Prompt_and_type
			Gui +LastFound +OwnDialogs +AlwaysOnTop
			InputBox, f_Input,Windy InputBox,`n%Windy_Input_Prompt% ,%Windy_Is_Password%, 285, 175,,,,,
			If ErrorLevel
				Return
			Else
				StringReplace,Windy_Cmd,Windy_Cmd,%A_LoopField%,%f_Input%
		}
	}
	;IfInString,Windy_Cmd,{Win:goodpath}
	;{
		;f_GoodPath:=SkSub_GoodPath(Windy_CurWin_id,Windy_CurWin_class,Windy_CurWin_title,Windy_CurWin_Pid,Windy_CurWin_ParentPath,Windy_CurWin_ProcName)
		;StringReplace,Windy_Cmd,Windy_Cmd,{Win:goodpath}    ,%f_GoodPath%
	;}

;[������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������]
;
; ���ռ�����
;
;[������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������]
	Windy_Cmd:=RegExReplace(Windy_Cmd,"~\|",Chr(3)) ;ע��ָ�������ԭ��|����~|����ת��
	StringSplit,Splitted_Windy_Cmd,Windy_Cmd,|  ,%A_Space%%A_Tab%  ;��ָ�����|�ָ�ָ���ĵ�һ����ָ��
	Splitted_Windy_Cmd1:=RegExReplace(Splitted_Windy_Cmd1,Chr(3),"|")
	Splitted_Windy_Cmd2:=RegExReplace(Splitted_Windy_Cmd2,Chr(3),"|")
	Splitted_Windy_Cmd3:=RegExReplace(Splitted_Windy_Cmd3,Chr(3),"|")


	If(RegExMatch(Windy_Cmd,"i)^(Config\|)")) ;�������Config|��ͷ�����Ǳ༭�����ļ�
	{
		for k,v in szMenuWhichfile
			Config_files .= v "`n"
		Sort, Config_files, U
		Loop ,parse, Config_files,`n
			SkSub_EditConfig(Windy_Profile_Dir . "\" . Windy_Window_Area . "\" . A_LoopField  . ".ini","")
		Windy_Ctrl_Regex:="i)(^\s*|\|)" Windy_CurWin_ProcName "(\||\s*)[^=]*="
		SkSub_EditConfig(Windy_Profile_Ini,Windy_Ctrl_Regex)
		return
	}
	Else If (RegExMatch(Windy_Cmd,"i)^(Windo\|)")) ;�������windo|��ͷ�������������ñ�ǩ
	{
		
		If IsLabel("Windo_" . Splitted_Windy_Cmd2)                  ; Windo_��ͷ�ı�ǩ
			Goto % "Windo_" . Splitted_Windy_Cmd2
		else If IsLabel(Splitted_Windy_Cmd2)                       ; ��ǩ
			Goto % Splitted_Windy_Cmd2
		Else
			Goto Label_Windy_ErrorHandle
	}
	Else If (RegExMatch(Windy_Cmd,"i)^(Winfunc\|)")) ;�������winfunc|��ͷ���������к���
	{
		if IsStingFunc(Splitted_Windy_Cmd2)
		{
			RunStingFunc(Splitted_Windy_Cmd2)
		return
		}
		else
			Goto Label_Windy_ErrorHandle
	}
	Else If (RegExMatch(Windy_Cmd,"i)^Wingo\|")) ;�������Wingo|��ͷ����������һЩ�ⲿahk���򣬷�������������ű����йҽ�
	{
		IfExist,%Splitted_Windy_Cmd2%
		{
			Run %ahk% "%Splitted_Windy_Cmd2% %Splitted_Windy_Cmd3%" ;�ⲿ��ahk����Σ����ahk���Դ�����
			Return
		}
		Else
			Goto Label_Windy_ErrorHandle
	}
	Else If (RegExMatch(Windy_Cmd,"i)^Keys\|"))  ;�������keys|��ͷ�����Ƿ����ȼ�
	{
		;SendInput {ctrl up}{shift up}{alt up}
		SendInput % RegExReplace(Windy_Cmd,"i)^keys\|\s?")
		return
	}
	Else If (RegExMatch(Windy_Cmd,"i)^SetClipBoard\|"))
	;�������ճ���嶯���������ǰ���{setclipboard:pure}{setclipboard:rich}��һ���������ָ��
	{
		Clipboard:=RegExReplace(Windy_Cmd,"i)^SetClipBoard\|\s?")
		return
	}
	Else If(RegExMatch(Windy_Cmd,"i)^(AlwaysOnTop\|)")) ;�������AlwaysOnTop|��ͷ�������ö���ǰ����
	{
		WinSet,AlwaysOnTop,,Ahk_ID %Windy_CurWin_id%
		return
	}
	Else If(RegExMatch(Windy_Cmd,"i)^(bottom\|)")) ;�������bottom|��ͷ��������ײ�
	{
		WinSet,Bottom,,Ahk_ID %Windy_CurWin_id%
		return
	}
	Else If(RegExMatch(Windy_Cmd,"i)^(Send\|)")) ;�������send|��ͷ�����Ƿ����ִ�
	{
		SendStr(Splitted_Windy_Cmd2)
		return
	}
	Else If (RegExMatch(Windy_Cmd,"i)^MsgBox\|"))  ;�������MsgBox|��ͷ�����Ƿ�һ����ʾ��
	{
		Gui +LastFound +OwnDialogs +AlwaysOnTop
		MsgBox %Splitted_Windy_Cmd2%
		return
	}
	Else If(RegExMatch(Windy_Cmd,"i)^(mute\|)")) ;�������mute|��ͷ������
	{
		Send {Volume_Mute}
		return
	}
	Else If(RegExMatch(Windy_Cmd,"i)^(open\|)")) ;�������open|��ͷ�������õ�ǰ�����Ŀ���ĵ�
	{
		Run % Windy_CurWin_Fullpath " " RegExReplace(Windy_Cmd,"i)^open\|")
		return
	}
	;Else If(RegExMatch(Windy_Cmd,"i)^(Cd\|)")) ;cd,���ǽ���·����ת
	;{
		;IfNotExist,%Splitted_Windy_Cmd2%
			;Return
		;SkSub_FolderJump(Splitted_Windy_Cmd2,Windy_CurWin_class,Windy_CurWin_id,Windy_CurWin_ProcName,Windy_CurWin_Fullpath)
	;}
	Else If(RegExMatch(Windy_Cmd,"i)^(tcmd\|)")) ;�������tcmd��ͷ,����
	{
		PostMessage 1075, %Splitted_Windy_Cmd2%, 0, , ahk_class TTOTAL_CMD
		return
	}
	;Else If(RegExMatch(Windy_Cmd,"i)^(hide\|)")) ;�������hide|��ͷ���������ص�ǰ����
	;{
		;Goto Windo_HideWin
	;}
	;Else If(RegExMatch(Windy_Cmd,"i)^(unhide\|)")) ;�������UnHide|��ͷ��������ʾ�����صĴ���
	;{
		;Goto Windo_UnHideWin
	;}
	;Else If(RegExMatch(Windy_Cmd,"i)^(unhideAll\|)")) ;�������UnHideAll|��ͷ�������õ�ǰ�����Ŀ���ĵ�
	;{
		;Goto Windo_UnHideWinAll
	;}
	Else If(RegExMatch(Windy_Cmd,"i)^(Close\|)")) ;�������Close|��ͷ�������õ�ǰ�����Ŀ���ĵ�
	{
		Windy_win_closed:=Windy_CurWin_cmdline
		WinClose Ahk_ID %Windy_CurWin_id%
		Return
	}
	Else If(RegExMatch(Windy_Cmd,"i)^(UnClose\|)")) ;�������Close|��ͷ�������õ�ǰ�����Ŀ���ĵ�
	{
		Run %Windy_win_closed%
		Return
	}
	Else If(RegExMatch(Windy_Cmd,"i)^(CloseAll\|)")) ;�������CloseAll|��ͷ��
	{
		GroupAdd,classgroup,Ahk_Class %Windy_CurWin_class%
		GroupClose,classgroup,a
		Return
	}
	Else If(RegExMatch(Windy_Cmd,"i)^(kill\|)")) ;�������kill|��ͷ
	{
		PostMessage, 0x12, 0, 0, , ahk_id %Windy_CurWin_id%
		;Run,taskkill /f /pid %Windy_CurWin_pid%,,UseErrorLevel Hide
		Return
	}
	Else If(RegExMatch(Windy_Cmd,"i)^(exit\|)")) ;�������exit|��ͷ�������˳���ǰ����
	{
		ExitApp
	}
	Else If(RegExMatch(Windy_Cmd,"i)^((roc|RunOrClose)\|)")) ;�������Run Or Close ��ͷ,�������л��߹ر�
	{
		SplitPath,Splitted_Windy_Cmd2,prcvName,,
		Process,exist,%prcvName%
		If ErrorLevel
		{
			Process,Close,%prcvName%
			return
		}
		Else
		{
			Run,%Splitted_Windy_Cmd2%,%Splitted_Windy_Cmd3%,%Splitted_Windy_Cmd4% UseErrorLevel,Windy_app_Pid
			WinWait, Ahk_PID %Windy_Pid_TempA%,,3
			WinActivate,Ahk_PID %Windy_Pid_TempA%
			return
		}
	}
	Else If(RegExMatch(Windy_Cmd,"i)^((roa|RunOrActivate)\|)")) ;�������Run Or activate ��ͷ,�������л��߼���
	{
		SplitPath,Splitted_Windy_Cmd2,prcvName,,
		Process,exist,%prcvName%
		If ErrorLevel
		{
			WinActivate,Ahk_PID %ErrorLevel%
			return
		}
		Else
		{
			Run,%Splitted_Windy_Cmd2%,%Splitted_Windy_Cmd3%,%Splitted_Windy_Cmd4% UseErrorLevel,Windy_app_Pid
			WinWait, Ahk_PID %Windy_Pid_TempA%,,3
			WinActivate,Ahk_PID %Windy_Pid_TempA%
			return
		}
	}
	Else If(RegExMatch(Windy_Cmd,"i)^((rot|RunOntop)\|)")) ;�������run��ͷ,�����������ö�
	{
		SplitPath,Splitted_Windy_Cmd2,prcvName,,
		Run,%Splitted_Windy_Cmd2%,%Splitted_Windy_Cmd3%,%Splitted_Windy_Cmd4% UseErrorLevel,Windy_app_Pid
		If (ErrorLevel = "Error")               ;������г���Ļ�
			Goto Label_Windy_ErrorHandle
		WinWait, Ahk_PID %Windy_app_Pid%,,3
		WinSet, AlwaysOnTop
		return
	}
	Else If(RegExMatch(Windy_Cmd,"i)^(run\|)"))
	{
		Run,%Splitted_Windy_Cmd2%,%Splitted_Windy_Cmd3%,%Splitted_Windy_Cmd4% UseErrorLevel,Windy_Pid_TempB
		If (ErrorLevel = "Error")               ;������г���Ļ�
			Goto Label_Windy_ErrorHandle
		WinWait, Ahk_PID %Windy_Pid_TempB%,,3
		WinActivate,Ahk_PID %Windy_Pid_TempB%
		return
	}
	Else
	{
		Run,%Splitted_Windy_Cmd1%,%Splitted_Windy_Cmd2%,%Splitted_Windy_Cmd3% UseErrorLevel,Windy_Pid_TempB
		If (ErrorLevel = "Error")               ;������г���Ļ�
			Goto Label_Windy_ErrorHandle
		WinWait, Ahk_PID %Windy_Pid_TempB%,,3
		WinActivate,Ahk_PID %Windy_Pid_TempB%
	}
Return

_CreateMenu(Item,ParentMenuName,label)    ;��Ŀ���������ĸ��˵������˵������Ŀ���ǩ
{  ;�ͽ�����Item�Ѿ������ˡ�ȥ�ո���������ʹ��
;��ȡ����ͼ��ᱨ���������һ�з�ֹ����
    Menu, tray,UseErrorLevel
    arrS:=StrSplit(Item,"/"," `t")
    _s:=arrS[1]
    if arrS.Maxindex()= 1      ;�������û�� /���������յġ��˵������ӵ������ĸ��˵����ϡ�
    {
        If InStr(_s,"-") = 1       ;-�ָ���
        Menu, %ParentMenuName%, Add
        Else If InStr(_s,"*") = 1       ;* �Ҳ˵�
        {
            _s:=Ltrim(_s,"*")
            Menu, %ParentMenuName%, Add,       %_s%,%Label%
            Menu, %ParentMenuName%, Disable,  %_s%
        }
        Else
        {
            y:=szMenuContent[ ParentMenuName "/" Item]
            Menu, %ParentMenuName%, Add,  %_s%,%Label%
        }
    }
    Else     ;�����/��˵�����������յĲ˵������һ��һ��ֲ�������
    {
        _Sub_ParentName=%ParentMenuName%/%_s%
        StringTrimLeft,_subItem,Item,strlen(_s)+1
        _CreateMenu(_subItem,_Sub_ParentName,label)
        Menu,%ParentMenuName%,add,%_s%,:%_Sub_ParentName%
    }
}

_GetMenuItem(IniDir,IniNameNoExt,Sec,TopRootMenuName,Parent="")   ;��һ��ini��ĳ���λ�ȡ��Ŀ���������ɲ˵���
{
    Items:=CF_IniRead_Section(IniDir "\" IniNameNoExt ".ini",sec)         ;���β˵��ķ����
    StringReplace,Items,Items,��,`t,all
    Loop,parse,Items,`n
    {
        Left:=RegExReplace(A_LoopField,"(?<=\/)\s+|\s+(?=\/)|^\s+|(|\s+)=[^!]*[^>]*")
        Right:=RegExReplace(A_LoopField,"^.*?\=\s*(.*)\s*$","$1")
        If (RegExMatch(left,"^/|//|/$|^$")) ;������Ҷ���/�������������/�����ߴ���//������һ������Ķ��壬����
            Continue
        If RegExMatch(Left,"i)(^|/)\+$")   ;�����ߵ���ĩ���ǽ���һ��"������" + ��
        {
            m_Parent := InStr(Left,"/") > 0 ? RegExReplace(Left,"/[^/]*$") "/" : ""  ;���+��ǰ���д����ϼ��˵�,�����ϼ��˵�������û��
            Right:=RegExReplace(Right,"~\|",Chr(3))
            arrRight:=StrSplit(Right,"|"," `t")
            rr1:=arrRight[1]
            rr2:=RegExReplace(arrRight[2],Chr(3),"|")
            rr3:=RegExReplace(arrRight[3],Chr(3),"|")
            rr4:=RegExReplace(arrRight[4],Chr(3),"|")
            If (rr1="Menu")   ;��������ǡ����루�ӣ��˵��������� �����п��ܲ˵����滹�С�Ƕ�׵��¼��˵�������
            {
                m_ini:= (rr2="") ? IniNameNoExt :  rr2
                m_sec:= (rr3="") ? "Menu" : rr3
				m_Parent:=Parent "" m_Parent
                this:=_GetMenuItem(IniDir,m_ini,m_sec,TopRootMenuName,m_Parent)      ;Ƕ�ף�ѭ��ʹ�ô˺������Ա㴦�������ļ���ģ�����Ĳ˵���
            }
;             ��+�ķ������������������չ�Լ�������Ӳ˵�������ֱ�ӿ���д������ˡ�
        }
        Else
        {
            szMenuIdx.Push( Parent ""  Left )
            szMenuContent[ TopRootMenuName "/" Parent "" Left] := Right
            szMenuWhichFile[ TopRootMenuName "/" Parent "" Left] :=IniNameNoExt
        }
    }
}

_DeleteSubMenus(TopRootMenuName)
{
    For i,v in szMenuIdx
    {
        If instr(v,"/")>0
        {
            Item:=RegExReplace(v, "(.*)/.*", "$1")
            Menu,%TopRootMenuName%/%Item%,add
            Menu,%TopRootMenuName%/%Item%,DeleteAll
        }
    }
}

Sksub_Clear_WindyVar()
{
Windy_X:=Windy_Y:=Windy_CurWin_id:=Windy_CurWin_ClassNN:=Windy_CurWin_Pid:=Config_files:=
WindyError_From_Menu:=0
}

Label_Windy_Editconfig:
        Windy_Ctrl_Regex:="i)(^\s*|\|)" Windy_CurWin_ProcName "(\||\s*)[^=]*="
        SkSub_EditConfig(Windy_Profile_Ini,Windy_Ctrl_Regex)
return

Label_Windy_ErrorHandle:
		Gui +LastFound +OwnDialogs +AlwaysOnTop
        MsgBox, 4116,, ���������ж������ `n---------------------`n%Windy_Cmd%`n---------------------`n������: %Windy_CurWin_ProcName%`n`n����������Ӧini��
		IfMsgBox Yes
		{
            if (WindyError_From_Menu=1)
            {
                Windy_This_ini:=szMenuWhichFile[ A_thisMenu "/" A_ThisMenuItem]
                Windy_ctrl_ini_fullpath:=Windy_Profile_Dir . "\" . Windy_Window_Area . "\" . Windy_This_ini . ".ini"
                Windy_Ctrl_Regex:= "=\s*\Q" szMenuContent[ A_thisMenu "/" A_ThisMenuItem] "\E\s*$"
                SkSub_EditConfig(Windy_ctrl_ini_fullpath,Windy_Ctrl_Regex)
            }
            else
            {
                Windy_Ctrl_Regex:="i)(^\s*|\|)" Windy_CurWin_ProcName "(\||\s*)[^=]*="
                SkSub_EditConfig(Windy_Profile_Ini,Windy_Ctrl_Regex)
            }
		}
	Return