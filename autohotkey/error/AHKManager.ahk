;by Sixtyone At 2016.4.10
;更新说明
#SingleInstance Force
#NoEnv
;#Warn
SetWorkingDir %A_ScriptDir%
Process, Priority,, High
DetectHiddenWindows,On
Menu, Tray, NoStandard ;删除自带托盘菜单
Menu, tray, add, 管理,ShowGui ; 显示gui
Menu, tray, add ; 创建分隔线.
Menu, tray, add ,过滤,Menu_Tray_过滤 ; 过滤
Menu, tray, add ,脚本目录,Menu_Tray_OpenDir ; 脚本目录
Menu, tray, add ,重启管理器,Menu_Tray_Reload ; 重启
Menu, tray, Add
Menu, tray, Add,帮助,Help ;Help
Menu, tray, Add,关于,About ;关于
Menu, tray, Add
Menu, tray, Add, 退出, ExitSub ; 创建 退出
Menu, Tray, Default, 管理 ;;默认 菜单：配置
Menu, Tray, Icon, Shell32.dll, 258
;IntelligentScript:
Gui,Destroy
Gui Add, ListView, x8 y30 w200 h400 AltSubmit vScriptLibrary g运行 , 脚本名称
Gui Add, Text, x10 y3 w120 h23 0x200, 脚本库
Gui Add, ListView, x233 y30 w200 h400 AltSubmit vScriptRun g运行2, 脚本名称
Gui Add, Text, x234 y3 w120 h23 0x200, 已运行脚本
Gui Add, Button, x440 y30 w60 h42 gtsk_open, 启动脚本
Gui Add, Button, x440 y100 w60 h42 gtsk_restart, 重载脚本
Gui Add, Button, x440 y170 w60 h42 gtsk_close, 关闭脚本
Gui Add, Button, x440 y240 w60 h42 gMenu_Tray_OpenDir, 脚本目录
Gui Add, Button, x440 y310 w60 h42 gMenu_Tray_Reload, 重启管理器
Gui Add, Button, x440 y380 w60 h42 gExitSub, 退出
;Gui Show,, AHK管理器
Gui Default
Gui,ListView,ScriptLibrary
scriptCount = 0
IniRead,Golv,过滤.ini,过滤
OpenList := Array()
UnOpenList := Array()
Loop, %A_ScriptDir%\scripts\*.ahk,,1
{
_Golv=0
loop,Parse,Golv,`n,`r ;增加过滤判断
{
StringReplace,_GolvPath,A_LoopField,`%A_ScriptDir`%,%A_ScriptDir%
ifInString,A_LoopFileLongPath ,%_GolvPath%
{
_Golv=1
break
}
}
if _Golv=1
continue
if !(A_LoopFileLongPath~="i). ?\\scripts\\[^\\]*\\?[^\\] \.ahk") ;增加一层子文件读取
continue
StringReplace, MenuName, A_LoopFileName, .ahk
scriptCount = 1
%MenuName%_Path :=A_LoopFileLongPath
%MenuName%_Dir :=A_LoopFileDir
scriptsName%scriptCount% := A_LoopFileName
;scriptsOpened%scriptCount% = 0
UnOpenList.Insert(MenuName)
}
InsertionSort(UnOpenList)
for Index, MenuName in UnOpenList
{
LV_Add("",MenuName)
}
LV_ModifyCol()
gosub tsk_openAll
;Gui,Show
return
运行:
if A_GuiEvent = DoubleClick
{
goto,tsk_open
}
return
运行2:
if A_GuiEvent = DoubleClick
goto,tsk_close
return
GuiContextMenu: ; 运行此标签来响应右键点击或按下 Appskey.
if A_GuiControl = ScriptLibrary ; 这个检查是可选的. 让它只为 ListView 中的点击显示菜单.
{
Gui,Default
Gui,ListView,ScriptLibrary
RowNumber = 0
Loop,%scriptCount%
{
RowNumber := LV_GetNext(RowNumber)
if not RowNumber
Return
break
}
Menu,PopC,Add,编辑,P_edit
Menu,PopC,Add,运行,tsk_open
menu,PopC,Show
return
}
if A_GuiControl = ScriptRun
{
Gui,Default
Gui,ListView,ScriptRun
RowNumber = 0
Loop,%scriptCount%
{
RowNumber := LV_GetNext(RowNumber)
if not RowNumber
Return
break
}
Menu,PopC2,Add,编辑,P_edit
Menu,PopC2,Add,重载,tsk_restart
Menu,PopC2,Add,关闭,tsk_close
menu,PopC2,Show
return
}
return
P_edit:
LV_GetText(thisScript, RowNumber)
P_editpath :=%thisScript%_path
Run, F:\Program Files\AutoHotkey\SciTE\SciTE.exe "%P_editpath%"
return
tsk_open:
Gui,Default
Gui,ListView,ScriptLibrary
RowNumber = 0
Loop,%scriptCount%
{
RowNumber := LV_GetNext(RowNumber)
if not RowNumber
Return
LV_GetText(thisScript, RowNumber)
Run,% %thisScript%_Path,% %thisScript%_Dir,,%thisScript%
IfInString, thisScript, #
{
Gui, Hide
Return
}
;scriptsOpened%A_Index% := 1
break
}
Gui,ListView,ScriptRun
LV_Add("",ThisScript)
LV_ModifyCol()
Gui,ListView,ScriptLibrary
Loop, %scriptCount%
{
LV_GetText(outputname,A_Index,1)
if (outputname=ThisScript)
{
LV_Delete(A_Index)
if A_Index<>1
{
LV_Modify(A_Index-1, "Select")
}
else
{
LV_Modify(1, "Select")
}
break
}
}
LV_ModifyCol()
return
tsk_close:
Gui,Default
Gui,ListView,ScriptRun
RowNumber = 0
Loop,%scriptCount%
{
RowNumber := LV_GetNext(RowNumber)
if not RowNumber
Return
LV_GetText(thisScript, RowNumber)
ID:=%thisScript%
WinClose, ahk_pid %ID%
IfWinExist,ahk_pid %ID%
Process,Close,%ID%
;scriptsOpened%A_Index% := 0
break
}
Gui,ListView,ScriptLibrary
LV_Add("",ThisScript)
LV_ModifyCol()
Gui,ListView,ScriptRun
Loop, %scriptCount%
{
LV_GetText(outputname,A_Index,1)
if (outputname=thisScript)
{
LV_Delete(A_Index)
if A_Index<>1
{
LV_Modify(A_Index-1, "Select")
}
else
{
LV_Modify(1, "Select")
}
break
}
}
LV_ModifyCol()
return
tsk_restart:
Gui,Default
Gui,ListView,ScriptRun
RowNumber = 0
Loop,%scriptCount%
{
RowNumber := LV_GetNext(RowNumber)
if not RowNumber
Return
LV_GetText(thisScript, RowNumber)
ID:=%thisScript%
WinClose, ahk_pid %ID%
IfWinExist,ahk_pid %ID%
Process,Close,%ID%
Run,% %thisScript%_Path,% %thisScript%_Dir,,%thisScript%
break
}
return
tsk_openAll:
Loop, %scriptCount%
{
thisScript := scriptsName%A_Index%
StringReplace, thisScript, thisScript, .ahk
;if scriptsOpened%A_Index% = 0
;{
IfInString, thisScript, _ ;IfInString,%thisScript%_Path,%A_ScriptDir%\Scripts\_ 不自动启动_文件夹内的脚本
{
continue
}
IfInString, thisScript, #
{
continue
}
Run, % %thisScript%_Path,% %thisScript%_Dir,,%thisScript%
;scriptsOpened%A_Index% = 1
Gui,Default
Gui,ListView,ScriptRun
LV_Add("",thisScript)
LV_ModifyCol()
Gui,ListView,ScriptLibrary
Loop, %scriptCount%
{
LV_GetText(outputname,A_Index,1)
if (outputname=thisScript)
{
LV_Delete(A_Index)
break
}
}
LV_ModifyCol()
;}
}
;Gui,Show
return
Menu_Tray_过滤:
Run, Notepad.exe 过滤.ini
return
Menu_Tray_OpenDir:
Run, %A_ScriptDir%\scripts
gui,Hide
return
Menu_Tray_Reload:
gui,Hide
Gui,Default
Gui,ListView,ScriptRun
Loop % LV_GetCount()
{
LV_GetText(thisScript, A_Index)
ID:=%thisScript%
WinClose, ahk_pid %ID%
IfWinExist,ahk_pid %ID%
Process,Close,%ID%
}
Reload
return
GuiEscape:
GuiClose:
Gui, Hide
return
ExitSub:
msgbox,260,是否退出？,退出脚本,将退出所有经过AHK管理器启动的脚本，你是否确认退出？
IfMsgBox No
return
gui,Hide
Gui,Default
Gui,ListView,ScriptRun
Loop % LV_GetCount()
{
LV_GetText(thisScript, A_Index)
ID:=%thisScript%
WinClose, ahk_pid %ID%
IfWinExist,ahk_pid %ID%
Process,Close,%ID%
}
Gui,Destroy
ExitApp
return
InsertionSort(ByRef array)
{
target := Array()
count := 0
for Index, Files in array
{
files%Index% := Files
count = 1
}
j := 2
while (j <= count)
{
key := files%j%
i := j-1
while (i >= 0 && key < files%i%)
{
k := i 1
files%k% := files%i%
i -= 1
}
k := i 1
files%k% := key
j = 1
}
Loop, %count%
{
target.Insert(files%A_Index%)
}
array := target
}
About:
msgbox,AHK管理器`n版本号：2016.4.24`nCopyright©2016 Sixtyone. All Rights Reserved.`n`n关于作者:`n`tName:Sixtyone`n`tQQ:576642385
return
Help:
msgbox,将AHK脚本放在脚本目录下进行管理:`n1.以_开头的脚本不会自动加载`n2.以#开头的脚本为临时脚本即运行完就退出`n3.脚本名字不能有空格及除_、#以为的符号`n4.脚本不能为快捷方式
return
F18::
ShowGui:
gui,Show,,AHK管理器
return