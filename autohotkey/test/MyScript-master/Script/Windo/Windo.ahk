Windo_����·�����Ի���:
ControlSetText , edit1, %Windy_CurWin_FolderPath%, ahk_class #32770
return

Windo_���ھ���:
VA_SetAppMute(Windy_CurWin_Pid, !VA_GetAppMute(Windy_CurWin_Pid))
return

Windo_����·����windy�ղؼ�:
SplitPath,Windy_CurWin_FolderPath,menuname
iniwrite,%Windy_CurWin_FolderPath%,%A_ScriptDir%\Settings\Windy\������\windy_Fav.ini,menu,%menuname%
return