;Explorer .. View mode--------------By a_h_k & ..:: Free Radical ::..
;http://www.autohotkey.com/forum/topic57686.html


�����ö�:
;^Up::
WinSet,AlwaysOnTop,,A
return

��ʱ���ش���:
;#Space::
WinGet, active_id, ID, A
WinHide, ahk_id %active_id%
Sleep, 4000
WinShow, ahk_id %active_id%
return

�ر���ʾ������������:
;#s::
KeyWait LWin    ;�ȴ�LWin���ɿ��󣬲ż���
KeyWait S
BlockInput On   ;�������̣����
SendMessage, 0x112, 0xF170, 2,, Program Manager ;�ر���ʾ��
DllCall("LockWorkStation")                      ;�������ԣ��൱��Win+L
BlockInput Off  ;���������̣����
return

��ֹ�رհ�ť:
;#8::
;DisableCloseButton(WinExist("A"))
;DisableMenuButtons(WinExist("A"))
;DisableMinimizeButton(WinExist("A"))
WinSet, Style, -0x80000, A    ;���ر�����ͼ�꣬��ť���������˵�
return

�ָ��رհ�ť:
;#9::
;RedrawSysmenu(WinExist("A"))
WinSet, Style, +0x80000, A
return
;
;-1 is Close, -2 is the seperator, -3 is Maximize,
;-4 is Minimize, -5 is Size, -6 is Move and -7 is Restore
;

DisableMenuButtons(hWnd="") {
 hWnd := (!hWnd) ? WinExist("A") : hWnd
 hSysMenu:=DllCall("GetSystemMenu","Int",hWnd,"Int",FALSE)
 nCnt:=DllCall("GetMenuItemCount","Int",hSysMenu)
 Loop, %nCnt%
   DllCall("RemoveMenu","Int",hSysMenu,"UInt",nCnt-A_Index,"Uint","0x400")
}

DisableMinimizeButton(hWnd="") {
 If hWnd=
    hWnd:=WinExist("A")
 hSysMenu:=DllCall("GetSystemMenu","Int",hWnd,"Int",FALSE)
 nCnt:=DllCall("GetMenuItemCount","Int",hSysMenu)
 DllCall("RemoveMenu","Int",hSysMenu,"UInt",nCnt-4,"Uint","0x400")
 ;DllCall("RemoveMenu","Int",hSysMenu,"UInt",nCnt-5,"Uint","0x400")
 DllCall("DrawMenuBar","Int",hWnd)
Return ""
}


RedrawSysMenu(hWnd="") {
 If hWnd=
    hWnd:=WinExist("A")
 hSysMenu:=DllCall("GetSystemMenu","Int",hWnd,"Int",TRUE)
 DllCall("DrawMenuBar","Int",hWnd)
Return ""
}

DisableCloseButton(hWnd="") {
 If hWnd=
    hWnd:=WinExist("A")
 hSysMenu:=DllCall("GetSystemMenu","Int",hWnd,"Int",FALSE)
 nCnt:=DllCall("GetMenuItemCount","Int",hSysMenu)
 DllCall("RemoveMenu","Int",hSysMenu,"UInt",nCnt-1,"Uint","0x400")
 DllCall("RemoveMenu","Int",hSysMenu,"UInt",nCnt-2,"Uint","0x400")
 DllCall("DrawMenuBar","Int",hWnd)
Return ""
}

����������:
;#6::
winhide, ahk_class Shell_TrayWnd
Return

�ָ�������:
;#7::
winshow, ahk_class Shell_TrayWnd
Return

ExploreDrive:
   StringRight Drv,A_THISHOTKEY,1
   ifExist %Drv%:\
      Run %Drv%:\
   else
      TrayTip,����,%Drv%�̲�����!,10,3
Return

��Ϊ������:
;#z::
; Change this line to pick a different hotkey.
; Below this point, no changes should be made unless you want to
; alter the script's basic functionality.
; Uncomment this next line if this subroutine is to be converted
; into a custom menu item rather than a hotkey.  The delay allows
; the active window that was deactivated by the displayed menu to
; become active again:
;Sleep, 200
WinGet, ws_ID, ID, A
Loop, Parse, ws_IDList, |
{
   IfEqual, A_LoopField, %ws_ID%
   {
      ; Match found, so this window should be restored (unrolled):
      StringTrimRight, ws_Height, ws_Window%ws_ID%, 0
        if ws_Animate = 1
        {
            ws_RollHeight = %ws_MinHeight%
            Loop
            {
                If ws_RollHeight >= %ws_Height%
                    Break
                ws_RollHeight += %ws_RollUpSmoothness%
                WinMove, ahk_id %ws_ID%,,,,, %ws_RollHeight%
            }
        }
       WinMove, ahk_id %ws_ID%,,,,, %ws_Height%
      StringReplace, ws_IDList, ws_IDList, |%ws_ID%
      return
   }
}
WinGetPos,,,, ws_Height, A
ws_Window%ws_ID% = %ws_Height%
ws_IDList = %ws_IDList%|%ws_ID%
ws_RollHeight = %ws_Height%
if ws_Animate = 1
{
    Loop
    {
        If ws_RollHeight <= %ws_MinHeight%
            Break
        ws_RollHeight -= %ws_RollUpSmoothness%
        WinMove, ahk_id %ws_ID%,,,,, %ws_RollHeight%
    }
}
WinMove, ahk_id %ws_ID%,,,,, %ws_MinHeight%
return

;#IfWinActive ahk_group ExplorerGroup
;^d::InvertSelection()
;#IfWinActive

��Դ��������ѡ:
ControlGet, hCtl, Hwnd, , SHELLDLL_DefView1, A
PostMessage, 0x111, 28706, 0, , ahk_id %hCtl%		;�༭, ����ѡ��
; �����˵�Ȼ��ѡ��˵��ķ�ʽ
; InvertSelection()
return

InvertSelection()
{
;�������ڲ˵�����ѡ����Ӧ�˵��س�
	PostMessage,0x112,0xf100,0,,A
	SendInput {Right}{Down}{Up}{Enter}
	return
}

;Win_7���Դ��Ŀ�ݼ���^+���֡� Ϊ�Ŵ�ͼ����л���ͼ
;��������Դ�������ͶԻ���
�л���ͼ:
MouseGetPos,x,y,winid,ctrlid,2
Sleep,0
WM_COMMAND=0x111

;�鿴��ʽ  XP����
ODM_VIEW_ICONS =0x7029			;28713		ͼ��
ODM_VIEW_LIST  =0x702b				;28715		�б�
ODM_VIEW_DETAIL=0x702c			;28716		��ϸ��Ϣ
ODM_VIEW_THUMBS=0x702d	;28717		����ͼ
ODM_VIEW_TILES =0x702e				;28718		ƽ��

/*
;��������
ODM_VIEW_ICONS =0x7602
ODM_VIEW_LIST  =0x7603
ODM_VIEW_DETAIL=0x7604
ODM_VIEW_THUMBS=0x7605
ODM_VIEW_TILES =0x7606
*/
views=%ODM_VIEW_ICONS%,%ODM_VIEW_LIST%,%ODM_VIEW_DETAIL%,%ODM_VIEW_THUMBS%,%ODM_VIEW_TILES%
StringSplit,view_,views,`,
view+=1
If view>5
  view=1
changeview:=view_%view%
ControlGet,listview,Hwnd,,,ahk_id %ctrlid%
parent:=listview
Loop
{
  parent:=DllCall("GetParent","UInt",parent)
  If parent=0
    Break
  SendMessage,%WM_COMMAND%,%changeview%,0,,ahk_id %parent%
}
return


;#V::
���뱣�沢����:
	clipboard =
	Send, ^c
	ClipWait,3
CF_HTML := DllCall("RegisterClipboardFormat", "str", "HTML Format")
bin := ClipboardAll
n := 0
while format := NumGet(bin, n, "uint")
{
    size := NumGet(bin, n + 4, "uint")
    if (format = CF_HTML)
    {
        html := StrGet(&bin + n + 8, size, "UTF-8")
        RegExMatch(html, "(*ANYCRLF)SourceURL:\K.*", sourceURL)
        break
    }
    n += 8 + size
}
Clipboard := sourceURL ? (";��Դ��ַ: " sourceURL "`r`n" Clipboard) : Clipboard

if clipboard 
{
	clipboard = %clipboard%
	File:=  A_Desktop "\" . A_Now  ".ahk"
	FileAppend,%clipboard%`r`n,%File%
	run,%File%,%A_Desktop%
}
return

;!F1::
�е����緭��:
ԭֵ:=Clipboard
	clipboard =
	Send, ^c
	ClipWait,2
	If ErrorLevel                          ;���ճ��������û�����ݣ����ж��Ƿ��д��ڶ���
		Return

	Youdao_keyword=%Clipboard%
	Youdao_����:=YouDaoApi(Youdao_keyword)
	Youdao_��������:= json(Youdao_����, "basic.explains")
	Youdao_��������:= json(Youdao_����, "web.value")
	If Youdao_��������<>
	{
		ToolTip,%Youdao_keyword%:`n��������:%Youdao_��������%`n��������:%Youdao_��������%
		gosub,soundpaly
		ToolTip
	}
else
MsgBox,,�е����緭��,���������ѯ�����õ��ʵķ��롣
Clipboard:=ԭֵ
return


/*
#F::
ClipboardCode(1)
return


ClipboardCode( RunInScite=0 ) {
   Send, ^c
   If !ClipboardGet_HTML(clip)
      return ""
   If !RegExMatch(clip,"is)<!--StartFragment-->(.*)<!--EndFragment-->",html)
      return ""
   doc := COM_CreateObject("HTMLfile")
   COM_Invoke(doc,"write","<html><head></head><body>" html1 "</body></html>")
   td := COM_Invoke(doc,"getElementsByTagname","td")
   loop % COM_Invoke(td,"length")
      if (COM_Invoke(COM_Invoke(td,"Item",A_Index-1),"className") = "code") && (code := COM_Invoke(COM_Invoke(td,"Item",A_Index-1),"innerText"))
         break
   if ( r := RegExReplace(code,"\xc2","") )
      Clipboard := r
   else
      return
      */

Runz:
IfWinExist, %A_ScriptDir%\RunZ.ahk ahk_class AutoHotkey
send % RunZ
else
Run,%A_AhkPath% "%A_ScriptDir%\RunZ.ahk" --show
return