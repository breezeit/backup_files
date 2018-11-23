Update:
/*
0x40 INTERNET_CONNECTION_CONFIGURED - Local system has a valid connection to the Internet, but not be currently connected.
0x02 INTERNET_CONNECTION_LAN - Local system uses a local area network to connect to the Internet.
0x01 INTERNET_CONNECTION_MODEM - Local system uses a modem to connect to the Internet.
0x08 INTERNET_CONNECTION_MODEM_BUSY - No longer used.
0x20 INTERNET_CONNECTION_OFFLINE - Local system is in offline mode.
0x04 INTERNET_CONNECTION_PROXY - Local system uses a proxy server to connect to the Internet

*/
;connected:=DllCall("Wininet.dll\InternetGetConnectedState", "Str", 0x40,"Int",0)
;DllCall("SENSAPI.DLL\IsDestinationReachableA" , Str,"www.google.com", Int,0 )
URL := "http://www.baidu.com"
If InternetCheckConnection(URL)
{
	WinHttp.URLGet("https://raw.githubusercontent.com/wyagd001/MyScript/master/version.txt",,, update_txtFile)
	IfNotExist,%update_txtFile%
	{
		msgbox,,����֪ͨ,�޷����ظ����ļ������������������ӡ�
	return
	}
	FileGetSize, sizeq,%update_txtFile%
	if(sizeq>20)
	{
		msgbox,,����֪ͨ,���صĸ����ļ���С���������������������ӡ�
		FileDelete, %update_txtFile%
	return
	}
	FileRead, CurVer, %update_txtFile%
	If not ErrorLevel
	{
		FileDelete, %update_txtFile%
		if(CurVer!=AppVersion)
		{
			msgbox,262148,����֪ͨ,��ǰ�汾Ϊ:%AppVersion%`n���°汾Ϊ:%CurVer%`n�Ƿ�ǰ����ҳ���أ�
			IfMsgBox Yes
				Run,https://github.com/wyagd001/MyScript
		return
		}
		else
		{
			msgbox,262144,����֪ͨ,�ð汾�������°汾:%AppVersion%��
		return
		}
	}
}
else
	msgbox,,����֪ͨ,�޷��������磬���������������ӡ�
return

InternetCheckConnection(Url="",FIFC=1) {
Return DllCall("Wininet.dll\InternetCheckConnection", Str,Url, Int,FIFC, Int,0)
}