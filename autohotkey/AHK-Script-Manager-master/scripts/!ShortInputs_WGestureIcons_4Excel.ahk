;为在excel里方便输入手势符号的专用脚本
;小键盘区改变映射输入
#SingleInstance Force
#NoEnv

#IfWinActive,ahk_class XLMAIN  ;excel
	{
		;Numpad0::send,
		Numpad1::send,↙
		Numpad2::send,↓
		Numpad3::send,↘
		Numpad4::send,←
		;Numpad5::send,
		Numpad6::send,→
		Numpad7::send,↖
		Numpad8::send,↑
		Numpad9::send,↗
		NumpadDiv::send,◐
		NumpadMult::send,◑
		NumpadAdd::send,▼
		NumpadSub::send,▲
		return
	}
