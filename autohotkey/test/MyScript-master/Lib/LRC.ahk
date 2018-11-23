lrcPause(x){
	global
	Stime:=starttime
	If x=0
		SetTimer, lrcpause, Off
	Else
		SetTimer, lrcpause, 100
Return

lrcpause:
		passedtime:=A_TickCount-Pausetime
		starttime:=Stime+passedtime
Return
}

lrcECHO(lrcfile,GuiTitle){
	global
	Gui, 2:+LastFound
	WinSet, TransColor, FF0F0F
	WinSet, ExStyle, +0x20
	if hidelrc=0
		Gui, 2:Show, NoActivate, %GuiTitle% - AhkPlayer  ; ����������ı䵱ǰ����Ĵ���

	FileEncoding
	file :=FileOpen(lrcfile,"r")
	encoding := file.encoding
	if(encoding!="cp936")
		FileEncoding, %encoding%

	; ��ȡlrc�ļ�������
	n:=1
	temp:=1
	Loop, read, %lrcfile%
	{
		temp:=1
		Loop
		{
			temp:=InStr(A_LoopReadLine, "[","", temp)
			If (temp<>0)
			{
				IfInString,A_LoopReadLine,][
				{
					temp:=temp+1
					time%n%:=SubStr(A_LoopReadLine, temp, 8)
					sec%n%:=60*SubStr(time%n%, 1, 2)+SubStr(time%n%, 4, 5)
					If sec%n% is not Number
						Break
					lrc%n%:=SubStr(A_LoopReadLine, InStr(A_LoopReadLine,"]","",0)+1)
					n:=n+1
					continue
				}
				else
				{
					temp:=temp+1
					time%n%:=SubStr(A_LoopReadLine, temp, 8)
					sec%n%:=60*SubStr(time%n%, 1, 2)+SubStr(time%n%, 4, 5)
					If sec%n% is not Number
						Break
					lrc%n%:=SubStr(A_LoopReadLine, InStr(A_LoopReadLine,"]","",1)+1)
					lrc%n%:= RegExReplace(lrc%n%, "\[[0-9]+\:[0-9]+\.[0-9]+\]")
					; ԭ������ҵ�����ҡ�]�����ҵ���ӡ�]��λ��+1����ʼ���ƣ�����ȫ����
					; lrc%n%:=SubStr(A_LoopReadLine, InStr(A_LoopReadLine,"]","",0)+1)
					n:=n+1
					; ԭ���� continue  ,ͬһ�в��Ҷ��,��[xxx][xxx]xxx��ʽ��Ч  ��[xxx]x[xxx]x[xxx]��ʽ��Ч
					; continue
					Break
				}
			}
			Else
				Break
		}
	}

; ��ʱ�����������
	Loop
	{
		n:=1
		flag:=0
		Loop
		{
			nx:=n+1
			If(sec%n% > sec%nx%) And (sec%nx%<>"")
			{
				flag+=1
				; ����sec����    ʵ�ʿ���ֻ��һ���������н鼴��  ���� �˴���Ӱ�����ִ�е�Ч��.
				tz:=sec%n%
				tx:=sec%nx%
				sec%n%:=tx
				sec%nx%:=tz
				; ����lrc����
				tz:=lrc%n%
				tx:=lrc%nx%
				lrc%n%:=tx
				lrc%nx%:=tz
			}
			n:=n+1
			If(sec%nx%="")	;�����һ��Ԫ��Ϊ�գ����˳�ѭ��
				Break
		}
		If(flag=0)
			Break
	}

	t:=1
	GuiControl, 2:, lrc, % lrc%t%
	lrcpos := lrcpos?lrcpos:0
	starttime := A_TickCount - lrcpos
	lrcpos = 0
	maxsec:=n-1
	FileEncoding, CP1200
	SetTimer, clock, 50
	Return


	clock:
	nowtime := (A_TickCount - starttime)/1000
	min := floor(nowtime/60)
	SetFormat, Float, 5.2
	sec := nowtime - min*60

	tx:=t+1
	/*ԭ�����
	If ( (min*60+sec) >= sec%t% and (min*60+sec) <= sec%tx% )
	{
		GuiControl, 2:, lrc, % lrc%t%
		t := t+1
		If (t > n)
		t := 1
	}
	*/
	If ( (min*60+sec) >= sec%t% and (min*60+sec) <= sec%tx% )
	GuiControl, 2:, lrc, % lrc%t%

	If ( (min*60+sec) >= sec%t% )
	{
		t := t+1
		If (t > n)
			t := 1
	}

	loop
	{
		If ( (min*60+sec) >= sec%maxsec%)
			break
		If ( (min*60+sec) >= sec%t%)
			t := t+1
		else
			break
		If (t > n)
			t := 1
	}
Return
}

lrcClear(){
	global
	count:=1
	SetTimer, lrcpause, Off
	Loop, 99			;��ձ���
	{
		min%count%:=""
		sec%count%:=""
		lrc%count%:=""
		count+=1
	}
}