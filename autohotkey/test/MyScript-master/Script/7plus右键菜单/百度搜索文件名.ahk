;����lnk�ļ���Ч(����lnk�ļ�����Ч)
1004:
	SetTimer,searchthefile,-200
Return

;����lnk�ļ���Ч  Why
;�ٶ������ļ���
searchthefile:
sleep,2000
Critical,On
Files := GetSelectedFiles()
If !Files
{
	MsgBox,,,��ȡ�ļ�·��ʧ��1��,3
Return
}
Critical,Off

Loop, Parse, files, `n,`r
fullpath := A_LoopField

splitpath,fullpath,filename,dir,,filenameNoExt
run,http://www.baidu.com/s?wd=%filenameNoExt%
Return