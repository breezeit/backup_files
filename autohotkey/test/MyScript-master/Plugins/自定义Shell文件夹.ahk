Gui, Add, Button,gLoadw,ˢ���б�(&R)
Gui, Add, Button, x+15 gEditVar, �༭��ֵ(&E)
Gui, Add, Button, x+15 gopenfolder, ��ת��Ŀ¼(&E)
Gui, Add, Button, x+15 gRegedit, ��ת��ע���(&O)
Gui, Add, Button, x+20 gAbout, ����(&A)
Gui, Add, ListView, xm Grid w600 h400 gListView vEV,Shell�ļ���|Ŀ¼·��
Gui,Show,,�Զ���User Shell Folders
Gui +resize

Gui 2:Add, Text,,Shell�ļ���
Gui 2:Add, Edit,vVarname w250
Gui 2:Add, Text,, Ŀ¼·��
Gui 2:Add, Edit,vVarvalue w250
Gui 2:Add, Button,x+5  gselectfile,&.
Gui 2:Add, Button,x10 gVarsave w280,д��ע���(&S)

Gui,2:+Owner1 +ToolWindow


WinW = 500
XPos1 := WinW  - 100
XPos2 := XPos1 + 40
Gui 3:Font,s14,Arial
text=�汾��1.0�� ��Autohotkey�ű��޸���env.ahk����;��ͨ���޸�ע����Զ���User Shell Folders.
Gui 3:+ToolWindow +AlwaysOnTop
Gui 3:Add, Text,vtext4 x%XPos2% y35 BackgroundTrans , %text%
Gui 3:Add, Text,x0 y5 w%winw% center, �Զ���User Shell Folders
GuiControlGet,Text4,3:Pos
Text4H+=10
Gui 3:Add, Text, vText1 w4024 h%Text4H% x-1524 y30
GuiControl,3:+0x12,Text1

Gosub,Loadw

Return

selectfile:
FileSelectfolder,tt,,,ѡ��Ŀ¼
GuiControl,, Varvalue, %tt%
GuiControl,choose,dir,%tt%
Return

GuiEscape:
GuiClose:
Critical
 ExitApp
return

GuiSize:
if A_EventInfo = 1
    return
GuiControl, Move, EV, % "H" . (A_GuiHeight - 45) . "W" . (A_GuiWidth - 20)
return

Loadw:
LV_Delete()
Loop,HKCU,Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders,1,0
{
    RegRead, value
    LV_Add("",A_LoopRegName,value)
    LV_ModifyCol()
}
return


Varsave:
Gui 2:Submit
RegWrite,REG_SZ,HKCU,Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders\,%varname%,%varvalue%
send,!R
Return

EditVar:
FocusedRowNumber := LV_GetNext(0, "F")
if not FocusedRowNumber
Return
else{
LV_GetText(varname, FocusedRowNumber, 1)
LV_GetText(varvalue, FocusedRowNumber, 2)
gui 2:show,,�༭��ֵ
}
GuiControl,2:,varname,% varname
GuiControl,2:,varvalue,% varvalue
GuiControl,2:disable,Varname
Return

openfolder:
FocusedRowNumber := LV_GetNext(0, "F")
if not FocusedRowNumber
Return
LV_GetText(varvalue, FocusedRowNumber, 2)
IfInString, varvalue, `%USERPROFILE`%
{
  EnvGet, Profile, USERPROFILE
  StringReplace,varvalue,varvalue,`% ,,1
  StringReplace,varvalue,varvalue,USERPROFILE,%Profile%
   }
Run, %varvalue% ;,,UseErrorLevel
Return

Regedit:
RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Applets\Regedit, LastKey, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders
Run, regedit.exe
Return

3GuiEscape:
3GuiClose:
    AboutX = 1
Return

About:
Gui 3:Show, w%WinW% h70, ����
XPos2 := WinW - 60
    GuiControl 3:Move, Text4, x%XPos2%
    Loop {
       GuiControl 3:Move, Text4,% "x" XPos2--
       GuiControlGet Text4, 3:Pos
       Sleep 10
       If (text4X + text4W < 0 || AboutX) {
          AboutX =
          Break
       }
    }
    Gui 3:Hide
Return

ListView:
if (A_GuiEvent = "DoubleClick")
{
LV_GetText(varname, A_EventInfo, 1)
LV_GetText(varvalue, A_EventInfo, 2)
gui 2:show,,�༭��ֵ
GuiControl,2:,varname,% varname
GuiControl,2:,varvalue,% varvalue
GuiControl,2:disable,Varname
}
return