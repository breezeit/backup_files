;�ղؼ����
IEfavorites:
Loop, parse, A_GuiEvent, `n, `r
{
SetBatchLines, 3000
;�ղؼ�Ŀ¼
RegRead, fa, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders,Favorites
Transform,dir,Deref,%fa%
rootdir2 = %dir%
updatealways = 1                        ;1�Զ�ˢ�£�0��ֹ�Զ�ˢ��
SetTimer,ini2,500
TrayTip,Ŀ¼�˵�,��ʼ��������,
ifnotexist %A_ScriptDir%\settings\tmp\IE.txt
   gosub, createdatabase2

Menu,DirMenu2,add,%rootdir2%,godir2
Menu,DirMenu2,disable,%rootdir2%
Menu,DirMenu2,add,-`:`:�� Ŀ¼`:`:-,godir2
;��� updatealways = 1����ôÿ�ζ�����������Ŀ¼����дIE.txt
if updatealways = 1
   gosub createdatabase2
    goto createmenu2

CreateMenu2:
Loop, Read, %A_ScriptDir%\settings\tmp\IE.txt
{

   isfile = 0
   StringReplace,Line,A_LoopReadLine,%rootdir2%\,
   ifinstring Line,.
      isfile = 1

   if isfile = 0
   {
      StringGetPos,pos,Line,\,R
      StringLeft,pardir,Line,%pos%
      StringReplace,dir,Line,%pardir%,
      StringReplace,dir,dir,\
      Menu,%Line%,add,-`:`:�� Ŀ¼`:`:-,godir2

      if pardir =
         pardir = DirMenu2
      Menu,%pardir%,add,%dir%,:%Line%
   }
   else
   {
      StringGetPos,pos,Line,\,R
      StringLeft,pardir,Line,%pos%
      StringReplace,file,Line,%pardir%,
      StringReplace,file,file,\
      if pardir =
         pardir = DirMenu2
      Menu,%pardir%,add,%file%,go2

   }
}
SetTimer,ini2,off
Traytip
Menu,DirMenu2,show
Menu,DirMenu2,Deleteall
return

go2:
   if A_ThisMenu = DirMenu2
      run %rootdir2%\%A_ThisMenuItem%
   else
      run %rootdir2%\%A_ThisMenu%\%A_ThisMenuItem%
return

godir2:
if A_ThisMenu = DirMenu2
      run %rootdir2%
   else
      run %rootdir2%\%A_ThisMenu%
return

;CMD����ҳ��Ϊ65001��������ļ�����Ϊutf-8��ansi���ȡ��������
createdatabase2:
   runwait, %comspec% /c dir /s /b /os /a:d "%rootdir2%" > "%A_ScriptDir%\settings\tmp\IE.txt",,hide
   runwait, %comspec% /c dir /s /b /os /a:-d "%rootdir2%" >> "%A_ScriptDir%\settings\tmp\IE.txt",,hide
return

ini2:
   TrayTip,Ŀ¼�˵�,��ʼ��������,30
return
}
return