;�����ݷ�ʽ
Desktoplnk:
kShortcutDir = %A_desktop%
kShortcutExt = lnk
Loop, %A_desktop%\*.%kShortcutExt%,,   ; for each shortcut in the directory, add a menu item for it
{
    SplitPath, A_LoopFilePath, , , , menuName,      ; remove extension
    Menu, mymenu, Add, %menuName%, RunThisMenuItem333
    FileGetShortcut, %A_LoopFilePath%, OutItem, , , , OutIcon, OutIconNum
			try{
				if(OutIcon){
					Menu,mymenu,Icon,%menuName%,%OutIcon%,%OutIconNum%
				}else{
					Menu,mymenu,Icon,%menuName%,%OutItem%
				}
			} catch e {
				Menu,mymenu,Icon,%menuName%,shell32.dll,1
			}
}

If Fileexist(A_desktop "\����")
{
Menu,mymenu, add
Loop, %A_desktop%\����\*.lnk
   {
        SplitPath, A_LoopFilePath, , , , menuName,      ; remove extension
        Menu, ����, add, %menuName%, RunThisMenuItem2  ; �����Ӳ˵��
    FileGetShortcut, %A_LoopFilePath%, OutItem, , , , OutIcon, OutIconNum
			try{
				if(OutIcon){
					Menu,����,Icon,%menuName%,%OutIcon%,%OutIconNum%
				}else{
					Menu,����,Icon,%menuName%,%OutItem%
				}
			} catch e {
				Menu,����,Icon,%menuName%,shell32.dll,1
			}
    }
Menu,mymenu, add, ����, :����  ; �������˵��
}

Menu,mymenu,show
Menu,mymenu,deleteall
If Fileexist(A_desktop "\����")
	Menu, ����,deleteall
return

RunThisMenuItem333:
Run %kShortcutDir%\%A_ThisMenuItem%.lnk
Return

RunThisMenuItem2:
RunFileName = %A_desktop%\����\%A_ThisMenuItem%.lnk
run, %RunFileName%
Return    ;����