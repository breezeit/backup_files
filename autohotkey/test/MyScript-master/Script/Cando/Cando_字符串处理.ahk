Cando_���д:
	Candy_Saved_ClipBoard := ClipboardAll 
	Clipboard =
	StringUpper Clipboard, CandySel
	Send ^v
	Sleep, 500
	Clipboard := Candy_Saved_ClipBoard    
	Candy_Saved_ClipBoard =
Return

Cando_��Сд:
	Candy_Saved_ClipBoard := ClipboardAll 
	Clipboard =
	StringLower Clipboard, CandySel
	Send ^v
	Sleep, 500
	Clipboard := Candy_Saved_ClipBoard    
	Candy_Saved_ClipBoard =
Return

Cando_���ִ�д:
	;StringUpper Clipboard, CandySel, T
	Candy_Saved_ClipBoard := ClipboardAll 
	Clipboard =

	Loop, Parse, CandySel, %A_Space%_`,|;-��`.  
	{  
		; ����ָ�����λ��.  
		Position += StrLen(A_LoopField) + 1
		; ��ȡ����ѭ�����ҵ��ķָ���.  
		Delimiter := SubStr(CandySel, Position, 1)
		str1:= Format("{:T}", A_LoopField)
		out:=out . str1 . Delimiter 
	}  
	Clipboard :=out  
	Send,^v
	Sleep,500
	Clipboard := Candy_Saved_ClipBoard
	out :=Candy_Saved_ClipBoard:=Position:=""
Return

Cando_�ȺŶ���:
	LimitMax:=30     ;��೬���ó���ʱ�����в�������룬�����ֿ������޸�
	MaxLen:=0
	StrSpace:=" "
	Loop,% LimitMax+1
		StrSpace .=" "
	Aligned:=
	loop, parse, CandySel, `n,`r                   ;������������ĳ��ȣ��Ա���������
	{
		IfNotInString,A_loopfield,=              ;����û�еȺţ���
			Continue
		ItemLeft :=RegExReplace(A_LoopField,"\s*(.*?)\s*=.*$","$1")        ;����Ŀ�� �Ⱥ� ��ಿ��
		ThisLen:=StrLen(regexreplace(ItemLeft,"[^\x00-\xff]","11"))       ;�������ĳ���
		MaxLen:=( ThisLen > MaxLen And ThisLen <= LimitMax) ? ThisLen : MaxLen       ;�õ�С��LimitMax�ڵ����ĳ��ȣ���������ճ���
	}
	loop, parse, CandySel, `n,`r
	{
		IfNotInString,A_loopfield,=
		{
			Aligned .= A_loopfield "`r`n"
			Continue
		}
        ItemLeft:=trim(RegExReplace(A_LoopField,"\s*=.*?$") )        ;����Ŀ�� �Ⱥ� ��ಿ��
        Itemright:=trim(RegExReplace(A_LoopField,"^.*?=")  )          ;����Ŀ�� �Ⱥ� �Ҳಿ��
        ThisLen:=StrLen(regexreplace(ItemLeft,"[^\x00-\xff]","11"))   ;�������ĳ���
        if ( ThisLen> MaxLen )       ;���������������󳤶ȣ�ע������󳤶ȣ�������LimitMax���򲻲������
        {
            Aligned .= ItemLeft  "= " Itemright "`r`n"
            Continue
        }
        Else
        {
            Aligned .= ItemLeft . SubStr( StrSpace, 1, MaxLen+2-ThisLen ) "= " Itemright "`r`n"        ;�ô����Ҳ�Ⱥź������һ���ո񣬸��������ɾ
        }
    }
    Aligned:=RegExReplace(Aligned,"\s*$","")   ;˳��ɾ�����Ŀհ��У��ɸ�������ע�͵�
    clipboard := Aligned
    Send ^v
    Return