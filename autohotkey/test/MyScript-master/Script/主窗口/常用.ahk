changyong:
Menu, f_Folders, Add, &C:\, C:\
Menu, f_Folders, Add, &D:\, D:\
Menu, f_Folders, Add, &E:\, E:\
Menu, f_Folders, Add, �ҵ��ĵ�, �ҵ��ĵ�
Menu, f_Folders, Add, �����ļ���, �����ļ���

Menu, tabs, Add, �ļ���(&F), :f_Folders
Menu, tabs, Add, �ҵĵ���(&C), �ҵĵ���
Menu, tabs, Add, ��������(&N), ��������
Menu, tabs, Add, �������(&P), �������
Menu, tabs, Add, ����վ(&R), ����վ
Menu, tabs, Add
Menu, tabs, Add, ע��(&L),ע��
Menu, tabs, Add, ����(&D),����
Menu, tabs, Add, ����(&U),����
Menu, tabs, Add, �ػ�(&S),�ػ�
Menu, tabs,Show
Menu, tabs,Deleteall
Return

�ҵĵ���:
Run ::{20d04fe0-3aea-1069-a2d8-08002b30309d}
Return

��������:
run ::{7007ACC7-3202-11D1-AAD2-00805FC1270E}
Return

�������:
Run ::{20D04FE0-3AEA-1069-A2D8-08002B30309D}\::{21EC2020-3AEA-1069-A2DD-08002B30309D}
;run control.exe
Return

����վ:
Run ::{645FF040-5081-101B-9F08-00AA002F954E}
Return

C:\:
Run C:\
Return

D:\:
Run D:\
Return

E:\:
Run E:\
Return

�ҵ��ĵ�:
Run ::{450d8fba-ad25-11d0-98a8-0800361b1103}
Return

�����ļ���:
Run C:\Program Files
Return

ע��:
Shutdown, 0
Return

�ػ�:
Shutdown,1
Return

����:
Shutdown,2
Return

����:
DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
Return