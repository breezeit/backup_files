;Ŀ���ļ��е��ļ��б�
liebiao:
if !TargetFolder or !FileExist(TargetFolder)
{
TargetFolder=
IniWrite,%TargetFolder%, %run_iniFile%,����, TargetFolder
msgbox,û������Ŀ���ļ��У�����ק�ļ��е����ڻ�ѡ��һ���ļ��С�
return
}

rootdir := TargetFolder       ;��ݷ�ʽĿ¼
updatealways =1      ;1�Զ�ˢ�£�0��ֹ�Զ�ˢ��
SetTimer,ini,500
TrayTip,Ŀ¼�˵�,��ʼ��������
if updatealways = 1
   gosub createdatabase
else
{
ifnotexist %A_ScriptDir%\settings\tmp\folderlist.txt
   gosub, createdatabase
}

if !C_error
{
Menu,DirMenu,add,%rootdir%,godir
Menu,DirMenu,disable,%rootdir%
Menu,DirMenu,add,-`:`:�� Ŀ¼`:`:-,godir
goto createmenu
}
C_error=0
return

CreateMenu:
Loop, Read, %A_ScriptDir%\settings\tmp\folderlist.txt
{

   isfile = 0
   StringReplace,Line,A_LoopReadLine,%rootdir%\,
   ifinstring Line,.
      isfile = 1

   if isfile = 0
   {
      StringGetPos,pos,Line,\,R
      StringLeft,pardir,Line,%pos%
      StringReplace,dir,Line,%pardir%,
      StringReplace,dir,dir,\
      Menu,%Line%,add,-`:`:�� Ŀ¼`:`:-,godir

      if pardir =
         pardir = DirMenu
      Menu,%pardir%,add,%dir%,:%Line%
   }
   else
   {
      StringGetPos,pos,Line,\,R
      StringLeft,pardir,Line,%pos%
      StringReplace,file,Line,%pardir%,
      StringReplace,file,file,\
      if pardir =
         pardir = DirMenu
      Menu,%pardir%,add,%file%,go
   }
}
SetTimer,ini,off
TrayTip
Menu,DirMenu,show
Menu,DirMenu,Deleteall
return

go:
   if A_ThisMenu = DirMenu
      run %rootdir%\%A_ThisMenuItem%
   else
      run %rootdir%\%A_ThisMenu%\%A_ThisMenuItem%
return

godir:
if A_ThisMenu = DirMenu
      run %rootdir%
   else
      run %rootdir%\%A_ThisMenu%
return

createdatabase:
settimer,kill_process1,-6000
   runwait, %comspec% /c dir /s /b /os /a:d "%rootdir%" > "%A_ScriptDir%\settings\tmp\folderlist.txt",,hide,cpid1
   runwait, %comspec% /c dir /s /b /os /a:-d "%rootdir%" >> "%A_ScriptDir%\settings\tmp\folderlist.txt",,hide,cpid2
return

ini:
   TrayTip,Ŀ¼�˵�,��ʼ��������,30
return

kill_process1:
Process,Exist,%cpid1%
settimer,kill_process2,-1000
if ErrorLevel 
{
Process,Close,%cpid1%
SetTimer,ini,off
}
return

kill_process2:
Process,Exist,%cpid2%
if ErrorLevel 
{
SetTimer,ini,off
TrayTip,Ŀ¼�˵�����ʧ��, ѡ���ļ������ļ�����`n�޷�����Ŀ¼�ļ��б��̳߳�ʱ�˳���
Process,Close,%cpid2%
FileRecycle, %A_ScriptDir%\settings\tmp\folderlist.txt
C_error=1
}
return