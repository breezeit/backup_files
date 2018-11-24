;方便在Excel中输入快捷键名称
#SingleInstance Force
#NoEnv

#IfWinActive ahk_exe SciTE.exe
f5::
Reload
Return

#IfWinActive,ahk_class XLMAIN   ;excel
	{		
		Numpad1::send,Ctrl{+}
		Numpad2::send,Alt{+}
		Numpad3::send,Shift{+}
		Numpad4::send,Win{+}
		return
	}
