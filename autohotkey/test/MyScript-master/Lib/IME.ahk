IME_Switch(dwLayout)
{
    HKL := DllCall("LoadKeyboardLayout", Str, dwLayout, UInt, 1)
    ControlGetFocus, ctl, A
    SendMessage, 0x50, 0, HKL, %ctl%, A
}

IME_SwitchToEng()
{
    ; �·������ֻ����һ��
    IME_Switch(0x04090409) ; Ӣ��(����) ��ʽ����
    IME_Switch(0x08040804) ; ����(�й�) ��������-��ʽ����
}

; ����ʱ��WIN7 ���л��� �ѹ�ƴ��/����ABC/QQƴ�� ʱ����ֵ��Ϊ0��Ӣ�ļ��̷���ֵΪ8
IME_GetSentenceMode(WinTitle="A")   {
	ControlGet,hwnd,HWND,,,%WinTitle%
	If	(WinActive(WinTitle))	{
		ptrSize := !A_PtrSize ? 4 : A_PtrSize
	    VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
	    NumPut(cbSize, stGTI,  0, "UInt")   ;	DWORD   cbSize;
		hwnd := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
	             ? NumGet(stGTI,8+PtrSize,"UInt") : hwnd
	}
    Return DllCall("SendMessage"
          , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwnd)
          , UInt, 0x0283  ;Message : WM_IME_CONTROL
          ,  Int, 0x003   ;wParam  : IMC_GETSENTENCEMODE
          ,  Int, 0)      ;lParam  : 0
}