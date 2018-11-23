; Script Information ===========================================================
; Name:         File String Search
; Description:  Search files for a specific string (Inspired by TLM)
;               https://autohotkey.com/boards/viewtopic.php?f=6&t=27299 
; AHK Version:  AHK_L 1.1.24.04 (Unicode 32-bit) - December 17, 2016
; OS Version:   Windows 2000+
; Language:     English - United States (en-US)
; Author:       Weston Campbell <westoncampbell@gmail.com>
; Filename:     StringSearch.ahk
; ==============================================================================

; Revision History =============================================================
; Revision 1 (2017-01-25)
; * Initial release
; ==============================================================================

; Auto-Execute =================================================================
#SingleInstance, Force ; Allow only one running instance of script
#Persistent ; Keep the script permanently running until terminated
#NoEnv ; Avoid checking empty variables for environment variables
#Warn ; Enable warnings to assist with detecting common errors
;#NoTrayIcon ; Disable the tray icon of the script
SendMode, Input ; The method for sending keystrokes and mouse clicks
SetWorkingDir, %A_ScriptDir% ; Set the working directory of the script
SetBatchLines, -1 ; The speed at which the lines of the script are executed
SetWinDelay, -1 ; The delay to occur after modifying a window
SetControlDelay, -1 ; The delay to occur after modifying a control
OnExit("OnUnload") ; Run a subroutine or function when exiting the script

return ; End automatic execution
; ==============================================================================

; Labels =======================================================================
ControlHandler:
    If (A_GuiControl = "ButtonDir") {
        FileSelectFolder, DirSel,,, Choose Directory...
        IfEqual, ErrorLevel, 1, return
        GuiControl,, EditDir, % DirSel
        GuiControl,choose,EditDir,% DirSel
    } Else If (A_GuiControl = "ButtonSearch") {
        Gui, Submit, NoHide
        GuiControl, Choose, Tab, 2
        LV_Delete()
        SB_SetText("������...", 1)
        SB_SetText("", 2)
        
        GuiControl, Disable, ButtonSearch
        GuiControl, Enable, ButtonStop
        
        
        Loop, Files, % EditDir "\" (EditType ? EditType : "*.*"), FR
        {
            Try FileRead, MatchRead, % A_LoopFileFullPath
            IfEqual, SearchStop, 1, Break
            StringReplace, MatchRead, MatchRead, % EditString, % EditString, UseErrorLevel
            IfEqual, ErrorLevel, 0, Continue
            LV_Add("", ErrorLevel, A_LoopFileFullPath)
            LV_ModifyCol(1, "AutoHdr")
            LV_ModifyCol(2, "AutoHdr")
            SB_SetText("`t`t���� " A_Index . " ���ļ�, (" LV_GetCount() "��ƥ��)", 2)
        }
        
        SearchStop := 0
        
        GuiControl, Disable, ButtonStop
        GuiControl, Enable, ButtonSearch
        GuiControl, Enable, OpenFileFullPath
        
        SB_SetText("ɨ�����", 1)
    } Else If (A_GuiControl = "ButtonStop") {
        SearchStop := 1
    }
return

OpenFileFullPath:
LV_GetText(FileFullPath, LV_GetNext("F"), 2)
If Fileexist(FileFullPath)
Run,% "explorer.exe /select," FileFullPath
else
msgbox,δѡ�л��ļ�������
Return

GuiEscape:
GuiClose:
ExitSub:
    ExitApp ; Terminate the script unconditionally
return
; ==============================================================================

; Functions ====================================================================
OnLoad() {
    Global ; Assume-global mode
    run_iniFile = %A_ScriptDir%\..\settings\setting.ini
    Static Init := OnLoad() ; Call function
   
    IniRead, EditDir, %run_iniFile%, �ļ��в����ַ�, ·��, %A_Space%
    IniRead, SEditDir, %run_iniFile%, �ļ��в����ַ�, �̶�����Ŀ¼, %A_Space%
    IniRead, EditType, %run_iniFile%, �ļ��в����ַ�, ����, %A_Space%
    IniRead, EditString, %run_iniFile%, �ļ��в����ַ�, �ַ�, %A_Space%

    SearchStop := 0
}

OnUnload(ExitReason, ExitCode) {
    Global ; Assume-global mode
    
    Gui, Submit, NoHide
    if EditDir <>
    IniWrite, % EditDir, %run_iniFile%, �ļ��в����ַ�, ·��
    IniWrite, % EditType, %run_iniFile%, �ļ��в����ַ�, ����
    IniWrite, % EditString, %run_iniFile%, �ļ��в����ַ�, �ַ�
}

GuiCreate() {
    Global ; Assume-global mode
    Static Init := GuiCreate() ; Call function
    If SEditDir not contains  %EditDir%
    EditDirList:=EditDir "|" SEditDir
    else
    EditDirList:=SEditDir
    Gui, +LastFound -Resize +HWNDhGui1
    Gui, Margin, 8, 8
    Gui, Add, Tab3, vTab, ����|�������

    Gui, Tab, 1
    Gui, Add, Text, w460 BackgroundTrans Section, Ŀ¼:
    Gui, Add, ComBoBox, y+10 w416 vEditDir, % EditDirList
    Gui, Add, Button, x+10 yp w34 hp vButtonDir gControlHandler, ...
    Gui, Add, Text, xs y+20 w460 BackgroundTrans, �ļ�����:
    Gui, Add, Edit, y+10 w460 vEditType, % EditType
    Gui, Add, Text, xs y+20 w460 BackgroundTrans, �ַ�:
    Gui, Add, Edit, y+10 w460 vEditString, % EditString
    GuiControl,choose,EditDir,% EditDir

    Gui, Tab, 2
    Gui, Add, ListView, w460 r10 vListView Grid, �ҵ�����|�ļ�·��

    Gui, Tab
    Gui, Add, Button, w80 h24 default vButtonSearch gControlHandler, ����   
    Gui, Add, Button, x+10 w80 h24 vButtonStop gControlHandler Disabled, ֹͣ
    Gui, Add, Button, x+10 w100 h24 vOpenFileFullPath gOpenFileFullPath Disabled, ���ļ�λ��    
    
    Gui, Add, StatusBar,,
    SB_SetParts(120)
    
    Gui, Show, AutoSize, �ļ��ַ�����
}
; ==============================================================================
