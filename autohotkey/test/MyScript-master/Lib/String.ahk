; wString		ת����õ���unicode�ִ�
; sString		��ת���ִ�
; CP				��ת���ִ�sString�Ĵ���ҳ
; ����ֵ		ת����õ���unicode�ִ�,wString�ĵ�ַ
; �ú���ӳ��һ���ַ��� (MultiByteStr) ��һ�����ַ� (unicode UTF-16) ���ַ��� (WideCharStr)��
; �ɸú���ӳ����ַ���û��Ҫ�Ƕ��ֽ��ַ��顣
; &sString ������ǵ�ַ������ sString ��������ֱ�Ӵ����ַ
/* 
; A����������
pp=����
Ansi2Unicode(qq,pp,936) ; ��ȷ
Ansi2Unicode(qq,&pp,936) ; ����
*/
;cp=65001 UTF-8   cp=0 default to ANSI code page
Ansi2Unicode(ByRef wString, ByRef sString,  CP = 0)
{
	nSize := DllCall("MultiByteToWideChar", "Uint", CP, "Uint", 0, "Uint", &sString, "int",  -1, "Uint", 0, "int", 0)
	VarSetCapacity(wString, nSize * 2,0)
	DllCall("MultiByteToWideChar", "Uint", CP, "Uint", 0, "Uint", &sString, "int",  -1, "Uint", &wString, "int", nSize)
Return	&wString
}

; wString		��ת����unicode�ִ�  
; sString		ת����õ����ִ�
; CP				ת����õ����ִ�sString�Ĵ���ҳ������ CP=65001��ת���õ����ִ�����UTF8���ַ���
; ����ֵ		ת����õ����ִ�sString
; �ú���ӳ��һ�����ַ��� (unicode UTF-16) ��һ���µ��ַ���
; �ѿ��ַ��� (unicode UTF-16) ת����ָ������ҳ�����ַ���
; &wString ������ǵ�ַ������wString��������ֱ�Ӵ����ַ
/* 
; U����������
qq=����
Unicode2Ansi(qq,pp,936) ; ��ȷ
Unicode2Ansi(&qq,pp,936) ; ����
*/
Unicode2Ansi(ByRef wString,ByRef sString,  CP = 0)
{
	nSize := DllCall("WideCharToMultiByte", "Uint", CP, "Uint", 0, "Uint", &wString, "int", -1, "Uint", 0, "int",  0, "Uint", 0, "Uint", 0)
	VarSetCapacity(sString, nSize)
	DllCall("WideCharToMultiByte", "Uint", CP, "Uint", 0, "Uint", &wString, "int", -1, "str", sString, "int", nSize, "Uint", 0, "Uint", 0)
	Return	sString
}

; Unicode2Ansi pString �� sString
; pString �ǵ�ַ��������ֱ�Ӵ����ַ
/* 
; ��
pp=����
Ansi4Unicode(&pp)
*/
Ansi4Unicode(pString, nSize = "")
{
	If (nSize = "")
		nSize:=DllCall("kernel32\WideCharToMultiByte", "Uint", 0, "Uint", 0, "Uint", pString, "int", -1, "Uint", 0, "int",  0, "Uint", 0, "Uint", 0)
	VarSetCapacity(sString, nSize)
	DllCall("kernel32\WideCharToMultiByte", "Uint", 0, "Uint", 0, "Uint", pString, "int", -1, "str", sString, "int", nSize + 1, "Uint", 0, "Uint", 0)
Return	sString
}

; Ansi2Unicode  sString �� wString
Unicode4Ansi(ByRef wString, sString, nSize = "")
{
	If (nSize = "")
		nSize:=DllCall("kernel32\MultiByteToWideChar", "Uint", 0, "Uint", 0, "Uint", &sString, "int", -1, "Uint", 0, "int", 0)
	VarSetCapacity(wString, nSize * 2 + 1)
	DllCall("kernel32\MultiByteToWideChar", "Uint", 0, "Uint", 0, "Uint", &sString, "int", -1, "Uint", &wString, "int", nSize + 1)
Return	&wString
}

; UrlEncode("���|����", "cp20936")
; cp936			�������� GBK GB2312
; cp10002		MAC���ϵ�big5���룬
; cp950			�������� big5
UrlEncode(Url, Enc = "UTF-8")
{
	StrPutVar(Url, Var, Enc)
	f := A_FormatInteger
	SetFormat, IntegerFast, H
	Loop
	{
		Code := NumGet(Var, A_Index - 1, "UChar")
		If (!Code)
			Break
		If (Code >= 0x30 && Code <= 0x39 ; 0-9
		|| Code >= 0x41 && Code <= 0x5A ; A-Z
		|| Code >= 0x61 && Code <= 0x7A) ; a-z
			Res .= Chr(Code)
		Else
			Res .= "%" . SubStr(Code + 0x100, -1)
	}
	SetFormat, IntegerFast, %f%
Return, Res
}

SkSub_UrlEncode(str, enc="UTF-8")       ;From Ahk Forum
{
    enc:=trim(enc)
    If enc=
        Return str
   hex := "00", func := "msvcrt\" . (A_IsUnicode ? "swprintf" : "sprintf")
   VarSetCapacity(buff, size:=StrPut(str, enc)), StrPut(str, &buff, enc)
   While (code := NumGet(buff, A_Index - 1, "UChar")) && DllCall(func, "Str", hex, "Str", "%%%02X", "UChar", code, "Cdecl")
   encoded .= hex
   Return encoded
}

UrlDecode(Url, Enc = "UTF-8")
{
	Pos := 1
	Loop
	{
		Pos := RegExMatch(Url, "i)(?:%[\da-f]{2})+", Code, Pos++)
		If (Pos = 0)
			Break
		VarSetCapacity(Var, StrLen(Code) // 3, 0)
		StringTrimLeft, Code, Code, 1
		Loop, Parse, Code, `%
			NumPut("0x" . A_LoopField, Var, A_Index - 1, "UChar")
		StringReplace, Url, Url, `%%Code%, % StrGet(&Var, Enc), All
	}
Return, Url
}

StrPutVar(Str, ByRef Var, Enc = "")
{
	Len := StrPut(Str, Enc) * (Enc = "UTF-16" || Enc = "CP1200" ? 2 : 1)
	VarSetCapacity(Var, Len, 0)
Return, StrPut(Str, &Var, Enc),VarSetCapacity(var,-1)
}

; http://ahkcn.net/thread-1927.html
UnicodeDecode(text)
{
    while pos := RegExMatch(text, "\\u\w{4}")
    {
        tmp := UrlEncodeEscape(SubStr(text, pos + 2, 4))
        text := RegExReplace(text, "\\u\w{4}", tmp, "", 1)
    }
    return text
}

; http://ahkcn.net/thread-1927.html
UrlEncodeEscape(text)
{
    text := "0x" . text
    VarSetCapacity(LE, 2, "UShort")
    NumPut(text, LE)
    return StrGet(&LE, 2)
}

; �������ģ��������뷨Ӱ�� �����ݣ����� SendStr ���棩
_SendRaw(Keys)
{
	Len := StrLen(Keys) ; �õ��ַ����ĳ��ȣ�ע��һ�������ַ��ĳ�����2
	KeysInUnicode := "" ; ��Ҫ���͵��ַ�����
	Char1 := "" ; �ݴ��ַ�1
	Code1 := 0 ; �ַ�1��ASCII�룬ֵ���� 0x0-0xFF (��1~255)
	Char2 := "" ; �ݴ��ַ�2
	Index := 1 ; ����ѭ��
	Loop
	{
		Code2 := 0 ; �ַ�2��ASCII��
		Char1 := SubStr(Keys, Index, 1) ; ��һ���ַ�
		Code1 := Asc(Char1) ; �õ���ASCIIֵ
		if(Code1 >= 129 And Code1 <= 254 And Index < Len) ; �ж��Ƿ������ַ��ĵ�һ���ַ�
		{
			Char2 := SubStr(Keys, Index+1, 1) ; �ڶ����ַ�
			Code2 := Asc(Char2) ; �õ���ASCIIֵ
			if(Code2 >= 64 And Code2 <= 254) ; ������������˵���������ַ�
			{
				Code1 <<= 8 ; ��һ���ַ�Ӧ�ŵ���8λ��
				Code1 += Code2 ; �ڶ����ַ����ڵ�8λ��
			}
			Index++
		}
		if(Code1 <= 255) ; �����ֵ��<=255��˵���Ƿ������ַ������򾭹�����Ĵ����Ȼ����255
			Code1 := "0" . Code1
		KeysInUnicode .= "{ASC " . Code1 . "}"
		if(Code2 > 0 And Code2 < 64)
		{
			Code2 := "0" . Code2
			KeysInUnicode .= "{ASC " . Code2 . "}"
		}
		Index++
		if(Index > Len)
			Break
	}
	Send % KeysInUnicode
}

; http://ahk8.com/thread-5385.html
; �������ģ��������뷨Ӱ��
SendStr(String)
{
	if(A_IsUnicode)
	{
		Loop, Parse, String
			ascString .= (Asc(A_loopfield)>127 )? A_LoopField : "{ASC 0" . Asc(A_loopfield) . "}"
	}
	else     ;�����Unicode
	{
		z:=0
		Loop,parse,String
		{
			if RegExMatch(A_LoopField, "[^x00-xff]")
			{
				if (z=1)
				{
					x<<= 8
					x+=Asc(A_loopfield)
					z:=0
					ascString .="{ASC 0" . x . "}"
				}
				else
				{
					x:=asc(A_loopfield)
					z:=1
				}
			}
			else
			{
				ascString .="{ASC 0" . Asc(A_loopfield) . "}"
			}
		}
	}
	SendInput %ascString%
}

; �� �� ��
fzj(trc)
{
	tmp1:= A_IsUnicode ? trc : Ansi2Unicode(tmp1, trc, 936)
	VarSetCapacity(tmp2, 2*cch:=VarSetCapacity(tmp1)//2), LCMAP_SIMPLIFIED_CHINESE:=0x02000000 
	DllCall( "LCMapStringW", UInt,0x400, UInt,LCMAP_SIMPLIFIED_CHINESE, Str,tmp1, UInt,cch, Str,tmp2, UInt,cch )
return A_IsUnicode ? tmp2 : Unicode2Ansi(tmp2, spc, 936)
}

; �� �� ��
jzf(spc)
{
	tmp1:= A_IsUnicode ? spc : Ansi2Unicode(tmp1, spc, 936)
	VarSetCapacity(tmp2, 2*cch:=VarSetCapacity(tmp1)//2), LCMAP_TRADITIONAL_CHINESE := 0x4000000
	DllCall( "LCMapStringW", UInt,0x400, UInt,LCMAP_TRADITIONAL_CHINESE, Str,tmp1, UInt,cch, Str,tmp2, UInt,cch )
return A_IsUnicode ? tmp2 : Unicode2Ansi(tmp2, trc,936)
}

; �����ֽ�ȡ���ַ����������ɾ��һ���ֽڣ���һ���ո�
SubStrByByte(text, length)
{
    textForCalc := RegExReplace(text, "[^\x00-\xff]", "`t`t")
    textLength := 0
    realRealLength := 0

    Loop, Parse, textForCalc
    {
        if (A_LoopField != "`t")
        {
            textLength++
            textRealLength++
        }
        else
        {
            textLength += 0.5
            textRealLength++
        }

        if (textRealLength >= length)
        {
            break
        }
    }

    result := SubStr(text, 1, round(textLength - 0.5))

    ; ɾ��һ�����֣���һ���ո�
    if (round(textLength - 0.5) != round(textLength))
        result .= " "

    return result
}

; https://autohotkey.com/board/topic/33510-functionstringcheck/
InStrW(String, Text0)
{
	RegExReplace(Asc(SubStr(String, Pos0 := InStr(String, Text0), 1)) > 127 ? SubStr(String, 1, Pos0+1) : SubStr(String, 1, Pos0), "(?:[^[:ascii:]]{2}|[[:ascii:]])", "", ErrorLevel)
return ErrorLevel
}

SubStrW(String, Pos0, Len0 = 360)
{
	RegExMatch(String, "(?:[^[:ascii:]]{2}|[[:ascii:]]){" (Pos0 > 0 ? Pos0-1 : -Pos0 < (StrLenW := StrLenW(String)) ? StrLenW+Pos0-1 : 0) "}((?:[^[:ascii:]]{2}|[[:ascii:]]){0," Len0 "})", SubStrW)
return SubStrW1
}

StrLenW(String)
{
	RegExReplace(String, "(?:[^[:ascii:]]{2}|[[:ascii:]])", "", ErrorLevel)
return ErrorLevel
}

SubStr0(String, Pos0, Len0 = 360, StrCheck = 3)
{
	If (Pos0 <> 1 && Pos0+StrLen(String) <> 1 && StrLenW(String0 := SubStr(String, 1, Pos0 > 0 ? Pos0-1 : StrLen(String) + Pos0 - 1)) = StrLenW(SubStr(String0, 1, StrLen(String0)-1)))
		Len0 := Mod(StrCheck, 2) = 1 ? Len0 + 1 : Pos0 = 0 ? 0 : Len0 - 1, Pos0 := Mod(StrCheck, 2) = 1 ? Pos0 - 1 : Pos0 + 1
return SubStr(String, Pos0, (StrLenW(SubStr(String, Pos0, Len0-1)) = StrLenW(SubStr(String, Pos0, Len0))) ? StrCheck // 2 = 1 ? Len0+1 : Len0-1 : Len0)
}

StrCheck(String)
{
return RegExReplace(String, "^[^[:ascii:]]?((?:[^[:ascii:]]{2})*(?:[[:ascii:]].*[[:ascii:]]|[[:ascii:]])(?:[^[:ascii:]]{2})*)[^[:ascii:]]?$", "$1")
}

/*
Original script author: ahklerner
autohotkey.com/board/topic/15831-convert-string-to-hex/?p=102873
*/
StringToHex(String)
{
	formatInteger := A_FormatInteger 	;Save the current Integer format
	SetFormat, Integer, Hex ; Set the format of integers to their Hex value
	
	;Parse the String
	Loop, Parse, String 
	{
		CharHex := Asc(A_LoopField) ; Get the ASCII value of the Character (will be converted to the Hex value by the SetFormat Line above)
		StringTrimLeft, CharHex, CharHex, 2 ; Comment out the following line to leave the '0x' intact
		HexString .= CharHex ;. " "     ; Build the return string
	}
	SetFormat, Integer,% formatInteger ; Set the integer format to what is was prior to the call
	
	HexString = %HexString% ; Remove blankspaces	
Return HexString
}

toHex( ByRef V, ByRef H, dataSz:=0 )
{ ; http://goo.gl/b2Az0W (by SKAN)
	P := ( &V-1 ), VarSetCapacity( H,(dataSz*2) ), Hex := "123456789ABCDEF0"
	Loop, % dataSz ? dataSz : VarSetCapacity( V )
		H  .=  SubStr(Hex, (*++P >> 4), 1) . SubStr(Hex, (*P & 15), 1)
}

ZTrim( N := "" )
{ ; SKAN /  CD:01-Jul-2017 | LM:03-Jul-2017 | Topic: goo.gl/TgWDb5
	Local    V  := StrSplit( N, ".", A_Space ) 
	Local    V0 := SubStr( V.1,1,1 ),   V1 := Abs( V.1 ),      V2 :=  RTrim( V.2, "0" )
Return ( V0 = "-" ? "-" : ""   )  ( V1 = "" ? 0 : V1 )   ( V2 <> "" ? "." V2 : "" )
}