
; 程序运行之后……你的小键盘就不再是以前那个鸡肋的小键盘了，快来擦干净它上面的灰尘，让我们一起 high 起来。

; 首先打开 NumLock，看到指示灯亮起后你便可以使用如下功能：

; 用 1-9 的数字键可以快速调整当前窗口的位置和大小；
; 如果先按住加号键再按数字键，你将获得较大的窗口；
; 如果先按住减号键再按数字键，你将获得较小的窗口；
; 如果先按住 0 号键，再按 8 号键，那么窗口将最大化；
; 如果先按住 0 号键，再按 2 号键，那么窗口将最小化；
; 按住小数点键，再按 8 号键，切换当前窗口是否置顶；
; 如上是调整窗口布局的功能，那么下面关闭 NumLock，当你看到指示灯熄灭，你可以使用如下功能：

; 5 号键是播放器的播放/暂停键；
; 4 号键是上一首；
; 6 号键是下一首；
; 8 号键是增大音量；
; 2 号键是减小音量；
; 这是媒体播放控制功能，但是现在的按键利用率还不够高，所以此时的：

; 1 号键是切换到上一个虚拟桌面；
; 3 号键是切换到下一个虚拟桌面；
; 是不是觉得还有一些功能欠缺，那么还有几个不受 NumLock 状态影响的快捷键：

; 乘号键是新建一个虚拟桌面；
; 除号键是删除当前虚拟桌面；
; 回车键是静音/取消静音；
; 那么如果你临时需要使用小键盘怎么办？Ctrl+0 可以开启或者关闭小键盘功能。
;==========================


;Ctrl+0 键切换开关
^Numpad0::Suspend
^NumpadIns::Suspend

WindowsResize(x,y,w,h){
	WinExist("A")
	WinGetTitle, WinTitle
	WinMaximize, %WinTitle%
    ;WinGetPos,,, Width, Height, %WinTitle%
    SysGet, WorkArea, MonitorWorkArea
    if(w=100){
    	k=0
    }else{
    	k=7
    }
    WinMove, %WinTitle%,, WorkAreaLeft+(((WorkAreaRight-WorkAreaLeft)/100)*x)-k, WorkAreaTop+(((WorkAreaBottom-WorkAreaTop)/100)*y), (((WorkAreaRight-WorkAreaLeft)/100)*w)+(k*2), (((WorkAreaBottom-WorkAreaTop)/100)*h)+7
}

Numpad7::
	WindowsResize(0,0,50,50)
return
NumpadAdd & Numpad7::
	WindowsResize(0,0,50,40)
return
NumpadSub & Numpad7::
	WindowsResize(0,0,50,60)
return

Numpad8::
	WindowsResize(0,0,100,50)
return
Numpad0 & Numpad8::
	WinExist("A")
	WinMaximize
return
NumpadAdd & Numpad8::
	WindowsResize(0,0,100,40)
return
NumpadSub & Numpad8::
	WindowsResize(0,0,100,60)
return
NumpadDot & Numpad8::
	WinExist("A")
	WinSet, AlwaysOnTop
return

Numpad9::
	WindowsResize(50,0,50,50)
return
NumpadAdd & Numpad9::
	WindowsResize(50,0,50,40)
return
NumpadSub & Numpad9::
	WindowsResize(50,0,50,60)
return

Numpad4::
	WindowsResize(0,0,50,100)
return
NumpadSub & Numpad4::
	WindowsResize(0,0,40,100)
return
NumpadAdd & Numpad4::
	WindowsResize(0,0,60,100)
return

Numpad5::
	WindowsResize(20,10,60,80)
return
NumpadAdd & Numpad5::
	WindowsResize(3,2,94,96)
return
NumpadSub & Numpad5::
	WindowsResize(30,15,40,70)
return

Numpad6::
	WindowsResize(50,0,50,100)
return
NumpadAdd & Numpad6::
	WindowsResize(40,0,60,100)
return
NumpadSub & Numpad6::
	WindowsResize(60,0,40,100)
return

Numpad1::
	WindowsResize(0,50,50,50)
return
NumpadAdd & Numpad1::
	WindowsResize(0,40,50,60)
return
NumpadSub & Numpad1::
	WindowsResize(0,60,50,40)
return

Numpad2::
	WindowsResize(0,50,100,50)
return
Numpad0 & Numpad2::
	WinExist("A")
	WinMinimize
return
NumpadAdd & Numpad2::
	WindowsResize(0,40,100,60)
return
NumpadSub & Numpad2::
	WindowsResize(0,60,100,40)
return

Numpad3::
	WindowsResize(50,50,50,50)
return
NumpadAdd & Numpad3::
	WindowsResize(50,40,50,60)
return
NumpadSub & Numpad3::
	WindowsResize(50,60,50,40)
return

NumpadEnd::^#Left
NumpadDown::Volume_Down
NumpadPgDn::^#Right
NumpadLeft::Media_Prev
NumpadClear::Media_Play_Pause
NumpadRight::Media_Next
;NumpadHome
NumpadUp::Volume_Up
;NumpadPgUp

NumpadEnter::Volume_Mute

NumpadMult::#^d
NumpadDiv::#^F4

