#ifwinactive, ahk_Group AppMainWindow
~@::
sleep,200
GuiControlGet, EditContent,,dir
if EditContent=@
{
Temp_ComboBoxShowItems:="@ExeAhk@|@Cmd@|@Proxy@|@regedit@|@ת��@UrlDecode@|@ת��@UrlEncode@|@ת��@10��16@|@ת��@16��10@|@ת��@ũ��������@|@ת��@������ũ��@|@ת��@�����@|@ת��@������@"
GuiControl, , dir, |%Temp_ComboBoxShowItems%
changeComboBox=1
send @
settimer,huifu_ComboBox,-40000
}
return

~#::
sleep,200
GuiControlGet, EditContent,,dir
if EditContent=#
{
Temp_ComboBoxShowItems=
Loop, Files, %A_ScriptDir%\favorites\*.*,FR
{
	SplitPath,A_LoopFileName, , , , temp1
	Temp_ComboBoxShowItems.= temp1 "|"
}
Sort, Temp_ComboBoxShowItems,D|
GuiControl, , dir, |%Temp_ComboBoxShowItems%
changeComboBox=1
favorites_link=1
settimer,huifu_ComboBox,-40000
}
return
#ifwinactive

huifu_ComboBox:
if changeComboBox=1
{
GuiControl, , dir, |%ComboBoxShowItems%
changeComboBox=0
favorites_link=0
}
return