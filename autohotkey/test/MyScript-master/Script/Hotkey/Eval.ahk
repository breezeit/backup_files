;#IfWinActive,��ק�ƶ��ļ���Ŀ���ļ��У��Զ���������
;* ����==��ʱ�Զ�����������Ҫ��ֹ��������B0 ������ɾ��==
:?B0*:==::
If(IME_GetSentenceMode(_mhwnd())= 0)
; ��� IME ״̬����������ʱ��ִ���κ����
{
;tooltip,% IME_GetSentenceMode(_mhwnd())
sleep,400
Return
}
Else
{
V := ClipboardAll
Clipboard :=
;����
Send, +{Home}^c
;����
;Send, +{Home}^x
ClipWait, 0.5
StringReplace, Clipboard, Clipboard,==,,all
q:=% ZTrim( Eval(Clipboard) )
;�Ƿ�����ʽ
;Send, {end}=
SendInput,%q%
Clipboard := V
q:=
}
Return
;#IfWinActive

Eval(x)
{
x := RegExReplace(x,"(.*)=")
x := RegExReplace(x,"\s*")
x := RegExReplace(x,"([\d\)])\-","$1#")
Loop
{
If !RegExMatch(x, "(.*)\(([^\(\)]*)\)(.*)", y)
        Return % RegExReplace(Eval_(x),"\.+0*$")
x := y1 Eval_(y2) y3
}
}
Eval_(x)
{
RegExMatch(x, "(.*)(\+|\#)(.*)", y)
IfEqual y2,+, Return Eval_(y1) + Eval_(y3)
IfEqual y2,#, Return Eval_(y1) - Eval_(y3)
RegExMatch(x, "(.*)(\*|\/|\%)(.*)", y)
IfEqual y2,*, Return Eval_(y1) * Eval_(y3)
IfEqual y2,/, Return Eval_(y1) / Eval_(y3)
IfEqual y2,`%, Return Mod(Eval_(y1),Eval_(y3))
RegExMatch(x, "(.*\d)(e)(.*)", y)
IfEqual y2,e, Return Eval_(y1)*10**Eval_(y3)
StringGetPos i, x, ^, R
IfGreaterOrEqual i,0, Return Eval_(SubStr(x,1,i)) ** Eval_(SubStr(x,2+i))
If !RegExMatch(x,"i)(abs|round|ceil|floor|exp|sqrt|ln|log|sin|cos|tan|tg|ctg|sec|csc|asin|acos|random|hex|d|r|pi)(.*)", y) ;��֧�ֵĺ��������д����,�����ԭ�����ּ򵥵�Ҫ��������
        Return x
If y1=random
{
        Random, z, 0, y2
        Return z
}
If y1=hex
{
        SetFormat, integer, d
        z := y2+0
        SetFormat, integer, hex
        Return z
}
IfEqual y1, tg,                Return tan(Eval_(y2))
IfEqual y1, ctg,                Return 1/tan(Eval_(y2))
IfEqual y1, sec,                Return asin(Eval_(y2))
IfEqual y1, csc,                Return acos(Eval_(y2))
IfEqual y1, d,                Return Eval_(y2)*57.295779513
IfEqual y1, r,                Return Eval_(y2)/57.295779513
IfEqual y1, pi,        Return 3.141592654
Return %y1%(Eval_(y2))
}

/* ��ʽ����
http://forum.ahkbbs.cn/thread-1945-1-1.html
1��������ȥ�������С�����0�Ĺ��ܣ����Ÿ�ֱ��
2��Sendģʽ��ΪSendInput ���Կ�һ����ʾ
3��e���ٱ�ʾ2.718������ôʵ��,��Ϊ��ѧ����������3.1e-2=0.031
4��������ʮ������ת���Ĵ��� ���ڲ��� hex12=0xc
5.   ��Send, +{Home}^c{right}=��ΪSend, +{Home}^x{right} ���ճ�ʹ������ֻҪ��������������������ͬ��ȣ������ü����滻���ơ�
6.  ��:?*:=?::��Ϊ:?*:=\::,���ִ�����,���빫ʽ����=\����
7.  ����ʹ��%������ʹ��^��(������ ^-1������^0.5������ƽ��������Ȼ i �ǲ�֧�ֵ�)
        ����ֵabs����������round������ȡ��ceil������ȡ��floor��
        e��N����exp������ƽ����sqrt����Ȼ����ln�����ö���log��
        ����sin������cos������tan��tg������ctg������sec��asin�����csc��acos�����Ǻ�������ʹ�û��ȣ���
        �����random������������������С����С������
        ת��Ϊʮ������hex��hex12=0xc��
        ����ת�Ƕ�d����d pi=180.000000���Ƕ�ת����r����r45=0.785398����
        ����pi=3.141592654��e=2.718281828
        �������Ȳ���������Լ��ģ����������ٿ����Լ�����
8.   ʮ�����ƿ���ֱ�Ӽ��㣬�� 0xFF/5=51.000000��ע�����ʹ�á����෴�����İ취���� 0xCC+-12=192��ֱ��ת��Ϊ10�����ü�0�İ취���� 0xFFFFFF+0=16777215
9.   ���������ȼ��Ǵ���������ģ����磺round5.5^2=36
*/

_mhwnd(){	;background test
	;MouseGetPos,x,,hwnd
	Hwnd := WinActive("A")
	Return "ahk_id " . hwnd
}