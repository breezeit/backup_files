#SingleInstance Force
#NoEnv

;Ctrl+0 键切换开关
^Numpad0::Suspend
^NumpadIns::Suspend

#IfWinActive,ahk_exe PathOfExile_x64.exe
	{
	f5::
		send ty,gl{enter}
	return
	f6::
		send ivt me pls,ty{enter}
	return
	f4::
		send 1
		sleep 100
		send 2
		sleep 100
		send 3
	return
	f1::
		send 1
		sleep 100
		send 2
		sleep 100
		send 3
		sleep 100
		send 4
		sleep 100
		send 5
	return
	}
