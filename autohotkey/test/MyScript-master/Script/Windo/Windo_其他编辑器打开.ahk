Windo_�����༭����:
sTextDocumentPath := GetTextDocumentPath(Windy_CurWin_Pid,Windy_CurWin_id,Windy_CurWin_Title)
run,%Splitted_Windy_Cmd3% "%sTextDocumentPath%" 
return

GetTextDocumentPath(_pid,_id,_Title)
{
;���ڱ�����·���Ĵ���ֱ�ӻ�ȡ���ڱ�������
IfInString,_Title,:\ 
{  
;ƥ��Ŀ¼����ƥ���ļ�
;FullNamell:=RegExReplace(_Title,"^.*(.:(\\)?.*)\\.*$","$1")
;�༭���ļ��޸ĺ���⿪ͷ����*��
RegExMatch(_Title, "i)^\*?\K.*\..*(?= [-*] )", FileFullPath)
If FileFullPath
  return FileFullPath
}

IfInString,_Title,���±�
{
If(_Title="�ޱ��� - ���±�")
{
Return
}
FileFullPath := JEE_NotepadGetPath(_id)
if FileFullPath<>
 return FileFullPath
}

;;;;;;;;;;;;;;��ȡ������;;;;;;;;;
;WMI_Query("\\.\root\cimv2", "Win32_Process")
CMDLine:= WMI_Query(_pid)

RegExMatch(CMDLine, "i).*exe.*?\s+(.*)", ff_)   ; ����ƥ�������в���
;�������������в��ܵõ�·��  ���� a.exe /resart "D:\123.txt"
;�����в����д򿪵��ļ���Щ�����  ��"������"���ļ�·��"�� ��Щ���򲻴� ��"�������ļ�·����
StringReplace,FileFullPath,ff_1,`",,All
startzimu:=RegExMatch(FileFullPath, "i)^[a-z]")

 if !startzimu
{
RegExMatch(FileFullPath, "i).*?\s+(.*)", fff_)
FileFullPath:=fff_1
}
startzimu:=ff_:=ff_1:=fff_:=fff_1:=""
if FileFullPath<>
  return FileFullPath
}
