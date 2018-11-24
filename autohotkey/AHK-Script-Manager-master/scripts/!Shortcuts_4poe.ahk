#SingleInstance Force
#NoEnv
hotkey, F1, flasks
hotkey, F2, flasks
hotkey, f4, flasks123
flasks()
{
	send 4
	sleep 100
	send 5
	sleep 100
	send 1
	sleep 100
	send 2
	sleep 100
	send 3
}

flasks123()
{
	send 1
	sleep 100
	send 2
	sleep 100
	send 3
}

rep_ivt()
{
	send ivt me pls,ty{enter}
}

rep_sold()
{
	send ty,gl{enter}
}



; `::
; if  flag!=0 ;如果flag=1,跳出循环  
; flag:=0
; loop
; {
; if  flag=1 ;如果flag=1,跳出循环  
; break
; Send {7}
; Send {8}
; sleep, 100,设置延迟
; }
; if  flag=1 ;如果flag=1,跳出循环  
; break
; }
; return

; f2::
; flag:=1  ;结束循环用。
; return




