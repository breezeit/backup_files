addfavorites:
Loop, parse, A_GuiEvent, `n, `r
{
   Gui, Submit, NoHide
   myfav = %A_ScriptDir%\favorites
   ifNotExist, %Dir%
   {
   msgbox,û��ѡ���ļ����ļ��С�
   return
   }

   SplitPath,Dir, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
   InputBox,shortName,,�������ݷ�ʽ������?,,,,,,,,%OutNameNoExt%
   if ErrorLevel{
   return
   }
   else
   {
   IfExist,%myfav%\%shortName%.lnk
   {
   msgbox,4,,ͬ���Ŀ�ݷ�ʽ�Ѿ����ڣ��Ƿ��滻?
   IfMsgBox No
   return
   else{
   FileCreateShortcut,%dir%,%myfav%\%shortName%.lnk
   return
   }
   }
   FileCreateShortcut,%dir%,%myfav%\%shortName%.lnk
   return
}
return
}
return

showfavorites:
   myfav = %A_ScriptDir%\favorites
   kShortcutExt = lnk
; ���� menushowicon  ���Ʋ˵��Ƿ���ʾͼ��
; ��ݷ�ʽ�ļ�̫��˵������ʾͼ��Ļ����˵������ٶȱ���
menushowicon=0  

FileCount := 0
Loop, %myfav%\*.%kShortcutExt%,,   ; for each shortcut in the directory, add a menu item for it
{
   FileCount++
   SplitPath,A_LoopFilePath, , , , menuName2
   Menu, mymenu2, Add, %menuName2%, RunThisMenuItem
    SplitPath, A_LoopFilePath, , , , menuName,      ; remove extension
    Menu, mymenu2, Add, %menuName%, RunThisMenuItem
    FileGetShortcut, %A_LoopFilePath%, OutItem, , , , OutIcon, OutIconNum
			try{
				if(OutIcon){
					Menu,mymenu2,Icon,%menuName%,%OutIcon%,%OutIconNum%
				}else{
					Menu,mymenu2,Icon,%menuName%,%OutItem%
				}
			} catch e {
				Menu,mymenu2,Icon,%menuName%,shell32.dll,1
			}
}

if(FileCount != 0)
Menu, mymenu2, Add

FileCount := 0
Loop, %myfav%\*, 2    ;��ȡ�ļ���
{
fname:=A_LoopFileName
FileList =
   Loop, %myfav%\%fname%\*.lnk  ;������Ĭ��˳��  ntfs ��ĸ   fat32  ������ʱ������
    FileList = %FileList%%A_LoopFileName%`n
      Sort, FileList     ;����  ntfs ��ĸ   fat32  ������ʱ������
      Loop, parse, FileList, `n
      {
      if A_LoopField =  ; Ignore the blank item at the end of the list.
      continue
      FileCount++
      SplitPath,A_LoopField, , , , pos
      Menu, %fname%, add, %pos%, MenuHandler   ; �����Ӳ˵��
if menushowicon  
{
    FileGetShortcut, %myfav%\%fname%\%A_LoopField%, OutItem, , , , OutIcon, OutIconNum
			try{
				if(OutIcon){
					Menu,%fname%,Icon,%pos%,%OutIcon%,%OutIconNum%
				}else{
          if InStr(FileExist(OutItem), "D")
					Menu,%fname%,Icon,%pos%,%a_scriptdir%\pic\candy\extension\folder.ico
					else
					Menu,%fname%,Icon,%pos%,%OutItem%
				}
			} catch e {
				Menu,%fname%,Icon,%pos%,shell32.dll,1
			}
}
       }
if(FileCount != 0)                          ;���Կյ����ļ��У��������
Menu,mymenu2, add, %fname%, :%fname%  ; �������˵��
}
 Menu, mymenu2, Add
 Menu, mymenu2, Add,�����ղ�,o
Menu,mymenu2,show
Menu,mymenu2,deleteall
/*
Loop, %w2%\*.*, 2, 0
{
    FileCount := 0
     Foldname := A_LoopFileName
     Loop, %w2%\%Foldname%\*.lnk, 0, 0
     {
        FileCount++
     }
     if(FileCount != 0)
     Menu,%Foldname%,Deleteall
}
*/
return

o:
run %myfav%
return

RunThisMenuItem:
; Runs the shortcut corresponding to the last selected tray meny item
    Run %myfav%\%A_ThisMenuItem%.%kShortcutExt%
        if ErrorLevel
        MsgBox,,,ϵͳ�Ҳ���ָ�����ļ���,3
    return

MenuHandler:   ;���г���
RunFileName = %myfav%\%A_ThisMenu%\%A_ThisMenuItem%.lnk
run, %RunFileName%,,UseErrorLevel
        if ErrorLevel
        MsgBox,,,ϵͳ�Ҳ���ָ�����ļ���,3
Return    ;����