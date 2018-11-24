;方便在Everything中输入快捷键名称
#SingleInstance Force
#NoEnv
#NoTrayIcon

#IfWinActive ahk_exe SciTE.exe
f5::
Reload
Return

#IfWinActive,ahk_class EVERYTHING  ;Everthing
	{
		!a::send,audio:
		!z::send,zip:
		!d::send,doc:
		!e::send,exe:
		!p::send,pic:
		!v::send,video:
		!c::send,case:
		!i::send,file:
		!f::send,folder:
		!w::send,wildcards:
		!r::send,regex:
		f1::run,http://www.voidtools.com/zh-cn/support/everything/
		return
	}