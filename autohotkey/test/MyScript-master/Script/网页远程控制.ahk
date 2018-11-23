indexInit:
mytext:=CF_IniRead(run_iniFile, "serverConfig","mytext")

Index_Html =
(
<!doctype html>
<html>
<head>
<title> ��ҳ���� </title>
<link href="https://autohotkey.com/favicon.ico" type="image/x-icon" rel="shortcut icon">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style>
p {
  font-family: Arial,Helvetica,sans-serif;
  font-size: %textFontSize%;
}

button {
  font-family: Arial,Helvetica,sans-serif;
  font-size: %buttonSize%;
}

h1 {
	padding: %pagePadding%; width: auto; font-family: Sans-Serif; font-size: 22pt;
}

input{
width: 700px ; height: 48px;
}

body {
	background-color : black ;
	color : yellow ;
	padding: %pagePadding%; width: auto; font-family: Sans-Serif; font-size: 16pt;
}

</style>
</head>
<body>
<p>���ڲ���</p>
<h1>
%NowPlaying%
</h1>

<p>����������</p>
<p>
<a href="/startaudioplayer"> <button> ������ </button>  </a> 
<a href="/previous"> <button> ��һ�� </button>  </a> 
<a href="/pause_play"> <button> ����/��ͣ </button> </a>
<a href="/next"> <button> ��һ�� </button> </a>
<a href="/exitapp"> <button> �˳� </button> </a>
</p>

<p>
<a href="/vp"> <button> ����+ </button> </a>
<a href="/vm"> <button> ����- </button> </a>
<a href="/u_m"> <button> ���� </button> </a>
<a href="/vHigh"> <button> 80`% </button> </a>
<a href="/vMed"> <button> 50`% </button> </a>
<a href="/vLow"> <button> 20`% </button> </a>
</p>

<p> &nbsp; </p>

<p>ϵͳ����</p>

<p>
<a href="/standby"> <button> ���� </button> </a>
<a href="/hibernate"> <button> ���� </button> </a>
<a href="/monitorOnOff"> <button> ��Ļ���� </button> </a>
<a href="/logout"> <button> �˳���¼ </button> </a>
<a href="/serverReload"> <button> �������� </button> </a>
</p>

<p> &nbsp; </p>

<p>�ļ�����</p>
<p> 
<a href="/music"> <button> mp3 �ļ�</button> </a> 
<a href="/excel" download="ͨ��������־.xls"> <button> xls �ļ�</button> </a>
<a href="/txt" download="���ĸ���.txt"> <button> txt �ļ�</button> </a>
</p>

<p>�����ı�</p>
<form action="/submit" method="get">
<input type="text" id="1234" name="mytext" value="%mytext%" />
<input type=submit style="width: 80px; height: 55px;" value="��������"/>  
<!-- <a href="/submit"> <button> �ύ </button> </a> --!>
</form>

<p>��������</p>

<!--select��ǩ��input�����span��ǩ�ĸ�ʽ��Ϊ��ʹ����λ����ͬһλ�ã�����λ��-->
<!--��name���Զ����ύ-->
<form action="/runcom" method="get">
<span style="position:absolute;border:1pt solid #c1c1c1;overflow:hidden;width:740px;height:54px;">
<select name="aabb" id="aabb" style="width:742px;height:55px;" 
onChange="javascript:document.getElementById('ccdd').value=document.getElementById('aabb').options[document.getElementById('aabb').selectedIndex].value;">
<!--�����option����ʽ��Ϊ��ʹ����Ϊ��ɫ��ֻ���Ӿ����⣬����������ע��һ��-->
<option value="" style="color:#c2c2c2;">---��ѡ��---</option>
<option value="%stableitem1%">hichat2626</option>
<option value="%stableitem2%">��Ŀ��</option>
<option value="%stableitem3%">��Ŀ��</option>
<option value="%stableitem4%">��Ŀ��</option>
<option value="%stableitem5%">��Ŀ��</option>
</select> 
</span> 
<span style="position:absolute;border-top:1pt solid #c1c1c1;border-left:1pt solid #c1c1c1;border-bottom:1pt solid #c1c1c1;width:700px;height:50px;"> 
<input type="text" name="ccdd" id="ccdd" placeholder="������Ҫ���е�����, �س��ύ">
</span>
<span> 
<input type="submit" style="width: 80px; height: 50px;" value="�ύ"/>
</span> 
</form>

</body>
</html>
)

SiteContents =
(LTrim
	<!DOCTYPE html>
	<html>
		<head>
			<meta charset="UTF-8">
			<meta name="viewport" content="width=device-width">
			<title>��ҳ����</title>
			<link href='http://fonts.googleapis.com/css?family=Ubuntu' rel='stylesheet' type='text/css'>
			<style>
				html {
					font-family: Ubuntu;
				}
				body {
					margin:25px;
					margin-top:5px;
				}
				h4 {
					font-size: 20px;
					color:green;
				}
				h5 {
					font-size: 16px;
					color:teal;
				}
			</style>
			<script type="text/javascript">
				[ScriptTagContents]
			</script>
		</head>
		<body>
			[BodyTagContents]
		</body>
	</html>
)

global UserLogin
global UserPass
global StoredReqBody

if indexInit_activated
	Return	;to return only after first initilisation,i.e from a 'Gosub'
indexInit_activated++

paths := {}
paths["/"] := Func("Index")
paths["/logo"] := Func("Logo")
paths["/page"] := Func("MainPage")

paths["/startaudioplayer"] := Func("startaudioplayer")
paths["/previous"] := Func("previous")
paths["/pause_play"] := Func("pause_play")
paths["/next"] := Func("next")
paths["/exitapp"] := Func("exitapp")

paths["/vp"] := Func("vp")
paths["/vm"] := Func("vm")
paths["/u_m"] := Func("u_m")
paths["/vHigh"] := Func("vHigh")
paths["/vMed"] := Func("vMed")
paths["/vLow"] := Func("vLow")

paths["/standby"] := Func("standby")
paths["/hibernate"] := Func("hibernate")
paths["/monitorOnOff"] := Func("monitorOnOff")
paths["/logout"] := Func("logout")
paths["/serverReload"] := Func("serverReload")

paths["/submit"] := Func("submit")
paths["/runcom"] :=Func("runcom")

paths["/music"] := Func("music")
paths["/excel"] := Func("excel")
paths["/txt"] := Func("txt")

paths["404"] := Func("NotFound")

server := new HttpServer()
server.LoadMimes(A_ScriptDir . "/lib/mime.types")
server.SetPaths(paths)
server.Serve(serverPort)
return

Logo(ByRef req, ByRef res, ByRef server) {
    server.ServeFile(res, A_ScriptDir . "/pic/logo.png")
    res.status := 200
}

;��ȡ���ڲ��ŵĸ���  ��ֻ֧�� foobar2000��ahkplayer
Index(ByRef req, ByRef res) {
Global
if loginpass
{
NowPlaying:=""
DetectHiddenWindows, On
SetTitleMatchMode,2
activeplayer:=activeplayer(DefaultPlayer)
sleep,1500
WinGetTitle, NowPlaying, % " - " activeplayer

	Gosub, indexInit	;to refresh page
    res.SetBodyText(Index_Html)
    res.status := 200
}
else
{
ContentsOfScript = <!--...-->
ContentsToDisplay=
	(LTrim
		<div class="container" align="center">
			<section id="content">
				<form action="/page" method="post">
					<h4>��¼</h4>
					<div id="username">
						<input type="text" placeholder="�û���" required="" name="username" />
					</div>
					<div id="password">
						<input type="password" placeholder="����" required="" name="password" />
					</div>
					<br />
					<div id="button1">
						<input type="submit" value="��¼" />
					</div>
				</form>
				<div class="button">
				</div>
			</section>
		</div>
	)
	StringReplace, ServeTemp, SiteContents, [ScriptTagContents], %ContentsOfScript%, All
	StringReplace, Serve, ServeTemp, [BodyTagContents], %ContentsToDisplay%, All
	res.SetBodyText(Serve)
	res.status := 200
}
}

MainPage(ByRef req, ByRef res){
Global
	UserLogin = ;Wipe all contents
	UserPass = ;Wipe all contents
	HttpReqBodyArray := "" ;Release the object
	HttpReqBodyArray := Object()
	For each, Pair in StrSplit(req.body,"&")
	{
		Part := StrSplit(Pair, "=")
		HttpReqBodyArray.Push([Part[1], Part[2]])
	}
	UserLogin := HttpReqBodyArray[1,2]
	UserPass := HttpReqBodyArray[2,2]
	If (UserLogin != StoredLogin) || (UserPass != StoredPass)
	{
		ContentsToDisplay = <p>�û������������</p>
	StringReplace, ServeTemp, SiteContents, [ScriptTagContents], %ContentsOfScript%, All
	StringReplace, Serve, ServeTemp, [BodyTagContents], %ContentsToDisplay%, All
	res.SetBodyText(Serve)
	res.status := 200
	}
	Else
	{
LoginPass:=1
;StoredReqBody := req.body
	res.SetBodyText(Index_Html)
	res.status := 200
}
}

resetScheduleTimer(ByRef req, ByRef res){
Global
scheduleDelay := 0
SHT:=scheduleDelay//60000	;standby/hibernate timer abstracted in minutes
SetTimer, scheduledStandby, off
SetTimer, scheduledHibernate, off
Msg(, "Timer Reset,all scheduled StandBy/Hibernate timers also disabled.")
	Index(req, res)
}

TimerInc(ByRef req, ByRef res){
Global
scheduleDelay+=1800000	;add 30 minutes
SHT:=scheduleDelay//60000	;standby/hibernate timer abstracted in minutes
Msg(, "StandBy/Hibernate Timer Added 30min, NOW: " . SHT . "min")
	Index(req, res)
}

TimerDec(ByRef req, ByRef res){
Global
if !scheduleDelay	;if already zero,don't go down to negative numbers!
	{
	Index(req, res)
	Return
	}
scheduleDelay-=1800000	;subtract 30 minutes
SHT:=scheduleDelay//60000	;standby/hibernate timer abstracted in minutes
Msg(, "StandBy/Hibernate Timer Decreased 30min, NOW: " . SHT . "min")
	Index(req, res)
}

standby(ByRef req, ByRef res){
Global
if loginpass
{
	Index(req, res)
if scheduleDelay
	{
	SetTimer, scheduledHibernate, off
	SetTimer, scheduledStandby, %scheduleDelay%
	Msg(, "StandBy Scheduled after, " . SHT . "min")
	Return
	}
; Call the Windows API function "SetSuspendState" to have the system suspend or hibernate.
; Parameter #1: Pass 1 instead of 0 to hibernate rather than suspend.
; Parameter #2: Pass 1 instead of 0 to suspend immediately rather than asking each application for permission.
; Parameter #3: Pass 1 instead of 0 to disable all wake events.
DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
}
}

hibernate(ByRef req, ByRef res){
Global
if loginpass
{
	Index(req, res)
if scheduleDelay
	{
	SetTimer, scheduledStandby, off
	SetTimer, scheduledHibernate, %scheduleDelay%
	Msg(, "Hibernation Scheduled after, " . SHT . "min")
	Return
	}
; Call the Windows API function "SetSuspendState" to have the system suspend or hibernate.
; Parameter #1: Pass 1 instead of 0 to hibernate rather than suspend.
; Parameter #2: Pass 1 instead of 0 to suspend immediately rather than asking each application for permission.
; Parameter #3: Pass 1 instead of 0 to disable all wake events.
DllCall("PowrProf\SetSuspendState", "int", 1, "int", 0, "int", 0)
}
}

monitorOnOff(ByRef req, ByRef res){
Global
	Index(req, res)
; Turn Monitor Off:
if mOn
	{
	SendMessage, 0x112, 0xF170, 2,, Program Manager  ; 0x112 is WM_SYSCOMMAND, 0xF170 is SC_MONITORPOWER.
	mOn:=0
	return
	}
; Turn Monitor On:
if !mOn
	{
	Msg(, "Monitor On")
	SendMessage, 0x112, 0xF170, -1,, Program Manager  ; 0x112 is WM_SYSCOMMAND, 0xF170 is SC_MONITORPOWER.
	mOn:=1
	return
	}
; Note for the above: Use -1 in place of 2 to turn the monitor on.
; Use 1 in place of 2 to activate the monitor's low-power mode.
}

logout(ByRef req, ByRef res){
Global
loginpass:=0
	Index(req, res)
}

serverReload(ByRef req, ByRef res){
	Index(req, res)
if loginpass
Reload
}

; �ո���+��
submit(ByRef req, ByRef res){
Global run_iniFile
pp:=req.queries["mytext"]
qq:=StringToHex(pp)
MCode(varchinese, qq)
iniwrite, % StrGet(&varchinese, "cp65001"), %run_iniFile%, serverConfig, mytext
	Index(req, res)
return
}

; �ո���+�� ʹ�á����+��
runcom(ByRef req, ByRef res){
Global
pp:=req.queries["ccdd"]
qq:=StringToHex(pp)
MCode(varchinese, qq)
command:=StrGet(&varchinese,"cp65001")
command := StrReplace(command, "+", " ")
command := StrReplace(command, "��", "+")
if loginpass
{
if IsLabel(command)
{
gosub % command
return
}
if IsStingFunc(command)
 RunStingFunc(command)
Run,%command%,,UseErrorLevel
If ErrorLevel
	{
If % %dir%<>""
		{
			Run,% %Dir%,,UseErrorLevel
}
}
}
	Index(req, res)
return
}

startaudioplayer(ByRef req, ByRef res){
Msg(, "�򿪲�����")
gosub OpenAudioPlayer
	Index(req, res)
}

previous(ByRef req, ByRef res){
Msg(, "��һ��")
gosub GB1_down_up
	Index(req, res)
}

pause_play(ByRef req, ByRef res){
Msg(, "����/��ͣ")
gosub GB2_down_up
	Index(req, res)
}

next(ByRef req, ByRef res){
Msg(, "��һ��")
gosub GB3_down_up
	Index(req, res)
}

exitapp(ByRef req, ByRef res){
	Index(req, res)
Msg(, "�˳�������")
gosub GB4_down_up
}

vp(ByRef req, ByRef res){
	Index(req, res)
SoundGet, masterVolumeLevel
Msg(, "�Ӵ����� - " . masterVolumeLevel)
	Send {Volume_Up} ;  increase volume
}
vm(ByRef req, ByRef res){
	Index(req, res)
SoundGet, masterVolumeLevel
Msg(, "�������� - " . masterVolumeLevel)
	Send {Volume_Down} ;  lower volume
}
vHigh(ByRef req, ByRef res){
	Index(req, res)
Msg(, "���� : 80")
	SoundSet, 80  ; Set the master volume to 80%
}
vMed(ByRef req, ByRef res){
	Index(req, res)
Msg(, "���� : 50")
	SoundSet, 50  ; Set the master volume to 50%
}
vLow(ByRef req, ByRef res){
	Index(req, res)
Msg(, "���� : 20")
	SoundSet, 20  ; Set the master volume to 20%
}
u_m(ByRef req, ByRef res){
Global
	Index(req, res)
Msg(, "Un/Mute")
	Send {Volume_Mute} ;  mute volume toggle
}

music(ByRef req, ByRef res){
Global
Msg(, "Music")
    f := FileOpen(mp3file, "r") ; example mp3 file
    length := f.RawRead(data, f.Length)
    f.Close()
    res.status := 200
    ;res.headers["Content-Type"] := "audio/mpeg"
    res.SetBody(data, length)
	;Index(req, res)
}

excel(ByRef req, ByRef res){
Global
Msg(, "excel")
    f := FileOpen(excelfile, "r") ; example mp3 file
    length := f.RawRead(data, f.Length)
    f.Close()
    res.status := 200
    ;res.headers["Content-Type"] := "audio/x-mpequrl"
res.headers["content-disposition"] := "attachment;filename=ͨ��������־.xls"
    res.SetBody(data, length)
}

txt(ByRef req, ByRef res){
Global
Msg(, "txt")
    f := FileOpen(txtfile, "r") ; example mp3 file
    length := f.RawRead(data, f.Length)
    f.Close()
    res.status := 200
    ;res.headers["Content-Type"] := "audio/x-mpequrl"
res.headers["content-disposition"] := "attachment;filename=���ĸ���.txt"
    res.SetBody(data, length)
}

NotFound(ByRef req, ByRef res) {
    res.SetBodyText("Page not found")
}

;========================================================================================================================================================================================
;---------------------------------------------------------------
; Msg Monolog
; http://www.autohotkey.com/board/topic/94458-msgbox-or-traytip-replacement-monolog-non-modal-transparent-msg-cornernotify/
;---------------------------------------------------------------

Msg(title="��ҳ����", body="", loc="bl", fixedwidth=0, time=0) {
	global msgtransp, hwndmsg, MonBottom, MonRight
	SetTimer, MsgStay, Off
	SetTimer, MsgFadeOut, Off
	Gui,77:Destroy
	Gui,77:+AlwaysOnTop +ToolWindow -SysMenu -Caption +LastFound
	hwndmsg := WinExist()
	WinSet, ExStyle, +0x20 ; WS_EX_TRANSPARENT make the window transparent-to-mouse
	WinSet, Transparent, 250
	msgtransp := 250
	Gui,77:Color, 000000 ;background color
	Gui,77:Font, c5C5CF0 s17 wbold, Arial
	Gui,77:Add, Text, x20 y12, %title%
	If(body) {
		Gui,77:Font, cFF0000 s15 wnorm
		Gui,77:Add, Text, x20 y56, %body%
	}
	If(fixedwidth) {
		Gui,77:Show, NA W700
	} else {
		Gui,77:Show, NA
	}
	WinGetPos,ix,iy,w,h, ahk_id %hwndmsg%
	; SysGet, Mon, MonitorWorkArea ; already called
	if(loc) {
		x := InStr(loc,"l") ? 0 : InStr(loc,"c") ? (MonRight-w)/2 : InStr(loc,"r") ? A_ScreenWidth-w : 0
		y := InStr(loc,"t") ? 0 : InStr(loc,"m") ? (MonBottom-h)/2 : InStr(loc,"b") ? MonBottom - h : MonBottom - h
	} else { ; bl
		x := 0
		y := MonBottom - h
	}
	WinMove, ahk_id %hwndmsg%,,x,y
	If(time) {
		time *= 1000
		SetTimer, MsgStay, %time%
	} else {
		SetTimer, MsgFadeOut, 100
	}
}

MsgStay:
	SetTimer, MsgStay, Off
	SetTimer, MsgFadeOut, 1
Return

MsgFadeOut:
	If(msgtransp > 0) {
		msgtransp -= 4
		WinSet, Transparent, %msgtransp%, ahk_id %hwndmsg%
	} Else {
		SetTimer, MsgFadeOut, Off
		Gui,77:Destroy
	}
Return

;Goto, unintendedStdBy_Hib_JUMP	;so that standby/hibernate is not activated on script exit & labels can only be reached if called
scheduledStandby:
	SetTimer, scheduledStandby, off
	scheduleDelay:=0	;reset timer to allow going into standby/hibernate
	standby(req, res)
Return
scheduledHibernate:
	SetTimer, scheduledHibernate, off
	scheduleDelay:=0	;reset timer to allow going into standby/hibernate
	hibernate(req, res)
Return
;unintendedStdBy_Hib_JUMP:

;::mrcexit::
;ExitApp