/*
ԭ�ű��ѱ��޸�
���ƣ� F1���޸��ļ�������չ�����ļ�ʱ��(��Դ��������ǿ)
���ߣ� dule2859
���ӣ� http://forum.ahkbbs.cn/thread-979-1-1.html
*/

;#IfWinActive,ahk_group ccc
;F4::    ;;��F4�޸��ļ�����
�޸��ļ�����:
clipold = %Clipboard%
clipboard=
Send,^c
ClipWait, 0.5
if ErrorLevel
{
    clipboard=%clipold%
    IniRead,  failsendkey, %run_iniFile%,��ݼ�, �޸��ļ�����
    Send,{%failsendkey%}
    Return
}
files=%clipboard%
Clipboard=%clipold%
StringSplit,ary, files ,`n,`r
curpath = %ary1%
If ary0=1
{
      FileGetAttrib,attributes,%ary1%
      If ErrorLevel
      {
        MsgBox �ļ������ڻ�û�з���Ȩ��
        Return
      }
      IfNotInString, attributes ,D
      {
        Gosub,GuiSingleFile
        Return
      }
}
  Gosub,GuiMultiFile
Return
;#IfWinActive

GuiSingleFile:
Gui,6:Default
Gui,Destroy
Gui,Submit 
gui,+AlwaysOnTop +Owner +LastFound -MinimizeBox 
WinSetTitle,,,�ļ������޸�
Gui,Add,CheckBox,xm vReadOnly,ֻ��(&R)
Gui,Add,CheckBox,xp+100 yp vHidden,����(&H)
Gui,Add,CheckBox,xm vSystem vSystem,ϵͳ(&S)
Gui,Add,CheckBox,xp+100 yp vArchive,�浵(&A)
Gui,Add,Text,xm yp+30,�ļ�����
Gui,Add,Edit,xp+50  H20 W120 vname_no_ext
Gui,Add,Text,xm yp+30,��չ����
Gui,Add,Edit,xp+50 yp H20 W120 vExt
Gui,Add,Button,xm yp+30 W80 gRegOpenFile,��ע���
Gui,Add,Button,xp+100 yp W80 gFileChangeDate,�޸�����
Gui,Add,Button,xm yp+30 W80 gSingleInit,�����޸�
Gui,Add,Button,xp+100 yp W80 gSingleApply Default,ִ���޸�
Gosub,SingleInit
Gui,Show,W200 H180
Return

RegOpenFile:
Gui,Submit,NoHide
RegRead,var,HKCR,.%ext%
If ErrorLevel
    Return
RegWrite,REG_SZ,HKCU,Software\Microsoft\Windows\CurrentVersion\Applets\Regedit,Lastkey,HKEY_CLASSES_ROOT\.%ext%
run,regedit.exe
Return

SingleInit:
FileGetAttrib,attributes,%curpath%
IfInString, attributes, H
  GuiControl, ,Hidden,1
Else
  GuiControl, ,Hidden,0
IfInString, attributes, R
  GuiControl, ,ReadOnly,1
Else
  GuiControl, ,ReadOnly,0
IfInString, attributes, S
  GuiControl, ,System,1
Else
  GuiControl, ,System,0
IfInString, attributes, A
  GuiControl, ,Archive,1
Else
  GuiControl, ,Archive,0

/*
StringGetPos, i, curpath, \ ,R
StringLen,n,curpath
StringRight,fullname,curpath,n-i-1
StringGetPos, i, fullname, . ,R
StringLen,n,fullname
StringLeft,name,fullname,i
StringRight,ext,fullname,n-i-1
*/
SplitPath, curpath,,newpath, ext, name_no_ext

GuiControl,,name_no_ext,%name_no_ext%
GuiControl,,ext,%ext%
Return

SingleApply:
Gui,Submit
Gosub,GetAttributes
FileSetAttrib,%pattern%,%curpath%,1,1
;StringGetPos, i, curpath, \ ,R
;StringLeft,newpath,curpath,i
newpath2 =
if !ext
newpath2 = %newpath%\%name_no_ext%
newpath = %newpath%\%name_no_ext%.%ext%
If (newpath2 = curpath) or (newpath = curpath)
 {
  Gui,Destroy
  Return
 }
IfExist,%newpath%
  MsgBox,4112,����,��ͬ�ļ��Ѿ����ڣ�������ʧ�ܡ�,3
If(newpath != curpath) and !FileExist(newpath)
  FileMove,%curpath%,%newpath%,0
Gui,Destroy
Return

GetAttributes:
GuiControlGet,bool,,Hidden
If  bool
pattern =%pattern%+H
Else
pattern =%pattern%-H
GuiControlGet,bool,,ReadOnly
If  bool
pattern =%pattern%+R
Else
pattern =%pattern%-R
GuiControlGet,bool,,System
If  bool
pattern =%pattern%+S
Else
pattern =%pattern%-S
GuiControlGet,bool,,Archive
If  bool
pattern =%pattern%+A
Else
pattern =%pattern%-A
Return

FileChangeDate:
Gui,Destroy
Gui,Submit
gui, +AlwaysOnTop   +Owner +LastFound -MinimizeBox
WinSetTitle,,,�ļ�ʱ���޸�
Gui,Add,Radio,group xm+20 checked H20 Section  vOrder gGetTime,�޸�ʱ��
Gui,Add,Radio,xp+80 yp H20 gGetTime,����ʱ��
Gui,Add,Radio,xp+80 yp H20 gGetTime,����ʱ��
Gui, Add, DateTime, vMyDateTime xm+10 yp+30,'Date:' yyyy-MM-dd   'Time:' HH:mm:ss
Gui,Add,Button,xm+30 yp+30 gGetTime,�����޸�
Gui,Add,Button,xp+80 yp gCurTime,��ǰʱ��
Gui,Add,Button,xp+80 yp gFileSetTime Default,ִ���޸�
GoSub,GetTime
Gui,Show,W300 H100
Return

GetTime:
Gui,Submit,NoHide
if order=1
    timetype=M
else if order=2
    timetype=C
else
    timetype=A
FileGetTime,temptime,%curpath%,%timetype%
GuiControl,,MyDateTime,%temptime%
Return

CurTime:
GuiControl,,MyDateTime,%A_Now%
Return

FileSetTime:
Gui,Submit
if order=1
    timetype=M
else if order=2
    timetype=C
else
    timetype=A
FileSetTime,%MyDateTime%,%curpath%,%timetype%
If recurse = 1
{
  FileGetAttrib,attributes,%curpath%
  {
    IfInString, attributes ,D
      {
         Loop,%curpath%\*.*,1,1
          {
            FileSetTime,%MyDateTime%,%A_LoopFileFullPath%,%timetype%
          }
      }
  }
}
Return

GuiMultiFile:
Gui,6:Default
Gui,Destroy
Gui,Submit 
Gui,+AlwaysOnTop   +Owner +LastFound -MinimizeBox
WinSetTitle,,,�ļ������޸�
Gui,Add,CheckBox,xm vReadOnly,ֻ��(&R)
Gui,Add,CheckBox,xp+100 yp vHidden,����(&H)
Gui,Add,CheckBox,xm vSystem vSystem,ϵͳ(&S)
Gui,Add,CheckBox,xp+100 yp vArchive,�浵(&A)
Gui,Add,CheckBox,xm yp+25 vRecurse Checked,�Ƿ��޸�Ӧ�õ����ļ�
Gui,Add,Button,xm yp+20 W80 gShowFile,�鿴�ļ�
Gui,Add,Button,xp+100 yp W80 gMultiDate,�޸�����
Gui,Add,Button,xm yp+30 W80 gMultiInit,�����޸�
Gui,Add,Button,xp+100 yp W80 gMultiApply Default,ִ���޸�
Gosub,MultiInit
Gui,Show
Return

MultiInit:
FileGetAttrib,attributes,%ary1%
IfInString, attributes, H
  GuiControl, ,Hidden,1
Else
  GuiControl, ,Hidden,0
IfInString, attributes, R
  GuiControl, ,ReadOnly,1
Else
  GuiControl, ,ReadOnly,0
IfInString, attributes, S
  GuiControl, ,System,1
Else
  GuiControl, ,System,0
IfInString, attributes, A
  GuiControl, ,Archive,1
Else
  GuiControl, ,Archive,0
Return

ShowFile:
CF_ToolTip(files,1000)
Return

MultiDate:
Gui,6:Default
Gui,Destroy
Gui,Submit 
gui,+AlwaysOnTop   +Owner +LastFound -MinimizeBox
WinSetTitle,,,�ļ�ʱ���޸�
Gui,Add,Radio,group xm+20 checked H20 Section  vOrder gGetTime,�޸�ʱ��
Gui,Add,Radio,xp+80 yp H20 gGetTime,����ʱ��
Gui,Add,Radio,xp+80 yp H20 gGetTime,����ʱ��
Gui,Add,CheckBox,xm+20  H20 vRecurse Checked,�Ƿ��޸�Ӧ�õ����ļ�
Gui, Add, DateTime, vMyDateTime xm+10 yp+30,'Date:' yyyy-MM-dd   'Time:' HH:mm:ss
Gui,Add,Button,xm+30 yp+30 gGetTime,�����޸�
Gui,Add,Button,xp+80 yp gCurTime,��ǰʱ��
Gui,Add,Button,xp+80 yp gMultiSetTime Default,ִ���޸�
Gosub,GetTime
Gui,Show,W300 H120
Return

MultiSetTime:
Loop,%ary0%
{
  curpath := ary%A_Index%
  Gosub,FileSetTime
}
Return

MultiApply:
Gui,Submit
Gosub,GetAttributes
Loop,%ary0%
{
  curpath := ary%A_Index%
  FileSetAttrib,%pattern%,%curpath%
  If Recurse = 1
  {
    FileGetAttrib,attributes,%curpath%
    IfInString, attributes ,D
    {
      FileSetAttrib,%pattern%,%curpath%\*.*,1,1
    }
  }
}
Gui,Destroy
Return

6GuiClose:
6GuiEscape:
Gui,Destroy
Return

;��Դ������F2������ʱ��ԭ�����ܰ�Tab��ת����һ���ļ�
;#IfWinActive,ahk_group ccc
;!F2::
�޸��ļ�����չ��:
MouseGetPos,,, win
filerename:
clipold = %Clipboard%
clipboard=
Send,^c
ClipWait, 0.5
if ErrorLevel
{
    clipboard=%clipold%
    Return
}
files=%clipboard%
Clipboard=%clipold%
StringSplit,ary, files ,`n,`r
curpath = %ary1%
If ary0=1
{
      FileGetAttrib,attributes,%ary1%
      If ErrorLevel
      {
        MsgBox �ļ������ڻ�û�з���Ȩ��
        Return
      }
      IfNotInString, attributes ,D
      {
        Gosub,FilerenameGui
        Return
      }
}
Return
;#IfWinActive

FilerenameGui:
Gui,25:Default
Gui,Destroy
Gui,Submit 
gui,+AlwaysOnTop   +Owner +LastFound -MinimizeBox
WinSetTitle,,,�ļ����޸�
Gui,Add,Text,xm yp+10,�ļ�����
Gui,Add,Edit,xp+50  H20 W220 vname_no_ext
Gui,Add,Text,xm yp+30,��չ����
Gui,Add,Edit,xp+50 yp H20 W220 vExt
Gui,Add,Button,xm yp+30 W60 gFilePrex,��һ��(&P)
Gui,Add,Button,xm+70 yp W60 gFileNext,��һ��(&N)
Gui,Add,Button,xm+140 yp W100 gApplyOff Default,�޸�`&&�ر�(&S)
Gosub,SingleInit2
Gui,Show,W300 H100
Return

FilePrex:
Gosub,ApplyOff
WinActivate, ahk_id %win%
send,{Up}
Gosub,filerename
Return

FileNext:
Gosub,ApplyOff
WinActivate, ahk_id %win%
send,{Down}
Gosub,filerename
Return

SingleInit2:
SplitPath, curpath,,newpath, ext, name_no_ext

GuiControl,,name_no_ext,%name_no_ext%
GuiControl,,ext,%ext%
Return

ApplyOff:
Gui,Submit
charsToRemove =
(
\\
/
:
*
?
<
>
"
|
)

name_no_ext := RegExReplace(name_no_ext,"[" . charsToRemove . "]")
newpath2 =
if !ext
newpath2 = %newpath%\%name_no_ext%
newpath = %newpath%\%name_no_ext%.%ext%

If ((newpath = curpath) or (newpath2 = curpath))
{
Gui,Destroy
Return
}
IfExist,%newpath%
  MsgBox,4112,����,���ļ���%newpath%-%newpath%�Ѿ�����!,3
else
  FileMove,%curpath%,%newpath%,0
Gui,Destroy
Return

25GuiClose:
25GuiEscape:
Gui,Destroy
Return