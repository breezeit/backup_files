StrAr_Add(Str,It) ;���Ԫ��
{
	ReturnVal=%Str%|%It%
	Return ReturnVal
}

StrAr_Get(Str,witch) ;����Ԫ��
{
	global Spliter
	
	Str:=_StrAr_Format(Str)
	Pos1:=0
	Loop %witch%
	{
		StringGetPos,Pos1,Str,|,,Pos1
		Pos1++
	}
	StringLeft,Var,Str,Pos1-1
;~ 	MsgBox %Var%
	StringGetPos,Pos2,Var,|,R
;~ 	MsgBox %Var% %Pos2%
	Dis:=Pos1-Pos2-2
;~ 	MsgBox %Pos2%-%Pos1%=%Dis%
	StringRight,Var,Var,Dis
;~ 	MsgBox [%Var%]
	Return Var	
}

StrAr_Find(Str,item) ;�����ҵ��ƶ�Ԫ�صĴ���
{
;~ 	MsgBox %Str% [%item%]
	StringReplace,Str,Str,%item%,%item%,UseErrorLevel
	Return ErrorLevel
}

StrAr_Size(Str) ;����Ԫ�ظ���
{
	Str:=_StrAr_Format(Str)
;~ 	MsgBox %Str%
	Count:=0
	Pos:=1
	Loop
	{
		pos:=RegExMatch(Str,"\|",a,Pos+1)
		IfEqual,pos,0,break
		Count++		
;~ 		MsgBox %Count% %pos%
	}
;~ 	MsgBox %Count% 
	Return Count	
}
_StrAr_Format(Str)	;���ַ���ʽ��Ϊ A|B|C| ����ı�׼��ʽ
{
;~ 	MsgBox %Str%
	V:=Str
	StringLeft,VL,Str,1		;��ȡ��ߵ�һ���ַ�	
	StringRight,VR,Str,1	;��ȡ�ұߵ�һ���ַ�
	If(VL="|")
	{
		StringTrimLeft,V,V,1
	}
	If(VR<>"|")
	{
		V=%V%|
	}
	
	StringReplace,V,V,||,|,All
;~ 	MsgBox %V%
	Return V
}


StrAr_Delet(Str,index) ;ɾ��
{
	Str:=_StrAr_Format(Str)
	Element:=StrAr_Get(Str,index)
	Element=%Element%|
	StringReplace,NewStr,Str,%Element%
	Return NewStr
}

StrAr_DeletElement(Str,Element,IsAll=0) ;ɾ��Ԫ��
{
	Str:=_StrAr_Format(Str)
	If (Element="")
	{
		Return Str
	}
	Element=%Element%|
	If IsAll
	{
		StringReplace,NewStr,Str,%Element%,,All
	}
	Else
	{
		StringReplace,NewStr,Str,%Element%
	}
	Return NewStr
}

;~ b=|1|2|3|4|5|6|7|8|9

;~ MsgBox % StrAr_DeletElement(b,"")

;~ If StrAr_Find(b,"1")
;~ {
;~ 	MsgBox
;~ }

;~ a=0x110460
;~ item:=StrAr_Get(a,1)
;~ MsgBox %item%


;~ b=Alt+������|Alt+������|Ctrl+������|Ctrl+������|���+�Ҽ�|�Ҽ�+���|�м�
;~ b=1232p1234p3453p4562

;~ b=|1234
;~ size:=StrAr_Size(b)


;~ b:=StrAr_Delet(b,2)
;~ b:=StrAr_Get(b,2)
;~ b:=StrAr_DeletElement(b,"Ctrl+������")
;~ MsgBox %b%


;~ b=Alt+������|Alt+������|Ctrl+������|Ctrl+������|���+�Ҽ�|�Ҽ�+���|�м�
;~ StringGetPos,V,b,|
;~ MsgBox %V%
;~ aa=Cb3

;~ If aa In Cb1,Cb2
;~ {
;~ 	MsgBox
;~ }