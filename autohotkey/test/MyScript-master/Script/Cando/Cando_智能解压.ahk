cando_���ܽ�ѹ:
	SmartUnZip_�ײ����ļ���־:=0
	SmartUnZip_�ײ����ļ��б�־:=0
	SmartUnZip_�ײ��ļ�����:=
	SmartUnZip_�ļ�����A:=
	SmartUnZip_�ļ�����B:=

	���б�=%A_Temp%\wannianshuyaozhinengjieya_%A_Now%.txt

	SplitPath ,CandySel,,��Ŀ¼,,���ļ���,IntUnZip_FileDrive
	DriveSpaceFree , IntUnZip_FreeSpace, %IntUnZip_FileDrive%
FileGetSize, IntUnZip_FileSize, %CandySel%, M
	If ( IntUnZip_FileSize > IntUnZip_FreeSpace )
	{
		MsgBox ���̿ռ䲻��,������ٽ�ѹ��`n------------`nѹ������СΪ%IntUnZip_FileSize%M`nʣ��ռ�Ϊ%IntUnZip_FreeSpace%M
		Return
	}
	RunWait, %comspec% /c ""%7Z%" l "%CandySel%" `>"%���б�%"",,hide

;������������������������������������������������������������������������������������������������������������������������
	loop,read,%���б�%
	{
		If(RegExMatch(A_LoopReadLine,"^(\d\d\d\d-\d\d-\d\d)"))
		{
			If( InStr(A_loopreadline,"D")=21 Or InStr(A_loopreadline,"\"))  ;�����������\������D��־�����ж�Ϊ�ļ���
			{
				SmartUnZip_�ײ����ļ��б�־=1
			}

			If InStr(A_loopreadline,"\")
				StringMid,SmartUnZip_�ļ�����A,A_LoopReadLine,54,InStr(A_loopreadline,"\")-54
			Else
				StringTrimLeft,SmartUnZip_�ļ�����A,A_LoopReadLine,53

			If((SmartUnZip_�ļ�����B != SmartUnZip_�ļ�����A ) And ( SmartUnZip_�ļ�����B!="" ))
			{
				SmartUnZip_�ײ����ļ���־=1
				Break
			}
			SmartUnZip_�ļ�����B:=SmartUnZip_�ļ�����A
		}
	}
	FileDelete,%���б�%
; 	MsgBox SmartUnZip_�ײ����ļ���־%SmartUnZip_�ײ����ļ���־%
; 	MsgBox SmartUnZip_�ײ����ļ��б�־%SmartUnZip_�ײ����ļ��б�־%
; 	MsgBox SmartUnZip_�ļ�����A%SmartUnZip_�ļ�����A%
;������������������������������������������������������������������������������������������������������������������������

	If(SmartUnZip_�ײ����ļ���־=0 && SmartUnZip_�ײ����ļ��б�־=0 )   ;ѹ���ļ��ڣ��ײ����ҽ���һ���ļ�
	{
		Run, %7ZG% x "%CandySel%" -o"%��Ŀ¼%"    ;���ǻ��Ǹ���������7z
	}

	Else If(SmartUnZip_�ײ����ļ���־=0 && SmartUnZip_�ײ����ļ��б�־=1 )   ;ѹ���ļ��ڣ��ײ����ҽ���һ���ļ���
	{
		IfExist,%��Ŀ¼%\%SmartUnZip_�ļ�����A%   ;�Ѿ��������ԡ��ײ��ļ������������ļ��У���ô�죿
		{
			Loop
			{
				SmartUnZip_NewFolderName=%��Ŀ¼%\%SmartUnZip_�ļ�����A%( %A_Index% )
				If !FileExist( SmartUnZip_NewFolderName )
				{
; 					MsgBox %SmartUnZip_NewFolderName%
					Run, %7ZG% x "%CandySel%"   -o"%SmartUnZip_NewFolderName%"
					break
				}
			}
			; Run, %7ZG% x "%CandySel%"   -o"%��Ŀ¼%\%SmartUnZip_�ļ�����A%_%A_now%"
		}
		Else  ;û�С��ײ��ļ������������ļ��У��Ǿ�̫����
		{
			Run, %7ZG% x "%CandySel%" -o"%��Ŀ¼%"
		}
	}
	Else  ;ѹ���ļ��ڣ��ײ��ж���ļ���
	{
		IfExist %��Ŀ¼%\%���ļ���%  ;�Ѿ��������ԡ����ļ��������ļ��У���ô�죿
		{
			Loop
			{
				SmartUnZip_NewFolderName=%��Ŀ¼%\%���ļ���%( %A_Index% )
				If !FileExist( SmartUnZip_NewFolderName )
				{
; 					MsgBox %SmartUnZip_NewFolderName%
					Run, %7ZG% x "%CandySel%"   -o"%SmartUnZip_NewFolderName%"
					break
				}
			}
; 			Run, %7ZG% x  "%CandySel%" -o"%��Ŀ¼%\%���ļ���%_%A_now%"
		}
		Else ;û�У��Ǿ�̫����
		{
			Run, %7ZG% x  "%CandySel%" -o"%��Ŀ¼%\%���ļ���%"
		}
	}
	Return