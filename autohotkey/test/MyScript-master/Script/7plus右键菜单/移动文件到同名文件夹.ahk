;����lnk�ļ���Ч(����lnk�ļ�����Ч)
1003:
	;MsgBox
	SetTimer,�ƶ��ļ���ͬ���ļ���,-200
Return

;�ļ��ƶ���ͬ���ļ�����
;����lnk�ļ���Ч  �޷����lnk ��׺
;����ݼ�Ϊ���Ϊ G:\Users\lyh\Desktop\QQ  ʵ��ΪQQ.lnk
;#G::
�ƶ��ļ���ͬ���ļ���:
sleep,2000
Critical,On
Files := GetSelectedFiles()
If !Files
{
	MsgBox,,,��ȡ�ļ�·��ʧ��4��,3
	Return
}
Critical,Off

Loop, Parse, files, `n,`r
{
	FileFullPath := A_LoopField
	SplitPath,FileFullPath,FileName,FilePath,FileExtension,FileNameNoExt
	creatfolder = %FilePath%\%FileNameNoExt%
	IfNotExist %creatfolder%
	{
		FileCreateDir,%creatfolder%
		FileMove,%FileFullPath%,%creatfolder%
	}
	else
	{
		TargetFile = %creatfolder%\%FileName%
		ifExist, %TargetFile%
		{
			ind = 1
			Loop, 100
			{
				TargetFile = %creatfolder%\%FileNameNoExt%_(%ind%).%FileExtension%
				ifExist, %TargetFile%
				{
					ind += 1
					continue
				}
				else
				{
					Run, %comspec% /c move "%FileFullPath%" "%TargetFile%"
					break
				}
			}
		}
		; ��ͬ���ļ�ʱ�������ļ�
		else
		{
			Run, %comspec% /c move "%FileFullPath%" "%TargetFile%"
		}
	}
}
Return