;#ifwinactive, ahk_Group AppMainWindow
;Del::
ɾ��������ʷ��Ŀ:
GuiControlGet, focused_control, focusV
ifEqual, focused_control, Dir
{
  Tempitems =
  GuiControlGet, EditContent, , %Focused_Control%, Text
  Loop, Parse, stableProgram, |
	{
		If (A_LoopField = EditContent) ; not case-sensitive
		    Return
    }
  Loop, Parse, ComboBoxShowItems, |
	{
	    If !A_LoopField Or (A_LoopField = EditContent) ; not case-sensitive
			Continue
		Else
			Tempitems .= A_LoopField . "|"
	}
	StringTrimRight, Tempitems, Tempitems, 1   ; remove last |
	ComboBoxShowItems := Tempitems
	GuiControl, , %Focused_Control%, |%ComboBoxShowItems%
	sLength := StrLen(stableProgram)
	StringTrimLeft, historyData, ComboBoxShowItems, %sLength%
	IniWrite,%historyData%,%run_iniFile%,�̶��ĳ���,historyData
}
Return
;#ifwinactive

;#ifwinactive, ahk_Group AppMainWindow
;~Enter::
;~Numpadenter::
��¼������ʷ:
��¼������ʷ�ȼ���:
if temp_runhistory
{
temp_runhistory=0
return
}
WinActivate,%apptitle%
sleep,50
GuiControlGet, focused_control, focusV
ifEqual, focused_control, Dir
{
  GuiControlGet, EditContent, , %Focused_Control%, Text
  If (EditContent <> "")
    {
  Loop, Parse, stableProgram, |
	{
		If (A_LoopField = EditContent) ; not case-sensitive
		Return
	}
	historyData .= "|"
	historyData .= EditContent
	Sort, historyData, D| U
	ComboBoxShowItems :=stableProgram . historyData
	IniWrite,%historyData%,%run_iniFile%,�̶��ĳ���,historyData
	GuiControl, , %Focused_Control%, |%ComboBoxShowItems%
	GuiControl,ChooseString,dir,%EditContent%
	GuiControl, +default,��(&O)
	}
}
Return
;#ifwinactive