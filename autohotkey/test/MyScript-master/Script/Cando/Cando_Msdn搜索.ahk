Cando_msdn����:
	funct_string=https://www.bing.com/search?q=%candysel%+msdn
	a := WinHttp.URLGet(funct_string,"Charset:UTF-8")
	; ƥ���������������    ���������ƥ�䵽  ΢����ҳ��ַ�İ��ˣ�����û����
	RegExmatch(a,"m)(*ANYCRLF).*?href\=""(https://msdn.*?\(v=vs.85\)\.aspx)"".*?",m)
	dizhi:= m1
  a:=""
	If dizhi=
	{
		Run https://social.msdn.microsoft.com/search/en-us/windows?query=%candysel%&Refinement=183
		Return
	}
	Else
		Run %dizhi%
Return