/*
JowAlert.ahk  V1.1     ���ߣ�wz520
http://ahk.5d6d.com/viewthread.php?tid=830
http://ahk.5d6d.com/thread-898-1-1.html
http://ahk8.com/thread-629.html
*/
ʵʱ��ʱ:
  SoundPlay, %A_ScriptDir%\Sound\domisodo.wav, Wait
  JA_VoiceAlert()
  return

renwu:
If  (A_Hour = rh && A_Min= rm)
{
SetTimer, renwu, Off
IniWrite,0,%run_iniFile%,ʱ��,renwu
run %renwucx%,,UseErrorLevel
if ErrorLevel
  MsgBox,,��ʱ����,��ʱ��������ʧ�ܣ��������á�
}
Return

renwu2:
loop 5
{
If  (A_Hour A_Min = rh%A_index% )
{
	xqArray := {"����һ": 1, "���ڶ�": 2,  "������": 3,  "������": 4,  "������": 5,  "������": 6,  "������": 7}
xqdsArray := StrSplit(xq%A_index%)
msgtptemp:=msgtp%A_index%
for v in xqdsArray
{
if(v = xqArray[A_DDDD])
  MsgBox,,��ʾ,% msgtptemp
}
xqdsArray:=""
}
}
Return

JA_VoiceCheckTime:
  If !((A_Min = 59 || A_Min = 29) && (A_Sec = 57 || A_Sec = 58)) ;��Ϊ��ʾ���ǡ��εε�ཡ�������ཡ�����0�롣���Լ���Ƿ񻹲�3���������㣬���Ǿͷ��ء���������ĳЩԭ�򣬱�����Ϸʱ���ܼ�ʱ�������ӳ٣������趨����57���58�붼�š�
    return
  SoundPlay, %A_ScriptDir%\Sound\didididu.wav, Wait
  JA_VoiceAlert()
  return

JA_JowCheckTime:
  If !((A_Min = 0 || A_Min = 30) && (A_Sec = 0 || A_Sec = 1)) ;����Ƿ���������㣬���Ǿͷ��ء�
    return
  JA_JowAlert()
  return

  JA_AMPM()
{
  If (A_Hour>=0 && A_Hour<=5) ;0�㵽5��
    return "AM0.wav" ;�賿
  Else If (A_Hour>=6 && A_Hour<=11) ;6�㵽11��
    return "AM1.wav" ;����
  Else If (A_Hour>=12 && A_Hour<=17) ;12�㵽17��
    return "PM.wav" ;����
  Else ;����
    return "EM.wav" ;����
}

JA_HourWav()
{
  FormatTime, CurrHour, , hh
  If (CurrHour=1 || CurrHour=2)
    FormatTime, CurrHour, , h
  CurrHour = T%CurrHour%.wav
  return CurrHour
}

JA_MinWav(ByRef Min1, ByRef Min2)
{
  If (A_Min>=1 && A_Min<=9)
  {
    Min1=00
    MIn2=%A_Min%
  }
  If (A_Min=0 || (A_Min>=10 && A_Min<=12)) ;0, 10, 11, 12����ֻҪ����һ���ļ���Min2��Ϊ��
  {
    Min1=%A_Min%
  }
  Else If (A_Min>=13 && A_Min<=19)
  {
    Min1=10
    Min2 := "0" . A_Min-10
  }
  Else If (A_Min>=20 && A_Min<=29)
  {
    Min1=20
    Min2 := "0" . A_Min-20
    If Min2=0
      Min2=
  }
  Else If (A_Min>=30 && A_Min<=39)
  {
    Min1=30
    Min2 := "0" . A_Min-30
    If Min2=0
      Min2=
  }
  Else If (A_Min>=40 && A_Min<=49)
  {
    Min1=40
    Min2 := "0" . A_Min-40
    If Min2=0
      Min2=
  }
  Else If (A_Min>=50 && A_Min<=59)
  {
    Min1=50
    Min2 := "0" . A_Min-50
    If Min2=0
      Min2=
  }
  Min1=T%Min1%.wav
  If Min2!=
    Min2=T%Min2%.wav
}

JA_VoiceAlert(){
  global JA_WavPath
  AMPM:=JA_AMPM() ;�����������賿/����/����/���ϣ�����wav�ļ���
  HourWav:=JA_HourWav() ;��ѯ���ڵ�ʱ������wav�ļ���
  Min1=
  Min2=
  JA_MinWav(Min1, Min2) ;��ѯ���ڵķ֣�����wav�ļ�����������ʮλ�͸�λ��
  SoundPlay, %A_ScriptDir%\Sound\TIMENOW.wav,wait  ;������ʱ���ǡ�
  SoundPlay, %A_ScriptDir%\Sound\%AMPM%, Wait ;���賿/����/����/���ϡ�
  SoundPlay, %A_ScriptDir%\Sound\%HourWav%, Wait ;ʱ
  SoundPlay, %A_ScriptDir%\Sound\POINT.wav, Wait ;���㡱
  SoundPlay, %A_ScriptDir%\Sound\%Min1%, Wait ;�֣�ʮλ��
  If Min2!=
    SoundPlay, %A_ScriptDir%\Sound\%Min2%, Wait ;�֣���λ��
  SoundPlay, %A_ScriptDir%\Sound\MIN.wav, Wait ;���֡�
}

JA_JowAlert(){
  global JA_WavPath
  FormatTime, CurrHour, , h ;�õ�12Сʱ�Ƶ�ʱ�������ü�����
  If CurrHour = 0 ;�����0��
    CurrHour := 12 ;��12��
  If A_Min = 30 ;����ǰ��
    CurrHour := 1 ;��1��
  if A_Min = 0
    soundplay, %A_ScriptDir%\Sound\dofasodo.wav, Wait ;����ʱ���Ŷ߷��¶ߣ�������������㲻���š�
  loop, %CurrHour%
    soundplay, %A_ScriptDir%\Sound\dong.wav, Wait ;����
}
