#NoEnv
SetBatchLines -1
ListLines Off
Sys=HKLM
sys1=HKEY_LOCAL_MACHINE

Menu, Context, Add, ����ļ�λ��, PlayLV

Gui, Add, Button,gLoadw,ˢ���б�(&R)
Gui, Add, Button, x+15 gEditVar, �༭/������Ŀ(&C)
Gui, Add, Button, x+15 gDelVar, ɾ������Ŀ(&D)
Gui, Add, Button, x+15 gUser, �л����û�/ϵͳ(&U)
Gui, Add, Button, x+15 gRegedit, ��ת��ע���(&O)
Gui, Add, Button, x+20 gAbout, ����(&A)
Gui, Add, ListView, xm Grid w600 h400 gListView vEV Altsubmit,�Զ�������|·��|���
Gui, +AlwaysOnTop
Gui,Show,,�Զ�����������
Gui +resize

Gui 2:Add, Text,,��Ŀ����
Gui 2:Add, Edit,vVarname w250
Gui 2:Add, Text,, ����·��
Gui 2:Add, Edit,vVarvalue w250
Gui 2:Add, Button,x+5  gselectfile,&.
Gui 2:Add, Button,x10 gVarsave w280,д��ע���(&S)

Gui,2:+Owner1 +ToolWindow +AlwaysOnTop


WinW = 500
XPos1 := WinW  - 100
XPos2 := XPos1 + 40
Gui 3:Font,s14,Arial
text=�汾��1.0�� ��Autohotkey�ű��޸���env.ahk����;��ͨ���޸�ע����Զ��塰���С����"����"�������Զ���������ٴ򿪳���
Gui 3:+ToolWindow +AlwaysOnTop
Gui 3:Add, Text,vtext4 x%XPos2% y35 BackgroundTrans , %text%
Gui 3:Add, Text,x0 y5 w%winw% center, �Զ�����������
GuiControlGet,Text4,3:Pos
Text4H+=10
Gui 3:Add, Text, vText1 w4024 h%Text4H% x-1524 y30
GuiControl,3:+0x12,Text1

Gosub,Loadw
Return

selectfile:
FileSelectFile,tt,,,ѡ���ļ�
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
Loop,%Sys%,SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths,0,1
{
    RegRead, value
    IfNotInString, value,.exe
    Continue
    StringGetPos,num,A_LoopRegSubKey,\,R
    num++
    StringTrimLeft,syskey,A_LoopRegSubKey,%num%
    LV_Add("",syskey,value,"���")
    LV_ModifyCol()
}
return

Varsave:
Gui 2:Submit
RegWrite,REG_SZ,%Sys%,SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\%varname%,,%varvalue%
WinActivate,Environment Variables Editor
send,!R
Return

EditVar:
FocusedRowNumber := LV_GetNext(0, "F")
if not FocusedRowNumber
{
gui 2:show,,�����µ���Ŀ
varname=
varvalue=
}
else{
LV_GetText(varname, FocusedRowNumber, 1)
LV_GetText(varvalue, FocusedRowNumber, 2)
gui 2:show,,�༭��������
}
GuiControl,2:,varname,% varname
GuiControl,2:,varvalue,% varvalue
Return

DelVar:
FocusedRowNumber := LV_GetNext(0, "F")
if not FocusedRowNumber
   {
    MsgBox,,����,δѡ��Ҫɾ������Ŀ��
    Return
}
Else{
LV_GetText(varname, FocusedRowNumber, 1)
MsgBox,4129,����,�Ƿ�ȷ��ɾ��"%varname%"�����Ŀ���ò����޷������������ء�
IfMsgBox,Yes
{
    RegDelete,%Sys%,SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\%varname%
sleep,1000
Gosub,loadw
}
}
Return

Regedit:
RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Applets\Regedit, LastKey, %Sys1%\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths
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
       Sleep 1
       If (text4X + text4W < 0 || AboutX) {
          AboutX =
          Break
       }
    }
    Gui 3:Hide
Return

User:
if Sys=HKLM
{
Sys=HKCU
sys1=HKEY_CURRENT_USER
}
Else
{
Sys=HKLM
sys1=HKEY_LOCAL_MACHINE
}
Gosub,Loadw
Return

ListView:
if (A_GuiEvent = "RightClick")
{
	rrownum:=A_EventInfo
	Menu, Context, Show
}
else if (A_GuiEvent = "DoubleClick")
	gosub,EditVar
return

PlayLV:
LV_GetText(Mdir, rrownum, 2)
abcd=explorer.exe /select, "%Mdir%"
Transform,abcd,Deref,%abcd%
Run,%abcd%
return