ÿ����Сʱ���Ϊ��(period:=7){
 lasttime:=CF_IniRead(run_iniFile,"ʱ��","�ϴ���������")
 if (lasttime="") or (lasttime="error")
  lasttime:=10001001
 FormatTime,time1,% lasttime,yyyyMMdd
 FormatTime,time2,A_now,yyyyMMdd
 if (time1<>time2)
 {
  IniWrite,% time2,% run_iniFile,ʱ��,�ϴ���������
  FormatTime,time3,A_now,HH
  IniWrite,% time3,% run_iniFile,ʱ��,�ϴ�����ʱ��
 return true
 }
 else
 {
  time3:=CF_IniRead(run_iniFile,"ʱ��","�ϴ�����ʱ��")
  if time3=
   time3=0
  FormatTime,time4,A_now,HH
  if (Abs(time4 - time3) < period)
   return false
  else
  {
   IniWrite,% time4,% run_iniFile,ʱ��,�ϴ�����ʱ��
  return true
  }
 }
}