Cando_ʮ����ʮ������ת��:
	Gui,66:Default
	Gui,Destroy
	Gosub,NumCon
	Gui, add, text,x5 y5,����:
	Gui,add,Edit,x70 y5 w300 h20 vNumSel,%CandySel%
	Gui,add,button,x380 y5 w60 h20  gNumSwap,���ֽ���

	Gui, add, text,x5 y35 ,ʮ����:
	Gui,add,Edit,x70  y35 w300 h20 vNumDec,% Trim(NumDec)
	Gui,add,button,x380 y35 w60 h20  gNumDectoHex,16 ����

	Gui, add, text,x5 y65 ,ʮ������:
	Gui,add,Edit,x70 y65 w300 h20 vNumHex,% Trim(NumHex)
	Gui,add,button,x380 y65 w60 h20  gNumHextoDec,10 ����

	Gui,show,,ʮ����ʮ������ת��
Return

NumCon:
	If CandySel Is digit
	{
		NumDec:=CandySel
		NumHex:=dec2hex(CandySel)
	}
	Else If CandySel Is Xdigit
	{
		numtemp:=InStr(CandySel, "0x")?CandySel:"0x" CandySel
		NumDec:=hex2dec(numtemp)
		NumHex:=numtemp
	}
	numtemp=
Return

NumDectoHex:
	Gui, Submit, NoHide
	NumHex:=dec2hex(NumDec)
	GuiControl, , NumHex, % NumHex
	GuiControl, , NumSel
Return

NumHextoDec:
	Gui, Submit, NoHide
	numtemp:=InStr(NumHex, "0x")?NumHex:"0x" NumHex
	NumDec:=hex2dec(numtemp)
	GuiControl, , NumDec, % NumDec
	GuiControl, , NumSel
Return

NumSwap:
	Gui, Submit, NoHide
	GuiControl, , NumDec, % NumHex
	GuiControl, , NumHex, % NumDec
Return