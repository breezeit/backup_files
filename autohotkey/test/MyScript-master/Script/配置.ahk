option:
IniRead,ѯ��,%run_iniFile%,��ͼ,ѯ��
IniRead,filetp,%run_iniFile%,��ͼ,filetp

IniRead,Auto_Update,%run_iniFile%,���ܿ���,Auto_Update
IniRead,run_with_sys,%run_iniFile%,���ܿ���,run_with_sys
IniRead,mousetip,%run_iniFile%,���ܿ���,mousetip
IniRead,x_x,%run_iniFile%,����,x_x
IniRead,y_y,%run_iniFile%,����,y_y
IniRead,txt,%run_iniFile%,����,txt
IniRead,TextEditor,%run_iniFile%,����,TextEditor
IniRead,ImageEditor,%run_iniFile%,����,ImageEditor

IniRead,Auto_Raise,%run_iniFile%,���ܿ���,Auto_Raise
IniRead,hover_task_buttons,%run_iniFile%,�Զ�����,hover_task_buttons
IniRead,hover_task_group,%run_iniFile%,�Զ�����,hover_task_group
IniRead,hover_task_min_info,%run_iniFile%,�Զ�����,hover_task_min_info
IniRead,hover_start_button,%run_iniFile%,�Զ�����,hover_start_button
IniRead,hover_min_max,%run_iniFile%,�Զ�����,hover_min_max
IniRead,hover_any_window,%run_iniFile%,�Զ�����,hover_any_window
IniRead,scrollundermouse,%run_iniFile%,�Զ�����,scrollundermouse
IniRead,hover_keep_zorder,%run_iniFile%,�Զ�����,hover_keep_zorder
IniRead,hover_delay,%run_iniFile%,�Զ�����,hover_delay

IniRead,num,%run_iniFile%,ContextMenu,num

Loop 8
{
	z:=A_Index-1
	IniRead,FF%z%,%run_iniFile%,FastFolders,Folder%z%
	IniRead,FFTitle%z%,%run_iniFile%,FastFolders,FolderTitle%z%
}

IniRead,baoshionoff,%run_iniFile%,ʱ��,baoshionoff
IniRead,baoshilx,%run_iniFile%,ʱ��,baoshilx
IniRead,renwu,%run_iniFile%,ʱ��,renwu
IniRead,renwu2,%run_iniFile%,ʱ��,renwu2
IniRead,rh,%run_iniFile%,ʱ��,rh
IniRead,rm,%run_iniFile%,ʱ��,rm
IniRead,renwucx,%run_iniFile%,ʱ��,renwucx

IniRead,LoginPass,%run_iniFile%,serverConfig,LoginPass
IniRead,foobar2000,%run_iniFile%,AudioPlayer,foobar2000
IniRead,iTunes,%run_iniFile%,AudioPlayer,iTunes
IniRead,wmplayer,%run_iniFile%,AudioPlayer,wmplayer
IniRead,TTPlayer,%run_iniFile%,AudioPlayer,TTPlayer
IniRead,winamp,%run_iniFile%,AudioPlayer,winamp

Gui,99:Default
Gui,+LastFound
Gui,Destroy
Gui,Add,Button,x370 y335 w70 h30 gwk,ȷ��
Gui,Add,Button,x450 y335 w70 h30 g99GuiClose Default,ȡ��
Gui,Add,Tab,x-4 y1 w640 h330 ,��ݼ�|Plugins|����|�Զ�����|7Plus�˵�|���㱨ʱ|������|����|����|����

Gui,Tab,��ݼ�
Gui,Add,text,x10 y30 w550,ע��:#��ʾWin,!��ʾAlt,+��ʾShift,^��ʾCtrl,Space��ʾ�ո��,Up��ʾ���ϼ�ͷ,~��ʾ����ԭ���ܲ��ᱻ���Σ�*��ʾ��������ͬʱ����ʱ��ݼ���Ȼ��Ч

Gui,Add,ListView,x6 y60 w570 h245 vhotkeysListview ghotkeysListview checked Grid -Multi +NoSortHdr -LV0x10 +LV0x4000 +AltSubmit,��ݼ���ǩ|��ݼ�|���ô���|���
Gui,listview,hotkeysListview 
LV_Delete()
IniRead,hotkeycontent,%run_iniFile%,��ݼ�
hotkeycontent:="[��ݼ�]" . "`n" . hotkeycontent
for k,v in IniObj(hotkeycontent,OrderedArray()).��ݼ�
{
	col3_tmp=
	if A_index=1
		col3_tmp:=";ȫ���ȼ�"
	If k contains �ض�����_,�ų�����_
		col3_tmp:=";" k
	LV_Add(InStr(v,"@")?"" : "check",k,v,col3_tmp?col3_tmp:";",A_index)
}
LV_ModifyCol()
LV_ModifyCol(4,40)
LV_Modify(1,"Select")
LV_Modify(1,"Focus")
LV_Modify(1,"Vis")

LV_ColorInitiate(99)
sleep,500
Gui,Tab,Plugins
Gui,Add,ListView,x6 y30 w570 h245 vPluginsListview ghotkeysListview Grid -Multi -LV0x10 +LV0x4000 +AltSubmit,����|��ݼ�|�������÷���|���
Gosub, Load_PluginsList
Gui,Add,Button,x10 y280 w80 h30 gEdit_PluginsHotkey,�༭�˵�(&E)
Gui,Add,Button,x90 y280 w80 h30 gLoad_PluginsList,ˢ�²˵�(&R)
Gui,Add,Button,x450 y280 w70 h30 gRun_Plugin,���в��

Gui,Tab,����
Gui,Add,CheckBox,Checked%ѯ��% x26 y41 w70 h20 vask,��ͼѯ��

Gui,Add,Text ,x136 y45,��������
Gui,Add,Radio,x206 y41 w40 h20 vtp1 gche,png
Gui,Add,Radio,x256 y41 w40 h20 vtp2 gche,jpg
Gui,Add,Radio,x306 y41 w40 h20 vtp3 gche,bmp
Gui,Add,Radio,x356 y41 w40 h20 vtp4 gche,gif
If(filetp="png"){
	GuiControl,,tp1,1
}
Else If(filetp="jpg"){
	GuiControl,,tp2,1
}
Else If(filetp="bmp"){
	GuiControl,,tp3,1
}
Else If(filetp="gif"){
	GuiControl,,tp4,1
}

Gui,Add,CheckBox,Checked%Auto_Update% x26 y61 w100 h20 vupdate,����ʱ������
Gui,Font,Cred
Gui,Add,Text,x136 y66 ,�Խű��������ٶ���Ӱ��
Gui,Font

Gui,Add,CheckBox,Checked%run_with_sys% x26 y81 w100 h20 vautorun,��������

Gui,Add,CheckBox,Checked%mousetip% x26 y100 w100 h20 vmtp,�����ʾ

Gui,Add,Text,x26 y130 w100 h20,��ʾλ��
Gui,Add,Radio,x85 y127 w80 h20 vdef1 gxy1,���Ͻ�
Gui,Add,Radio,x170 y127 w80 h20 vdef2 gxy2,���Ͻ�
Gui,Add,Radio,x85 y147 w80 h20 vdef3 gxy3,���½�
Gui,Add,Radio,x170 y147 w80 h20 vdef4 gxy4,���½�
If(x_x=0 && y_y=0){
	GuiControl,,def1,1
}
If(x_x=x_x2 && y_y=0){
	GuiControl,,def2,1
}
If(x_x=0 && y_y=y_y2){
	GuiControl,,def3,1
}
If(x_x=x_x2 && y_y=y_y2){
	GuiControl,,def4,1
}
Gui,Add,text,x285 y127 w15 h20,X=
Gui,Add,Edit,x300 y124 w50 h20 vx1,%x_x%
Gui,Add,text,x285 y157 w15 h20,Y=
Gui,Add,Edit,x300 y154 w50 h20 vy1,%y_y%

Gui,Add,Button,x26 y185 w144 gf_OptionsGUI,Folder Menu ѡ��
Gui,Font,Cred
Gui,Add,Text,x26 y220,ֱ�ӱ༭�����ļ�(����)
Gui,Font
Gui,Add,Button,x26 y240 w70 goo,�༭����
Gui,Add,Button,x100 y240 w70 ginieditor_click,�༭���༭
Gui,Add,Button,x26 y265 w144 gooo,�༭ Folder Menu ����

Gui,Add,text,x240 y190 w120 h20,�½��ı��ĵ����ͣ�
Gui,Add,Edit,x350 y187 w50 h20 vtxt,%txt%
Gui,Add,text,x240 y220 w100 h20,�ı��༭��·����
Gui,Add,Edit,x350 y217 w150 h20 vTextEditor,%TextEditor%
Gui,Add,Button,x500 y217 w30 h20 gTextBrowse,...
Gui,Add,text,x240 y250 w100 h20,ͼƬ�༭��·����
Gui,Add,Edit,x350 y247 w150 h20 vImageEditor,%ImageEditor%
Gui,Add,Button,x500 y247 w30 h20 gImageBrowse,...

Gui,Tab,�Զ�����
Gui,Add,CheckBox,x26 y41 w200 h20 vAuto_Raise gAutoRaise,��������Զ�����(���)����
Gui,Add,CheckBox,x26 y61 w500 h20 vhover_task_buttons,��������ť�Զ�������ܣ������ͣ����������ť��ʱ�Զ������
Gui,Add,CheckBox,x44 y81 w250 h20 vhover_task_group,�������������鰴ť�Զ��������(δ����)
Gui,Add,CheckBox,x44 y101 w410 h20 vhover_task_min_info,��������С������ֻ��ʾ������Ϣ����С���Ĵ��ڲ��Զ����,Win7��Ч��
Gui,Add,CheckBox,x26 y121 w410 h20 vhover_start_button,��ʼ�˵��Զ�������ܣ������ͣ�ڿ�ʼ�˵�λ��ʱ�Զ������ʼ�˵���
Gui,Add,CheckBox,x26 y141 w410 h20 vhover_min_max,��������ť�Զ�����������ͣ����С�������/��ԭ��ťʱ�Զ������
Gui,Add,Text,x26 y165 w180 h20 vtext1,�����ͣ���ڴ���ʱ�Ķ�����
Gui,Add,CheckBox,x26 y185 w115 h20 vhover_any_window gundermouse,�����Զ�����
Gui,Add,CheckBox,x44 y205 w200 h20 vhover_keep_zorder,����ʱ�����Ĵ���˳��(Ч��һ��)
Gui,Add,Text,x26 y235 w150 h20 vtext,��ͣ�ӳ���Ӧʱ�䣨���룩��
Gui,Add,Edit,x170 y230 w50 h20 vhover_delay,%hover_delay%
Gui,Add,CheckBox,x26 y255 w300 h20 vscrollundermouse gundermouse,�ڲ�����������ʹ������Ч(�����й�����ʱ)

 GuiControl,,hover_task_buttons,%hover_task_buttons%
 GuiControl,,hover_task_group,%hover_task_group%
 GuiControl,,hover_task_min_info,%hover_task_min_info%
 GuiControl,,hover_start_button,%hover_start_button%
 GuiControl,,hover_min_max,%hover_min_max%
 GuiControl,,noundereffect,1
 GuiControl,,hover_any_window,%hover_any_window%
 GuiControl,,scrollundermouse,%scrollundermouse%
 GuiControl,,hover_keep_zorder,%hover_keep_zorder%

GuiControl,Disable,hover_task_buttons
GuiControl,Disable,hover_task_group
GuiControl,Disable,hover_task_min_info
GuiControl,Disable,hover_start_button
GuiControl,Disable,hover_min_max
GuiControl,Disable,hover_any_window
GuiControl,Disable,hover_keep_zorder
GuiControl,Disable,text
GuiControl,Disable,hover_delay

If(Auto_Raise=1){
	GuiControl,,Auto_Raise,1
	GuiControl,Enable,hover_task_buttons
	GuiControl,Enable,hover_task_group
	GuiControl,Enable,hover_task_min_info
	GuiControl,Enable,hover_start_button
	GuiControl,Enable,hover_min_max
	GuiControl,Enable,hover_any_window
	GuiControl,Enable,hover_keep_zorder
	GuiControl,Enable,text
	GuiControl,Enable,hover_delay
}

Gui,Tab,7Plus�˵�
Gui,Add,ListView,r12 w570 h245 v7pluslistview Grid -Multi +NoSortHdr Checked AltSubmit -LV0x10 g7plusListView,����|ID  |�˵�����
;������ں��ж�� ListView �ؼ�,Ĭ������º��������������ӵ��Ǹ�. Ҫ�ı��������,��ָ�� Gui,ListView,ListViewName
Gosub, Load_List
Gui,Add,Button,x10 y280 w80 h30 gButtun_Edit,�༭�˵�(&E)
Gui,Add,Button,x90 y280 w80 h30 gLoad_List,ˢ�²˵�(&R)
Gui,Add,Button,x170 y280 w120 h30 gsavetoreg,Ӧ�ò˵���ϵͳ(&S)
Gui,Add,Button,x370 y280 w70 h30 gregsvr32dll,ע��Dll
Gui,Add,Button,x450 y280 w70 h30 gunregsvr32dll,ж��Dll

Gui,Tab,���㱨ʱ
Gui, Add, GroupBox, x20 y30 w200 h90 vgbbs,���㱨ʱ(�ѿ���)
Gui,Add,Text,x26 y65 vbaoshi1,ѡ��ʱ����:
Gui,Add,Radio,x26 y85 w80 h20 vbaoshilx1 glx,������ʱ
Gui,Add,Radio,x106 y85 w80 h20 vbaoshilx2 glx,��������

Gui, Add, GroupBox, x230 y30 w200 h95,
Gui,Add,CheckBox,Checked%Auto_JCTF% x236 y40 w180 h20 vAuto_JCTF,��ͳ��������ǰ����
Gui,Add,CheckBox,x236 y60 w180 h20 vbaoshionoff gbaoshi,�������㱨ʱ
Gui,Add,CheckBox,x236 y80 w180 h20 vrenwu gdingshi,������ʱ����
Gui,Add,CheckBox,Checked%renwu2% x236 y100 w180 h20 vrenwu2 gupdategbnz,��������

Gui, Add, GroupBox, x20 y125 w530 h90 vgbds,��ʱ����(�ѿ���)
Gui,Add,Text,x26 y150 vdingshi1,ָ��ʱ��:
Gui,Add,Edit,x85 y148 w30 h20 vrh,%rh%
Gui,Add,Text,x118 y150 vdingshi2,ʱ
Gui,Add,Edit,x135 y148 w30 h20 vrm,%rm%
Gui,Add,Text,x167 y150 vdingshi3,��
Gui,Add,Text,x26 y180 vdingshi4,ָ��ִ�еĳ���:
Gui,Add,Edit,x120 y178 w350 h20 vrenwucx,%renwucx%
Gui,Add,Button,x475 y175 w30 h25 vdingshi5 grenwusl,...
Gui,Add,Button,x505 y175 w35 h25 vdingshi6 grenwucs,����

Gui, Add, GroupBox, x20 y215 w530 h100 vgbnz,����(�ѿ���)
Gui,Add,Text,x26 y237 w60 h20 ,ʱ�����У�
Gui, Add, Radio, x85 y237 w27 Checked vMyRadiorh gupdaterh,
Gui, Add, Radio, x172 y237 w27 gupdaterh,
Gui, Add, Radio, x257 y237 w27 gupdaterh,
Gui, Add, Radio, x344 y237 w27 gupdaterh,
Gui, Add, Radio, x431 y237 w27 gupdaterh,
Gui,Add,Edit,x112 y235 w55 h20 vrh1 grrh ,%rh1%
Gui,Add,Edit,x197 y235 w55 h20 vrh2 grrh,%rh2%
Gui,Add,Edit,x284 y235 w55 h20 vrh3 grrh,%rh3%
Gui,Add,Edit,x371 y235 w55 h20 vrh4 grrh,%rh4%
Gui,Add,Edit,x458 y235 w55 h20 vrh5 grrh,%rh5%

Gui,Add,CheckBox,x26 y265 w60 h20 vcxq1 grxq,����һ
Gui,Add,CheckBox,x90 y265 w60 h20 vcxq2 grxq,���ڶ�
Gui,Add,CheckBox,x154 y265 w60 h20 vcxq3 grxq,������
Gui,Add,CheckBox,x218 y265 w60 h20 vcxq4 grxq,������
Gui,Add,CheckBox,x282 y265 w60 h20 vcxq5 grxq,������
Gui,Add,CheckBox,x346 y265 w60 h20 vcxq6 grxq,������
Gui,Add,CheckBox,x410 y265 w60 h20 vcxq7 grxq,������
Gui,Add,CheckBox,x474 y265 w60 h20 vcxq8 gexq,ÿ��

Gui,Add,Text,x26 y292 w60 h20,��ʾ��Ϣ
Gui,Add,Edit,x85 y290 w400 h20 vmsgtp grmsgtp,

GuiControl,,baoshionoff,%baoshionoff%
If baoshilx
GuiControl,,baoshilx1,1
Else
GuiControl,,baoshilx2,1
If(baoshionoff = 0)
{
	GuiControl,Disable,baoshi1
	GuiControl,Disable,baoshilx1
	GuiControl,Disable,baoshilx2
	GuiControl,,gbbs,���㱨ʱ(�ѹر�)
}
GuiControl,,renwu,%renwu%
If(renwu = 0)
{
	GuiControl,Disable,dingshi1
	GuiControl,Disable,rh
	GuiControl,Disable,dingshi2
	GuiControl,Disable,rm
	GuiControl,Disable,dingshi3
	GuiControl,Disable,dingshi4
	GuiControl,Disable,renwucx
	GuiControl,Disable,dingshi5
GuiControl,,gbds,��ʱ����(�ѹر�)
}
if(renwu2=0)
GuiControl,,gbnz,����(�ѹر�)
gosub updaterh

Gui,Tab,������
Gui,Add,Text,x26 y43,Foobar2000:
Gui,Add,Edit,x96 y41 w350 h20 vap1,%foobar2000%
Gui,Add,Button,x450 y41 w30 h20 gsl,...
Gui,Add,Text,x26 y65,iTunes:
Gui,Add,Edit,x96 y63 w350 h20 vap2,%iTunes%
Gui,Add,Button,x450 y63 w30 h20 gsl,...
Gui,Add,Text,x26 y87,Wmplayer:
Gui,Add,Edit,x96 y85 w350 h20 vap3,%wmplayer%
Gui,Add,Button,x450 y85 w30 h20 gsl,...
Gui,Add,Text,x26 y109,ǧǧ����:
Gui,Add,Edit,x96 y107 w350 h20 vap4,%TTPlayer%
Gui,Add,Button,x450 y107 w30 h20 gsl,...
Gui,Add,Text,x26 y131,Winamp:
Gui,Add,Edit,x96 y129 w350 h20 vap5,%winamp%
Gui,Add,Button,x450 y129 w30 h20 gsl,...
Gui,Add,Text,x26 y165,Ĭ�ϲ�����
Gui,Add,Radio,x26 y185 w80 h20 vdap1 gdaps,Foobar2000
Gui,Add,Radio,x116 y185 w70 h20 vdap2 gdaps,iTunes
Gui,Add,Radio,x190 y185 w80 h20 vdap3 gdaps,Wmplayer
Gui,Add,Radio,x270 y185 w80 h20 vdap4 gdaps,ǧǧ����
Gui,Add,Radio,x350 y185 w80 h20 vdap5 gdaps,Winamp
Gui,Add,Radio,x430 y185 w80 h20 vdap6 gdaps,AhkPlayer
If(DefaultPlayer="foobar2000"){
	GuiControl,,dap1,1
}
Else If(DefaultPlayer="iTunes"){
	GuiControl,,dap2,1
}
Else If(DefaultPlayer="Wmplayer"){
	GuiControl,,dap3,1
}
Else If(DefaultPlayer="TTPlayer"){
	GuiControl,,dap4,1
}
Else If(DefaultPlayer="Winamp"){
	GuiControl,,dap5,1
}
Else If(DefaultPlayer="AhkPlayer"){
	GuiControl,,dap6,1
}

Gui,Tab,����
Gui,Add,Text,x26 y41,��������������б��й̶�����Ŀ(����Ŀ���á�|���ֿ�):
Gui,Add,Edit,x26 y61 w530 r4 vsp,%stableProgram%
Gui,Add,Text,x26 y135,������������Զ������(һ��һ��,���硰c = c:\����ֻ�Ա�������Ч):
Gui,Add,Edit,x26 y155 w530 r8 vop,%otherProgram%
Gui,Add,Text,x26 y290,ϵͳע�������ע�������Ա�����ͬ����Ч
Gui,Add,Button,x490 y285 g�Զ�����������_click,�鿴�޸�

Gui,Tab,����
Gui,Add,CheckBox,x26 y41 w210 h20 vvAuto_DisplayMainWindow Checked%Auto_DisplayMainWindow%,����ʱ��ʾ������
Gui,Add,CheckBox,x26 y61 w210 h20 vvAuto_Trayicon Checked%Auto_Trayicon%,����ʱ�������ͼ��
Gui,Add,CheckBox,x44 y81 w200 h20 vvAuto_Trayicon_showmsgbox Checked%Auto_Trayicon_showmsgbox%,û������ͼ����ʾ�����ű��Ի���
Gui,Add,CheckBox,x26 y101 w210 h20 vvShutdownMonitor Checked%ShutdownMonitor%,���ӹػ����ֹػ��Ի���
Gui,Add,CheckBox,x26 y121 w210 h20 vvPasteAndOpen Checked%PasteAndOpen%,ճ������
Gui,Add,CheckBox,x26 y141 w210 h20 vvAuto_Clip Checked%Auto_Clip%,���ؼ�����(��������ʱ��Ч)
Gui,Add,CheckBox,x44 y161 w130 h20 vvAuto_Cliphistory Checked%Auto_Cliphistory%,��������ʷ(����)
Gui,Font,cgreen
Gui,Add,text,x190 y164 w60 h20 ggui_clipHistory,�鿴
Gui,Font
Gui,Add,CheckBox,x26 y181 w210 h20 vvAuto_Capslock Checked%Auto_Capslock%, ��ס Capslock �ı䴰�ڴ�Сλ��
Gui,Add,CheckBox,x26 y201 w210 h20 vvAuto_mouseclick Checked%Auto_mouseclick%, ��������ǿ(�ȼ�)
Gui,Add,CheckBox,x26 y221 w210 h20 vvAuto_midmouse Checked%Auto_midmouse%, ����м���ǿ(�ȼ�)
Gui,Add,CheckBox,x26 y241 w210 h20 vvAuto_Spacepreview Checked%Auto_Spacepreview%, Space Ԥ���ļ�(�ȼ�)
Gui,Add,CheckBox,x26 y261 w210 h20 vvAuto_AhkServer Checked%Auto_AhkServer%, ahk ��ҳ����
Gui,Add,CheckBox,x46 y281 w210 h20 vvLoginPass Checked%LoginPass%, ����Ĭ���ѵ�¼״̬

Gui,Tab,����
Gui,Add,Text,x26 y40,���ƣ����� - Ahk
Gui,Add,Text,x26 y60,���ߣ�����С��
Gui,Add,Text,x26 y80,��ҳ��
Gui,Font,CBlue
;Gui,Font,CBlue Underline
Gui,Add,Text,x+ gg vURL,https://github.com/wyagd001/MyScript
Gui,Font
Gui,Add,Text,x26 y100,% "�汾��"AppVersion
Gui,Add,Text,x26 y120,���� Autohotkey��1.1.28.00(Unicode) ϵͳ��Win7 SP1 32bit ���İ�
Gui,Add,Text,x26 y140,% "��ǰ Autohotkey��" A_AhkVersion "(" (A_IsUnicode?"Unicode":"ansi") ") ϵͳ��" A_OSVersion " " (A_Is64bitOS?64:32) "bit"
Gui,Add,Button,x26 y165 gUpdate,������

;Gui & Hyperlink - AGermanUser
;http://www.autohotkey.com/forum/viewtopic.php?p=107703

; Retrieve scripts PID
Process,Exist
pid_this := ErrorLevel

; Retrieve unique ID number (HWND/handle)
WinGet,hw_gui,ID,ahk_class AutoHotkeyGUI ahk_pid %pid_this%

; Call "HanGGGGGGVdleMessage" when script receives WM_SETCURSOR message
WM_SETCURSOR = 0x20
OnMessage(WM_SETCURSOR,"HandleMessage")

; Call "HandleMessage" when script receives WM_MOUSEMOVE message
WM_MOUSEMOVE = 0x200
OnMessageEx(0x200,"HandleMessage")

Gui,Show,xCenter yCenter w590 h370,ѡ��
Return

autoraise:
If(Auto_Raise := !Auto_Raise){
	GuiControl,Enable,hover_task_buttons
	GuiControl,Enable,hover_task_group
	GuiControl,Enable,hover_task_min_info
	GuiControl,Enable,hover_start_button
	GuiControl,Enable,hover_min_max
	GuiControl,Enable,hover_any_window
	GuiControl,Enable,hover_keep_zorder
	GuiControl,Enable,text
	GuiControl,Enable,hover_delay
}
Else
{
	GuiControl,Disable,hover_task_buttons
	GuiControl,Disable,hover_task_group
	GuiControl,Disable,hover_task_min_info
	GuiControl,Disable,hover_start_button
	GuiControl,Disable,hover_min_max
	GuiControl,Disable,hover_any_window
	GuiControl,Disable,hover_keep_zorder
	GuiControl,Disable,text
	GuiControl,Disable,hover_delay
}
Return

undermouse:
;Gui,Submit,NoHide
If (hover_any_window := !hover_any_window)
{
GuiControlGet, hover_any_window
if hover_any_window
GuiControl,,scrollundermouse,0
}
If (scrollundermouse := !scrollundermouse)
{
GuiControlGet, scrollundermouse
if scrollundermouse
GuiControl,,hover_any_window,0
}
Return

baoshi:
If(baoshionoff := !baoshionoff)
{
	GuiControl,Enable,baoshi1
	GuiControl,Enable,baoshilx1
	GuiControl,Enable,baoshilx2
GuiControl,,gbbs,���㱨ʱ(�ѿ���)
}
Else
{
	GuiControl,Disable,baoshi1
	GuiControl,Disable,baoshilx1
	GuiControl,Disable,baoshilx2
GuiControl,,gbbs,���㱨ʱ(�ѹر�)
}
Return

lx:
Gui,Submit,NoHide
If baoshilx1
	baoshilx=1
If baoshilx2
	baoshilx=0
Return

dingshi:
If(renwu := !renwu)
{
	GuiControl,Enable,dingshi1
	GuiControl,Enable,rh
	GuiControl,Enable,dingshi2
	GuiControl,Enable,rm
	GuiControl,Enable,dingshi3
	GuiControl,Enable,dingshi4
	GuiControl,Enable,renwucx
	GuiControl,Enable,dingshi5
GuiControl,,gbds,��ʱ����(�ѿ���)
}
Else
{
	GuiControl,Disable,dingshi1
	GuiControl,Disable,rh
	GuiControl,Disable,dingshi2
	GuiControl,Disable,rm
	GuiControl,Disable,dingshi3
	GuiControl,Disable,dingshi4
	GuiControl,Disable,renwucx
	GuiControl,Disable,dingshi5
GuiControl,,gbds,��ʱ����(�ѹر�)
}
Return

TextBrowse:
FileSelectFile,textpath ,3,,ѡ���ı��༭����·��,�����ļ�(*.exe)
If !ErrorLevel
	GuiControl,,TextEditor,%textpath%
Return

ImageBrowse:
FileSelectFile,imagepath ,3,,ѡ��ͼƬ�༭����·��,�����ļ�(*.exe)
If !ErrorLevel
	GuiControl,,imageEditor,%imagepath%
Return

renwusl:
FileSelectFile,tt,,,ѡ��Ҫ�򿪵ĳ�����ļ�
GuiControl,,renwucx,%tt%
Return

renwucs:
run %renwucx%,,UseErrorLevel
If ErrorLevel
	MsgBox,,��ʱ����,��ʱ��������ʧ�ܣ����������Ƿ���ȷ��
Return

sl:
FileSelectFile,tt,,,ѡ����Ƶ���ų���,�����ļ�(*.exe)
If ErrorLevel=0
{
	If tt contains foobar2000
		GuiControl,,ap1,%tt%
	If tt contains iTunes
		GuiControl,,ap2,%tt%
	If tt contains wmplayer
		GuiControl,,ap3,%tt%
	If tt contains TTPlayer
		GuiControl,,ap4,%tt%
	If tt contains winamp
		GuiControl,,ap5,%tt%
}
Return

oo:
Run,notepad.exe %run_iniFile%,,UseErrorLevel
Return

inieditor_click:
Run,"%A_AhkPath%" "%A_ScriptDir%\Plugins\inieditor.ahk" "%run_iniFile%"
Return

ooo:
Run,%FloderMenu_iniFile%
Return

�Զ�����������_click:
run,"%A_AhkPath%" "%A_ScriptDir%\Plugins\�Զ�����������.ahk"
Return

g:
Run,https://github.com/wyagd001/MyScript
Gui,Destroy
Return

;######## Function #############################################################
HandleMessage(p_w,p_l,p_m,p_hw)
{
	global WM_SETCURSOR,WM_MOUSEMOVE
	static URL_hover,h_cursor_hand,h_old_cursor,CtrlIsURL,LastCtrl

	If (p_m = WM_SETCURSOR)
	{
		If URL_hover
		Return,true
	}
	Else If (p_m = WM_MOUSEMOVE)
	{
		; Mouse cursor hovers URL text control
		StringLeft,CtrlIsURL,A_GuiControl,3
		If (CtrlIsURL = "URL")
		{
			If URL_hover=
			{
				Gui,Font,cBlue underline
				GuiControl,Font,%A_GuiControl%
				LastCtrl = %A_GuiControl%
				h_cursor_hand := DllCall("LoadCursor","uint",0,"uint",32649)
				URL_hover := true
			}
			h_old_cursor := DllCall("SetCursor","uint",h_cursor_hand)
		}
		; Mouse cursor doesn't hover URL text control
		Else
		{
			If URL_hover
			{
			Gui,Font,norm cBlue
			GuiControl,Font,%LastCtrl%
			DllCall("SetCursor","uint",h_old_cursor)
			URL_hover=
			}
		}
	}
}
;######## End Of Functions #####################################################

xy1:
;ControlSetText,Edit1,0
;ControlSetText,Edit2,0
GuiControl,,x1,0
GuiControl,,y1,0
Return

xy2:
GuiControl,,x1,%x_x2%
GuiControl,,y1,0
Return

xy3:
GuiControl,,x1,0
GuiControl,,y1,%y_y2%
Return

xy4:
GuiControl,,x1,%x_x2%
GuiControl,,y1,%y_y2%
Return

che:
Gui,Submit,NoHide
If tp1=1
	filetp=png
Else If tp2=1
	filetp=jpg
Else If tp3=1
	filetp=bmp
Else
	filetp=gif
Return

hotkeysListview:
If(A_GuiControl="hotkeysListview")
{
tmpstr=hotkeys
Gui,99:ListView,hotkeysListview
}
If(A_GuiControl="PluginsListview")
{
tmpstr=Plugins
Gui,99:ListView,PluginsListview
}
If(A_GuiEvent = "I")
{
	If (ErrorLevel == "C")
	{
LV_GetText(tmphotkey,A_EventInfo,2)
if instr(tmphotkey,"@")
{
StringReplace, tmphotkey, tmphotkey,@
LV_Modify(A_EventInfo, , , tmphotkey)
}
	}
	If (ErrorLevel == "c")
	{
LV_GetText(tmphotkey,A_EventInfo,2)
if (!tmphotkey or InStr(tmphotkey,"ahk"))
return
tmphotkey:="@" tmphotkey
LV_Modify(A_EventInfo, , , tmphotkey)
	}
}
If A_GuiEvent = DoubleClick     ;Double-clicking a row opens the Edit Row dialogue window.
	gosub,Edithotkey
Return

Edithotkey:
Gui,99:Default
Gui,99:+Disabled
Gui,EditRow:+Owner99
FocusedRowNumber:=0
FocusedRowNumber := LV_GetNext(0,"F")
LV_GetText(Col1Text,FocusedRowNumber,1) 
LV_GetText(Col2Text,FocusedRowNumber,2)
If(tmpstr="hotkeys")
Gui,EditRow:Add,Text,x6 y9,�� ǩ: %Col1Text%
If(tmpstr="Plugins")
Gui,EditRow:Add,Text,x6 y9,�� ��: %Col1Text%

Gui,EditRow:Add,Text,x6 y37,��ݼ�:
Gui,EditRow:Add,Edit,xp+45 yp-3 w230 vEditRowEditCol2,%Col2Text%
Gui,EditRow:Add,Button,x145 yp+30 w70 h30 vEditRowButtonOK gEditRowButtonOK ,ȷ��
Gui,EditRow:Add,Button,xp+81 yp w70 h30 vEditRowButtonCancel gEditRowButtonCancel Default ,ȡ��
Gui,EditRow: -MaximizeBox -MinimizeBox
Gui,EditRow:Show,w320 h100,�༭��ݼ�
Return

EditRowButtonOK:        ;Same as the AddRowButtonOK label above except for the LV_Modify instead of LV_Insert.
Gui,EditRow:Submit,NoHide
gosub,CloseChildGui

If(tmpstr="hotkeys")
{
Gui,99:ListView,hotkeysListview
LV_Modify(FocusedRowNumber,"",Col1Text,EditRowEditCol2)
hotkeys:=[]
eqaulhotkey:=0
LV_ColorChange()
ControlGet,AA,List,col2,SysListView321,ahk_class AutoHotkeyGUI,ѡ��
loop,parse,AA,`n,`r
	hotkeys[A_Index]:=A_LoopField
for k,v in hotkeys 
{
	If (v=EditRowEditCol2)
	eqaulhotkey+=1
}
If eqaulhotkey=2
{
	; RGBϵ��ɫ
	LV_ColorChange(FocusedRowNumber,"0xFF0000","0xFFFFFF") 
	LV_Modify(FocusedRowNumber,"-Select")
	LV_Modify(FocusedRowNumber+1,"Select")
	traytip,����,��ͬ��ݼ��Ѿ�����,5
	FlashTrayIcon(500,5)
}
}
If(tmpstr="Plugins")
{
Gui,99:ListView,PluginsListview
LV_Modify(FocusedRowNumber,"",Col1Text,EditRowEditCol2)
}
Return

7plusListView:
Gui,99:ListView,7pluslistview
If(A_GuiEvent = "I")
{
	If (ErrorLevel == "C")
	{
		LV_GetText(ContextMenuId,A_EventInfo,2)
		IniWrite,1,%run_iniFile%,%ContextMenuId%,showmenu
	}
	If (ErrorLevel == "c")
	{
		LV_GetText(ContextMenuId,A_EventInfo,2)
		IniWrite,0,%run_iniFile%,%ContextMenuId%,showmenu
	}
}
Else If(A_GuiEvent="DoubleClick")
{
	LV_GetText(ContextMenuId,A_EventInfo,2)
	gosub ReadContextMenuIni
	gosub GUI_EventsList_Edit
}
Return

GUI_EventsList_Edit:
Gui,98:Destroy
Gui,98:Default
Gui,98:+Owner99
Gui,99:+Disabled
Gui,Add,Text,x42 y30 w50 h20 ,ID�ţ�
Gui,Add,CheckBox,x42 y180 w250 h20 vDirectory,ѡ���ļ����Ҽ������˵�����ʾ
Gui,Add,CheckBox,x42 y200 w250 h20 vDirectoryBackground,�ļ���Ŀ¼�Ҽ��˵�����ʾ
Gui,Add,CheckBox,x42 y220 w250 h20 vDesktop,������˵�����ʾ
Gui,Add,CheckBox,x42 y240 w250 h20 vSingleFileOnly,ѡ�ж���ļ�ʱ�Ե�һ���ļ���Ч
Gui,Add,Text,x42 y60 w60 h20 ,�˵�����
Gui,Add,Text,x42 y90 w60 h20 ,������
Gui,Add,Text,x42 y120 w60 h20 ,�Ӳ˵��ڣ�
Gui,Add,Text,x42 y150 w60 h20 ,��չ����
Gui,Add,Edit,x122 y30 w230 h20 readonly vContextMenuId,%ContextMenuId%
Gui,Add,Edit,x122 y60 w230 h20 vName,%Name%
Gui,Add,Edit,x122 y90 w230 h20 vDescription,%Description%
Gui,Add,Edit,x122 y120 w230 h20 vSubMenu,%SubMenu%
Gui,Add,Edit,x122 y150 w230 h20 vFileTypes,%FileTypes%
Gui,Add,Button,x272 y280 w70 h30 gContextMenuok,ȷ��
Gui,Add,Button,x352 y280 w70 h30 g98GuiEscape Default,ȡ��
GuiControl,,Directory,%Directory%
GuiControl,,DirectoryBackground,%DirectoryBackground%
GuiControl,,Desktop,%Desktop%
GuiControl,,SingleFileOnly,%SingleFileOnly%
Gui,Show,,ϵͳ�Ҽ��˵�֮7Plus�˵��༭
Return

Edit_PluginsHotkey:
Gui,99:ListView,Pluginslistview
FocusedRowNumber:=0
FocusedRowNumber := LV_GetNext(0,"F")
If not FocusedRowNumber
{
	CF_ToolTip("δѡ�б༭��!",3000)
	Return
}
else{
tmpstr=Plugins
gosub, Edithotkey
}
Return

updaterh:
Gui Submit,nohide
Iniread,xq%MyRadiorh%,%run_iniFile%,ʱ��,xq%MyRadiorh%
if (xq%MyRadiorh%=1234567)
{
GuiControl,,cxq8,1
}
else
GuiControl,,cxq8,0

xqdsArray:=""
xqdsArray := StrSplit(xq%MyRadiorh%)
loop 7
GuiControl,,cxq%A_index%,0
for k,v in xqdsArray
{
 GuiControl,,cxq%v%,% (v=0)?0:1
}
Iniread,msgtp,%run_iniFile%,ʱ��,msgtp%MyRadiorh%
GuiControl,,msgtp,% msgtp
return

rxq:
Gui Submit,nohide
xqtemp:=(cxq1=0?0:1)*10**6+(cxq2=0?0:2)*10**5+(cxq3=0?0:3)*10**4+(cxq4=0?0:4)*10**3+(cxq5=0?0:5)*10**2+(cxq6=0?0:6)*10+(cxq7=0?0:7)
IniWrite,%xqtemp%,%run_iniFile%,ʱ��,xq%MyRadiorh%
Iniread,xq%MyRadiorh%,%run_iniFile%,ʱ��,xq%MyRadiorh%
if (xq%MyRadiorh%=1234567)
{
GuiControl,,cxq8,1
}
else
GuiControl,,cxq8,0
return

rrh:
Gui Submit,nohide
rhnum:=SubStr(A_GuiControl,0)
if %A_GuiControl% =
{
IniWrite,0,%run_iniFile%,ʱ��,xq%rhnum%
gosub updaterh
}
return

rmsgtp:
Gui Submit,nohide
IniWrite,%msgtp%,%run_iniFile%,ʱ��,msgtp%MyRadiorh%
return

exq:
Gui Submit,nohide
if (cxq8=1)
{
IniWrite,1234567,%run_iniFile%,ʱ��,xq%MyRadiorh%
gosub updaterh
}
return

updategbnz:
if(renwu2:=!renwu2)
guicontrol,,gbnz,����(�ѿ���)
else
guicontrol,,gbnz,����(�ѹر�)
return

Load_PluginsList:
Gui,99:ListView,Pluginslistview
LV_Delete()
PluginsList =
SetFormat, float ,2.0
Loop, %A_ScriptDir%\Plugins\*.ahk
  PluginsList = %PluginsList%%A_LoopFileName%`n
Sort, PluginsList
Loop, parse, PluginsList, `n
{
    if A_LoopField =  ; �����б�ĩβ�Ŀ���.
        continue
StringTrimRight, Plugins%A_index%, A_LoopField, 4
IniRead,Pluginhotkey%A_index%,%run_iniFile%,Plugins,% Plugins%A_index%, %A_Space%
If IsLabel(Plugins%A_index%) 
LV_Add("",Plugins%A_index%,Pluginhotkey%A_index%, "; ��ݼ������пɴ���������", A_index+0.0)
Else If IsLabel(Plugins%A_index% . "_click") 
LV_Add("",Plugins%A_index%,Pluginhotkey%A_index%, ";���ڽ�����", A_index+0.0)
else
LV_Add("",Plugins%A_index%,Pluginhotkey%A_index%, ";", A_index+0.0)
}
LV_ModifyCol()
LV_ModifyCol(4,40)
Return

Run_Plugin:
Gui,99:ListView,Pluginslistview
FocusedRowNumber:=0
FocusedRowNumber := LV_GetNext(0,"F")
If not FocusedRowNumber
{
	CF_ToolTip("δѡ�б༭��!",3000)
	Return
}
else
{
LV_GetText(Col1Text,FocusedRowNumber,1) 
Run,"%A_AhkPath%" "%A_ScriptDir%\Plugins\%Col1Text%.ahk"
}
Return

Buttun_Edit:
Gui,99:ListView,7pluslistview
FocusedRowNumber := LV_GetNext(0,"F")
;MsgBox % FocusedRowNumber
If not FocusedRowNumber
{
	CF_ToolTip("δѡ��!",3000)
	Return
}
Else
	LV_GetText(ContextMenuId,FocusedRowNumber,2)
gosub ReadContextMenuIni
gosub GUI_EventsList_Edit
Return

ReadContextMenuIni:
IniRead,Description,%run_iniFile%,%ContextMenuId%,Description
IniRead,Name,%run_iniFile%,%ContextMenuId%,Name
IniRead,Directory,%run_iniFile%,%ContextMenuId%,Directory
IniRead,DirectoryBackground,%run_iniFile%,%ContextMenuId%,DirectoryBackground
IniRead,Desktop,%run_iniFile%,%ContextMenuId%,Desktop
IniRead,SubMenu,%run_iniFile%,%ContextMenuId%,SubMenu
IniRead,SingleFileOnly,%run_iniFile%,%ContextMenuId%,SingleFileOnly
IniRead,FileTypes,%run_iniFile%,%ContextMenuId%,FileTypes
Return

ContextMenuok:
gui,98:Submit,NoHide
IniWrite,%Description%,%run_iniFile%,%ContextMenuId%,Description
IniWrite,%Name%,%run_iniFile%,%ContextMenuId%,Name
IniWrite,%Directory%,%run_iniFile%,%ContextMenuId%,Directory
IniWrite,%DirectoryBackground%,%run_iniFile%,%ContextMenuId%,DirectoryBackground
IniWrite,%Desktop%,%run_iniFile%,%ContextMenuId%,Desktop
IniWrite,%SubMenu%,%run_iniFile%,%ContextMenuId%,SubMenu
IniWrite,%SingleFileOnly%,%run_iniFile%,%ContextMenuId%,SingleFileOnly
IniWrite,%FileTypes%,%run_iniFile%,%ContextMenuId%,FileTypes
Gui,98:Destroy
Gui,99:-Disabled 
WinActivate,ѡ�� ahk_class AutoHotkeyGUI
send,!R
Return

Load_List:
Gui,99:ListView,7pluslistview
LV_Delete()
loop,%num%
{
	ContextMenuId:= A_Index+1000
	IniRead,name_%A_Index%,%run_iniFile%,%ContextMenuId%,name
	IniRead,showmenu_%A_Index%,%run_iniFile%,%ContextMenuId%,showmenu
	LV_Add(showmenu_%A_Index% = 1 ? "Check" : "","",ContextMenuId,name_%A_Index%)
}
Return

daps:
Gui,Submit,NoHide
If dap1=1
	DefaultPlayer=foobar2000
Else If dap2=1
	DefaultPlayer=iTunes
Else If dap3=1
	DefaultPlayer=Wmplayer
Else If dap4=1
	DefaultPlayer=TTPlayer
Else If dap5=1
	DefaultPlayer=Winamp
Else If dap6=1
	DefaultPlayer=AhkPlayer
Return

wk:
Gui,Submit,NoHide

ControlGet,AA,List,,SysListView321,ahk_class AutoHotkeyGUI,ѡ��
StringReplace, AA, AA, `t;, `n;, all
StringReplace, AA, AA, `t, =, all
hotkeycontent:="[��ݼ�]" . "`n" . AA
for k,v in IniObj(hotkeycontent,OrderedArray()).��ݼ�
	IniWrite,%v%,%run_iniFile%,��ݼ�,%k%

IniDelete, %run_iniFile%, Plugins
ControlGet,AA,List,,SysListView322,ahk_class AutoHotkeyGUI,ѡ��
StringReplace, AA, AA, `t;, `n;, all
StringReplace, AA, AA, `t, =, all
hotkeycontent:="[Plugins]" . "`n" . AA
for k,v in IniObj(hotkeycontent,OrderedArray()).Plugins
	IniWrite,%v%,%run_iniFile%,Plugins,%k%

IniWrite,%ask%,%run_iniFile%,��ͼ,ѯ��
IniWrite,%filetp%,%run_iniFile%,��ͼ,filetp
IniWrite,%update%,%run_iniFile%,���ܿ���,Auto_Update
IniWrite,%autorun%,%run_iniFile%,���ܿ���,run_with_sys
IniWrite,%mtp%,%run_iniFile%,���ܿ���,mousetip
IniWrite,% vAuto_DisplayMainWindow,%run_iniFile%,����ģʽѡ��,Auto_DisplayMainWindow
IniWrite,% vAuto_Trayicon,%run_iniFile%,���ܿ���,Auto_Trayicon
IniWrite,% vAuto_Trayicon_showmsgbox,%run_iniFile%,����ģʽѡ��,Auto_Trayicon_showmsgbox
IniWrite,% vShutdownMonitor,%run_iniFile%,���ܿ���,ShutdownMonitor
IniWrite,% vPasteAndOpen,%run_iniFile%,���ܿ���,PasteAndOpen
IniWrite,% vAuto_Clip,%run_iniFile%,���ܿ���,Auto_Clip
IniWrite,% vAuto_Cliphistory,%run_iniFile%,���ܿ���,Auto_Cliphistory
IniWrite,% vAuto_Capslock,%run_iniFile%,���ܿ���,Auto_Capslock
IniWrite,% vAuto_mouseclick,%run_iniFile%,���ܿ���,Auto_mouseclick
IniWrite,% vAuto_midmouse,%run_iniFile%,���ܿ���,Auto_midmouse
IniWrite,% vAuto_Spacepreview,%run_iniFile%,���ܿ���,Auto_Spacepreview
IniWrite,% vAuto_AhkServer,%run_iniFile%,���ܿ���,Auto_AhkServer
IniWrite,% vLoginPass,%run_iniFile%,serverConfig,LoginPass

IniWrite,%txt%,%run_iniFile%,����,txt
IniWrite,%TextEditor%,%run_iniFile%,����,TextEditor
IniWrite,%ImageEditor%,%run_iniFile%,����,ImageEditor

If(autorun=1){
	RegWrite,REG_SZ,HKEY_LOCAL_MACHINE,SOFTWARE\Microsoft\Windows\CurrentVersion\Run,Run - Ahk,%A_ScriptFullPath%
}
Else
	RegWrite,REG_SZ,HKEY_LOCAL_MACHINE,SOFTWARE\Microsoft\Windows\CurrentVersion\Run,Run - Ahk,%A_Space%
IniWrite,%x1%,%run_iniFile%,����,x_x
IniWrite,%y1%,%run_iniFile%,����,y_y

IniWrite,%Auto_Raise%,%run_iniFile%,���ܿ���,Auto_Raise
IniWrite,%hover_task_buttons%,%run_iniFile%,�Զ�����,hover_task_buttons
IniWrite,%hover_task_group%,%run_iniFile%,�Զ�����,hover_task_group
IniWrite,%hover_task_min_info%,%run_iniFile%,�Զ�����,hover_task_min_info
IniWrite,%hover_start_button%,%run_iniFile%,�Զ�����,hover_start_button
IniWrite,%hover_min_max%,%run_iniFile%,�Զ�����,hover_min_max
IniWrite,%hover_any_window%,%run_iniFile%,�Զ�����,hover_any_window
IniWrite,%scrollundermouse%,%run_iniFile%,�Զ�����,scrollundermouse
IniWrite,%hover_keep_zorder%,%run_iniFile%,�Զ�����,hover_keep_zorder
IniWrite,%hover_delay%,%run_iniFile%,�Զ�����,hover_delay

IniWrite,%baoshionoff%,%run_iniFile%,ʱ��,baoshionoff
IniWrite,%baoshilx%,%run_iniFile%,ʱ��,baoshilx
IniWrite,%renwu%,%run_iniFile%,ʱ��,renwu
IniWrite,%rh%,%run_iniFile%,ʱ��,rh
IniWrite,%rm%,%run_iniFile%,ʱ��,rm
IniWrite,%renwucx%,%run_iniFile%,ʱ��,renwucx
IniWrite,%rh1%,%run_iniFile%,ʱ��,rh1
IniWrite,%rh2%,%run_iniFile%,ʱ��,rh2
IniWrite,%rh3%,%run_iniFile%,ʱ��,rh3
IniWrite,%rh4%,%run_iniFile%,ʱ��,rh4
IniWrite,%rh5%,%run_iniFile%,ʱ��,rh5
IniWrite,%renwu2%,%run_iniFile%,ʱ��,renwu2
IniWrite,%Auto_JCTF%,%run_iniFile%,���ܿ���,Auto_JCTF

IniWrite,%ap1%,%run_iniFile%,AudioPlayer,Foobar2000
IniWrite,%ap2%,%run_iniFile%,AudioPlayer,iTunes
IniWrite,%ap3%,%run_iniFile%,AudioPlayer,Wmplayer
IniWrite,%ap4%,%run_iniFile%,AudioPlayer,TTPlayer
IniWrite,%ap5%,%run_iniFile%,AudioPlayer,Winamp
IniWrite,%DefaultPlayer%,%run_iniFile%,�̶��ĳ���,DefaultPlayer
IniWrite,%sp%,%run_iniFile%,�̶��ĳ���,stableProgram

IniDelete,%run_iniFile%,otherProgram
;FileAppend, `n`r, %run_iniFile%
Loop,Parse,op,`n`r
{
	otp2:=A_LoopField
	If otp2 contains [
	{
		continue
	}
	Else
	{
		If(NOT InStr(A_LoopField,"="))
			continue
		StringSplit,op2_,otp2,=
		othp2:=op2_1
		%othp2%:=op2_2
		IniWrite,%op2_2%,%run_iniFile%,otherProgram,%othp2%
	}
}
Sleep,10
Gui,Destroy
Reload

98GuiEscape:
98GuiClose:
CloseChildGui:
EditRowButtonCancel:
EditRowGuiClose:
EditRowGuiEscape:
Gui,99:-Disabled
Gui,Destroy
Gui,99:Default
Return

99GuiClose:
99GuiEscape:
LV_ColorChange()
Gui,Destroy
Return

LV_ColorInitiate(Gui_Number=1,Control="") ; initiate listview color change procedure 
{ 
	global hw_LV_ColorChange 
	If Control =
		Control = SysListView321
	Gui,%Gui_Number%:+Lastfound 
	Gui_ID := WinExist() 
	ControlGet,hw_LV_ColorChange,HWND,,%Control%,ahk_id %Gui_ID% 
	OnMessage( 0x4E,"WM_NOTIFY" ) 
} 

LV_ColorChange(Index="",TextColor="",BackColor="") ; change specific line's color or reset all lines
{ 
	global 
	If Index = 
		Loop,% LV_GetCount() 
			LV_ColorChange(A_Index) 
	Else
	{ 
		Line_Color_%Index%_Text := TextColor 
		Line_Color_%Index%_Back := BackColor 
		WinSet,Redraw,,ahk_id %hw_LV_ColorChange% 
	} 
}

; ��ֹ�����б����еĿ�ȣ������ֱ�ɫ
WM_NOTIFY( p_w,p_l,p_m )
{ 
	local draw_stage,Current_Line,Index
	Critical

	Static HDN_BEGINTRACKA = -306,HDN_BEGINTRACKW = -326,HDN_DIVIDERDBLCLICK = -320
	;Code := -(~NumGet(p_l+0,8))-1
	Code :=NumGet(p_l + 8,0,"Int")
	If (Code = HDN_BEGINTRACKA) || (Code = HDN_BEGINTRACKW)|| (Code = HDN_BEGINTRACKW)
		Return True
	If ( NumGet( p_l+0,0,"Uint") = hw_LV_ColorChange ){ 
		If ( NumGet(p_l+0,8,"int" ) = -12 ) {                            ; NM_CUSTOMDRAW 
			draw_stage := NumGet(p_l+0,12,"Uint") 
			If ( draw_stage = 1 )                                                 ; CDDS_PREPAINT 
				Return,0x20                                                      ; CDRF_NOTIFYITEMDRAW 
			Else If ( draw_stage = 0x10000|1 ){                                   ; CDDS_ITEM 
				Current_Line := NumGet( p_l+0,36,"Uint")+1 
				LV_GetText(Index,Current_Line,4) 
				If (Line_Color_%Index%_Text != ""){
					NumPut( BGR(Line_Color_%Index%_Text),p_l+0,48,"Uint")   ; foreground 
					NumPut( BGR(Line_Color_%Index%_Back),p_l+0,52,"Uint")   ; background 
				}
			}
		}
	}
}

BGR(i) {
   Return, (i & 0xff) << 16 | (i & 0xffff) >> 8 << 8 | i >> 16
}