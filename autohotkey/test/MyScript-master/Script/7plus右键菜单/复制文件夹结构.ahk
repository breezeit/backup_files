1005:
	SetTimer,copyfolderStructure,-200
Return

;�����ļ��нṹ���������ļ����е��ļ�
copyfolderStructure:
sleep,2000
Critical,On
Files := GetSelectedFiles()
If !Files
{
	MsgBox,,,��ȡ�ļ�·��ʧ��3��,3
Return
}
Critical,Off

Files:=Files . "\"
CopyDirStructure(Files,A_Desktop,1)
Return

CopyDirStructure(_inpath,_outpath,_i=true) {
   If (_i) {
      SplitPath, _inpath,,_indir
      _indir := SubStr(_indir, Instr(_indir,"\",false,0)+1,(StrLen(_indir)-Instr(_indir,"\",false,0)))
      _outpath := _outpath (SubStr(_outpath,0,1)="\" ? "" : "\") . _indir
      FileCreateDir, %_outpath%
      If errorlevel
         Return errorlevel
   }
   Loop, %_inpath%\*.*, 2, 1
   {
      StringReplace, _temp, A_LoopFileLongPath, %_inpath%,,All
      FileCreateDir, %_outpath%\%_temp%
      If errorlevel
         _problem = 1
   }
   Return _problem
}