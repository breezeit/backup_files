Cando_�е����緭��:
	Gui,66:Default
	Gui,Destroy
	Youdao_keyword=%CandySel%
	Youdao_����:=YouDaoApi(Youdao_keyword)
	Youdao_��������:= json(Youdao_����, "basic.explains")
	Youdao_��������:= json(Youdao_����, "web.value")
	If Youdao_��������<>
	{
		Gui,add,Edit,x10 y10 w260 h80 readonly,%Youdao_keyword%
		Gui,add,button,x270 y10 w40 h80 gsoundpaly,����
		Gui,add,Edit,x10 y100 w300 h80,%Youdao_��������%
		Gui,add,Edit,x10 y190 w300 h80,%Youdao_��������%
		Gui,show,,�е����緭��
	}
	else
		MsgBox,,�е����緭��,���������ѯ�����õ��ʵķ��롣
Return

soundpaly:
	spovice:=ComObjCreate("sapi.spvoice")
	spovice.Speak(Youdao_keyword)
Return

YouDaoApi(KeyWord)
{
	url:="http://fanyi.youdao.com/fanyiapi.do?keyfrom=xxxxxxxx&key=1360116736&type=data&doctype=json&version=1.1&q=" . SkSub_UrlEncode(KeyWord,"utf-8")
    Return WinHttp.URLGet(url)
}