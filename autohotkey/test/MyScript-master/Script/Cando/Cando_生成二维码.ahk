Cando_���ɶ�ά��:
	Gui,66:Default
	Gui,Destroy
GUI,pic:Add,Pic,x20 y20 w500 h-1 hwndhimage,% f:=GEN_QR_CODE(CandySel)
GUI,pic:Add,Text,x20 y542 h24,��Escȡ��
GUI,pic:Add,Button,x420 y540 w100 h24 gSaveAs,���Ϊ(&S)
GUI,pic:Show,w540 h580
return

SaveAs:
  Fileselectfile,nf,s16,,���Ϊ,PNGͼƬ(*.png)
  If not strlen(nf)
    return
  nf := RegExMatch(nf,"i)\.png") ? nf : nf ".png"
  Filecopy,%f%,%nf%,1
return

GEN_QR_CODE(string,file="")
{
  sFile := strlen(file) ? file : A_Temp "\" A_NowUTC ".png"
  DllCall( A_ScriptDir "\quricol32.dll\GeneratePNG","str", sFile , "str", string, "int", 4, "int", 2, "int", 0)
  Return sFile
}
