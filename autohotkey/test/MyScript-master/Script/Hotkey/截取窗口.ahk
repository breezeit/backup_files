#include %A_ScriptDir%\Lib\Gdip.ahk

/*
PrintScreen::
Gdip_Startup()
FileName := SaveScreen(1.00,"%filetype%","Screen")
Return
*/

;~!PrintScreen::
;Gdip_Startup()
���ڽ�ͼ��:
SsFileName:=SaveScreen(1.00,"Window",screenshot_path,"",filetp)
IfExist, %A_ScriptDir%\Sound\shutter.wav
SoundPlay, %A_ScriptDir%\Sound\shutter.wav, wait
sleep,100
if(ѯ��=1)
{
 msgbox,3,��ͼ,��ǰ�����Ѿ���ȡ����,������ǡ�����,`n������񡱴򿪻�ͼ���༭ͼƬ,�����ȡ����ɾ����
    IfMsgBox Yes
    Return
    IfMsgBox No
      {
        FileDelete,%screenshot_path%\%SsFileName%.%FileTp%
        Run, mspaint.exe
        WinWaitActive,�ޱ��� - ��ͼ,,3
        if ErrorLevel
        return
        Send,^v
        Return
      }
    Else
    FileDelete,%screenshot_path%\%SsFileName%.%FileTp%
}
Return