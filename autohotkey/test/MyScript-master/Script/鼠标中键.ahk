;����м���ǿ
$MButton::
;MouseGetPos, lastx, lasty
MouseGetPos,,,UID,ClassNN ;��ȡָ���´��ڵ� UID �� ClassNN
WinGetClass,����Class,ahk_id %UID% ;���� UID ��ô�������
CoordMode, Mouse, Relative

;ħ���Զ���Ѫ
IfWinActive,Warcraft III
{
MouseGetPos, xpos, ypos
Send, {F1}{Numpad8}{Click 400, 760}
MouseMove %xpos%, %ypos%
return
}

;�������Զ�����
IfWinActive, %AppTitle%
{
WinGetPos,,oldy,,,%AppTitle%
MouseGetPos,,, win

IfWinNotActive,ahk_id %win%
{
   Send, {MButton}
   return
}
   Loop, Parse, winlist,|
      IfEqual,A_LoopField,%win%
      {
         StringReplace, winlist, winlist,|%win%
            return
      }
   winlist=%winlist%|%win%
#Persistent

SetTimer, WatchCursor2, 500

WatchCursor2:
   ;ToolTip,%winlist%
   CoordMode, Mouse , Screen ;������һ��Ϊ����������Ļ��λ�ã�����Ϊ�������ڸ������ڵ�λ��
   MouseGetPos,xpos,ypos
	If (ypos < oldy-5) or (ypos > oldy+125)
	{
	   Loop,Parse, winlist,|
        {
          IfNotEqual,id,%A_LoopField%
            WinHide,ahk_id %A_LoopField%,,,
        }
    }
   else
   {
   Loop,Parse, winlist,|
      {
		 WinShow,ahk_id %A_LoopField%
         WinActivate,ahk_id %A_LoopField%
		 IfWinActive, %AppTitle%
		 {
		   WinGetPos,,newy,,,%AppTitle%
		   ;tooltip,%newy%-%oldy%
		   if (newy !="") and (newy != oldy)
		   oldy := newy
		 }
      }
   }
   return
}

;��Դ�������´��ڴ��ļ���
if(WinActive("ahk_group ExplorerGroup") && IsMouseOverFileList())
{
	selected:=GetSelectedFiles(0)
	SendEvent {LButton}
	Sleep 200
	if(InStr(FileExist(undermouse:=GetSelectedFiles()), "D"))
		Isdir:=true
	if(undermouse!=selected)
		SelectFiles(selected)
	if(Isdir)
	run explorer.exe  %undermouse%
	return
}

;�������Զ��رմ���
If (����Class = "Shell_TrayWnd") ;ָ���Ƿ�����������
{
	KeyIsDown := GetKeyState("Capslock" , "T")
if	KeyIsDown
{
	Send {MButton}
Return
}
else{
If (ClassNN = "ToolbarWindow321") ;ָ���Ƿ�������ͼ����
{
SendEvent,{click,Right}
SendEvent,{Up}{enter} ;��������������ϣ�Ϊ�ر�ѡ��ĳ���
return
}
Else ;ָ�������������ڰ�ť��
{
;SendEvent,{Click,Right}
;WinWait,ahk_class DV2ControlHost
;Sleep,200 ;�������뷨״̬�£����ӳٲ��ܳɹ�
;SendEvent,{Up}{enter};������������ϣ�Ϊ�ر�ѡ��ĳ���
Send {Shift down}
		click right
If(!IsContextMenuActive())
			sleep 50
Send {Shift up}
sleep,30
	SendEvent {up}{enter}
sleep,500
return
}
}
}

;��������ͼ��
; һ�нű�ʵ���л�
; PostMessage, 0x111, 29698, , SHELLDLL_DefView1, ahk_class Progman
 If (����Class = "Progman" || ����Class = "WorkerW")
{
/*	1
var := (flag=0) ? "Show" : "Hide"
   flag := !flag
   Control,%var%,, SysListView321, ahk_class Progman
   Control,%var%,, SysListView321, ahk_class WorkerW
   Return
   */
/*  2
ControlGet,Vis,Visible,,SysListView321,ahk_class Progman
ControlGet,Selected,List,Selected,SysListView321,ahk_class Progman
IfEqual,cHwnd,,ControlGet, chwnd, Hwnd,, SysListView321,ahk_class Progman
DllCall( "ShowWindow", UInt,cHwnd, UInt, Vis ? 0 : 5 )
Return
    */
/* 3
ControlGet, vCtlStyle, Style, , SysListView321, ahk_class Progman
if !(vCtlStyle & 0x10000000) ;WS_VISIBLE := 0x10000000
PostMessage, 0x111, 29698, , SHELLDLL_DefView1, ahk_class Progman ;show desktop icons (toggle)
*/

ControlGet, HWND, Hwnd,, SysListView321, ahk_class Progman
   If HWND =
      {
	  DetectHiddenWindows Off
      ControlGet, HWND, Hwnd,, SysListView321, ahk_class WorkerW
	  DetectHiddenWindows On
	  }
   If DllCall("IsWindowVisible", UInt, HWND)
      {
      WinHide, ahk_id %HWND%
	  hidedektopicon = 1
	  }
   Else
   {
      WinShow, ahk_id %HWND%
	  hidedektopicon = 0
	  }
Return

/*  3
ControlGet,id1,hwnd,,SHELLDLL_DefView1,ahk_class Progman
ControlGet,DID,hwnd,,SysListView321,ahk_id %id1%
   If DllCall("IsWindowVisible", UInt, DID)
      WinHide, ahk_id %DID%
   Else
      WinShow, ahk_id %DID%
Return
*/
}

;�رմ���
 If (����Class = "OperaWindowClass" || ����Class = "MozillaWindowClass" || ����Class = "MozillaUIWindowClass"|| ����Class = "Chrome_WidgetWin_1" || ����Class = "360se6_Frame")
{

WinGetPos , , , Width,,A
MouseGetPos,����x����,����y����
;��������ڵ���������رմ���
If (����y���� <= 28) && (����y���� >= -1) && (����x���� >= -1) && (����x���� <= Width) ;ָ���Ƿ��ڴ��ڱ�����
{
	if(����Class = "Chrome_WidgetWin_1"){
	Acc := Acc_ObjectFromPoint(ChildId)
  AccRole :=Acc_GetRoleText(Acc.accRole(ChildId))
	if(AccRole != "ѡ��б�"){
	Send, {MButton}
	return
    }
    else{
	PostMessage,0x112,0xF060,,,A ;������ڴ��ڱ������ϣ�Ϊ�رմ��ڣ���������������ڶ��㻹�ǵײ�
    return
	}
   }
  if(����Class = "OperaWindowClass")
   {
   Send, {MButton}
	Return
   }
PostMessage,0x112,0xF060,,,A ;������ڴ��ڱ������ϣ�Ϊ�رմ��ڣ���������������ڶ��㻹�ǵײ�
return
}
else
Send, {MButton}  ;�������������λ�÷����м�
	Return
}


;δ������ȵ������
send {click} ;�ȼ������ѡ�л���ȷ������س���
WinGetPos , , , Width,,A
MouseGetPos,����x����,����y����
If (����y���� <= 28) && (����y���� >= -1) && (����x���� >= -1) && (����x���� <= Width) ;ָ���Ƿ��ڴ��ڱ�����
{
	; 0x112 = WM_SYSCOMMAND, 0xF060 = SC_CLOSE
PostMessage,0x112,0xF060,,,A ;������ڴ��ڱ������ϣ�Ϊ�رմ��ڣ���������������ڶ��㻹�ǵײ�
return
}
else
   Send, {MButton}
CoordMode, Mouse, Screen
return

Alt & WheelDown::
Gosub, GetUnderMouseInfo
WinGetPos,trayX,trayY,trayW,trayH, ahk_class Shell_TrayWnd
	hh = %trayY%
	hh += %trayH%

		if (_x >= A_ScreenWidth * 0.96)
		{
			if (_y>=A_ScreenHeight - 30)
			{
				Gosub, vol_MasterDown
				Return
			}
		}

	ActiveWinTitle := MouseIsOverTitlebar()
	If (ActiveWinTitle and (_class = _aClass))
	{

		If (( _x >= _winX +0 ) And ( _x <= _winX + 80 ))
		  {
		     If(_class= "Progman" or _class= "WorkerW")
		     Return
		     Else
		      {
			    _Transparent = 0
			    Gosub, ChangeTransparency1
			    Return
			  }
          }
        Else
          {
		     WinGet, ws_ID, ID, A
             Loop, Parse, ws_IDList, |
                {
                   IfEqual, A_LoopField, %ws_ID%
                     {
                        ; Match found, so this window should be restored (unrolled):
						StringTrimRight, ws_Height, ws_Window%ws_ID%, 0
                        WinMove, ahk_id %ws_ID%,,,,, %ws_Height%
                        StringReplace, ws_IDList, ws_IDList, |%ws_ID%
                        return
                     }
                }

		  }
    }

if (ScrollUnderMouse)
{
	    ;wheelcount=1
        ;SendMessage, 0x20A , ((-120)*wheelcount)<<16 , (_y<<16) | _x , ,ahk_id %_control%
		;hw_m_target := DllCall( "WindowFromPoint", "int", _x, "int", _y )
        PerformWheel(false, A_EventInfo)
}

Else
		Send, {WheelDown}
Return

Alt & WheelUp::
    Gosub, GetUnderMouseInfo
	CoordMode, Mouse, Screen
	WinGetPos,trayX,trayY,trayW,trayH, ahk_class Shell_TrayWnd

	hh = %trayY%
	hh += %trayH%

		if (_x >= A_ScreenWidth * 0.96)
		{
			if (_y>=A_ScreenHeight - 30)
			{
				Gosub, vol_MasterUp
				Return
			}
		}


	ActiveWinTitle := MouseIsOverTitlebar()
	If (ActiveWinTitle and (_class = _aClass))
	{
		If (( _x >= _winX + 0 ) And ( _x <= _winX + 80 ))
		{
		If(_class= "Progman" or _class= "WorkerW")
		Return
		Else
		{
			_Transparent = 1
			Gosub, ChangeTransparency1
			Return
		}
	}
Else
{
WinGet, ws_ID, ID, A
WinGetPos,,,, ws_Height, A
if ws_Height = %Title_Bar_Height%
   Return
ws_Window%ws_ID% = %ws_Height%
ws_IDList = %ws_IDList%|%ws_ID%
WinMove, ahk_id %ws_ID%,,,,, %ws_MinHeight%
WinGetPos,,,, Title_Bar_Height, A
return
}
}

if (ScrollUnderMouse)
{
	    ;wheelcount=1
		;SendMessage, 0x20A , (120*wheelcount)<<16 , (_y<<16) | _x , ,ahk_id %_control%
		;hw_m_target := DllCall( "WindowFromPoint", "int", _x, "int", _y )
        PerformWheel(True, 1)
}

	Else
		Send, {WheelUp}
Return

GetUnderMouseInfo:
	CoordMode,Mouse,Screen
	MouseGetPos, _x, _y, _id, _control,3
	WinGetTitle, _title, ahk_id %_id%
	WinGetClass, _class, ahk_id %_id%
	WinGetPos, _winX, _winY, _winW, _winH, ahk_id %_id%
	WinGetActiveStats, _aT, _aW, _aH, _aX, _aY
	WinGet, _aId, ID, A
	WinGetClass, _aClass, A
Return

; http://ahk8.com/thread-2503.html
PerformWheel(bUp, wheelcount)
{
	MouseGetPos, _x, _y, _id, _control,2
	WinGetClass, _class, ahk_id %_id%
	;ToolTip ,%bUp% - %_control% - %_id% - %_class%
    if (_class != "TXGuiFoundation")    ;QQ
    {
        if (_control = "")
        {
            SendMessage, 0x20A ;WM_MOUSEWHEEL
                    , bUp ? (120*wheelcount)<<16 : ((-120)*wheelcount)<<16 ;DELTA
                    , (_y<<16) | _x ;Mouse Coord
                    , ,ahk_id %_id%
        }else{
            SendMessage, 0x20A ;WM_MOUSEWHEEL
                    , bUp ? (120*wheelcount)<<16 : ((-120)*wheelcount)<<16 ;DELTA
                    , (_y<<16) | _x ;Mouse Coord
                    , ,ahk_id %_control%
        }
}
else
{
qqqq:= bUp ? "{WheelUp}" : "{WheelDown}"
Send,%qqqq%
Return
}
}
Return

isSpecialWin(){
	ok = 0
	IfInString,_class,bbIconBox
		ok = 1
	IfInString,_class,BlackboxClass
		ok = 1
	IfInString,_class,Opwindow
		ok = 1
	IfInString,TaskBar,_class
		ok = 1
	IfInString,Maxthon,_class
		ok = 1
	if(instr(class,"atl") or class="Shell_TrayWnd" or class="Progman" or class="kfwindow" or class="Button" or class="pluginhost" or class="_gd_sidebar")
		ok = 1
	Return ok
}

ChangeTransparency1:

	Gosub, _CheckWinIDs
	SetWinDelay, -1
	IfWinActive, A
	{
		WinGet, _WinID, ID
		If ( !_WinID )
			Return

		IfNotInString, _WinIDs, |%_WinID%
			_WinIDs = %_WinIDs%|%_WinID%
		_WinAlpha := _WinAlpha%_WinID%
		_PixelColor := _PixelColor%_WinID%
		_WinAlphaStep := 255 * 0.1
		If ( _WinAlpha = "" )
			_WinAlpha = 255
		If (_Transparent = 0)
		{
			_WinAlpha -= _WinAlphaStep
			If( _WinAlpha < 1 )
			_WinAlpha=1
			}
		Else
			_WinAlpha += _WinAlphaStep
		If ( _WinAlpha > 255 )
			_WinAlpha = 255


		{
			_WinAlpha%_WinID% = %_WinAlpha%
			If ( _PixelColor )
				WinSet, TransColor, %_PixelColor% %_WinAlpha%, ahk_id %_WinID%
			Else
				WinSet, Transparent, %_WinAlpha%, ahk_id %_WinID%
			_ToolTipAlpha := _WinAlpha * 100 / 255
			Transform, _ToolTipAlpha, Round, %_ToolTipAlpha%
		}

	}
Return

vol_MasterUp:
SoundSet +%vol_Step%
Gosub, vol_ShowBars
Return

vol_MasterDown:
SoundSet -%vol_Step%
Gosub, vol_ShowBars
Return

vol_ShowBars:
SoundGet,vol_Master
if vol_Master = 0
{
  vol_Colour = Red
  vol_Text = ���� (�Ѿ���)
}
else
{
  vol_Colour := BarColor
  vol_Text = ����
}
; To prevent the "flashing" effect, only create the bar window if it doesn't already exist:
IfWinNotExist, VolumeOSDxyz
{
    Progress, %vol_BarOptionsMaster% CB%vol_Colour% CT%vol_Colour%, , %vol_Text%, VolumeOSDxyz
    WinSet, Transparent, %vol_TransValue%, VolumeOSDxyz
}
Progress, 1:%vol_Master%, , %vol_Text%
SetTimer, vol_BarOff, %vol_DisplayTime%
Return

vol_BarOff:
	SetTimer, vol_BarOff, off
	Progress, 1:Off
Return

_CheckWinIDs:
	DetectHiddenWindows, On
	Loop, Parse, _WinIDs, |
		If ( A_LoopField )
			IfWinNotExist, ahk_id %A_LoopField%
			{
				StringReplace, _WinIDs, _WinIDs, |%A_LoopField%, , All
				_WinAlpha%A_LoopField% =
				_PixelColor%A_LoopField% =
			}
Return

�ָ�����:
_TransparencyAllOff:
	Gosub, _CheckWinIDs
	Loop, Parse, _WinIDs, |
		If ( A_LoopField )
		{
			_WinID = %A_LoopField%
			Gosub, _TransparencyOff
		}
Return

_TransparencyOff:
	Gosub, _CheckWinIDs
	SetWinDelay, -1
	If ( !_WinID )
		Return
	IfNotInString, _WinIDs, |%_WinID%
		Return
	StringReplace, _WinIDs, _WinIDs, |%_WinID%, , All
	_WinAlpha%_WinID% =
	_PixelColor%_WinID% =

	WinSet, Transparent, 255, ahk_id %_WinID%
	WinSet, TransColor, OFF, ahk_id %_WinID%
	WinSet, Transparent, OFF, ahk_id %_WinID%
	WinSet, Redraw, , ahk_id %_WinID%
Return