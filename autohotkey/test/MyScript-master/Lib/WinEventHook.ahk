SetWinEventHook(eventMin, eventMax, hmodWinEventProc, lpfnWinEventProc, idProcess, idThread, dwFlags)
{
	return DllCall("SetWinEventHook"
	, Uint,eventMin
	, Uint,eventMax
	, Uint,hmodWinEventProc
	, Uint,lpfnWinEventProc
	, Uint,idProcess
	, Uint,idThread
	, Uint,dwFlags)
}

UnhookWinEvent(hWinEventHook, HookProcAdr)
{
	DllCall( "UnhookWinEvent", Uint,hWinEventHook)
	DllCall( "GlobalFree", UInt,HookProcAdr)  ; free up allocated memory for RegisterCallback
	;msgbox % "�ɹ�Ϊ0, ��ǰֵΪ: " qw
	; &HookProcAdr ���������쳣�˳�  ��Ϊ HookProcAdr��֪���Ƿ���ͬ��Ч��
}