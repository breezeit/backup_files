#include %A_ScriptDir%\Lib\CaptureScreen.ahk

;��ȡȫ����PrintScreen���򴰿ڣ�Alt+PrintScreen��
;PrintScreen::
ȫ����ͼ:
CaptureScreen(0, True, 0)
ssFileName := "Screen_" A_Now

AfterCaptureScreen:
IfExist, %A_ScriptDir%\Sound\shutter.wav
SoundPlay, %A_ScriptDir%\Sound\shutter.wav, wait
if(ѯ��=1)
{
 ;���ӽ�ͼ�Ի��������ť
 OnMessage(0x53, "WM_HELP")
 Gui +OwnDialogs
 SetTimer, ChangeButtonNames, 50
 msgbox,16387,��ͼ,��Ļ�Ѿ���ȡ,������ǡ��Զ����档`n������񡱴򿪻�ͼ���༭ͼƬ��
  IfMsgBox Yes
  gosub,SaveCapture
  IfMsgBox No
   {
    Run, mspaint.exe
    WinWaitActive,�ޱ��� - ��ͼ,,3
    if ErrorLevel
    return
    Send,^v
    Return
   }
  Else
  return
}
else
gosub,SaveCapture
Return

;��ȡ���ڴ���꣨Shift+PrintScreen��
;+PrintScreen::
���ڽ�ͼ:
CaptureScreen(1, True, 0)
ssFileName := "Window_" A_Now
gosub AfterCaptureScreen
return

SaveCapture:
Convert(0,  screenshot_path . "\" ssFileName "." . filetp)
Return

ChangeButtonNames:
IfWinNotExist, ��ͼ
    return  ; Keep waiting.
SetTimer, ChangeButtonNames, off
WinActivate
ControlSetText, Button4, ������
return

WM_HELP(){
global  filetp,screenshot_path
IfWinExist,��ͼ
{
WinClose,��ͼ
InputBox,SsFileName,��ͼ,`n�����ͼ�ļ����������ļ�,,440,160
if ErrorLevel=0
{
File:= screenshot_path . "\" SsFileName "." . filetp
if(Fileexist(File))
File:= screenshot_path . "\" . Ssfilename . "_" . A_Now . "." . filetp
Convert(0, File)
}
}
}

/*
CaptureScreen(0, False, 0)   �����������
CaptureScreen(0, True, 0)    ���������
CaptureScreen(1, False, 0)   �ش��ڲ������
CaptureScreen(1, True, 0)    �ش��ڴ����
*/