
;定义命令
d_down_path = D:\Downloads    ;;; autohotkey 可以事先定义一些变量
npp_path = C:\software2018\notepadplusplus\notepad++.exe
se_path = C:\Users\Administrator\Downloads\images\s
temp_path = D:\temp
prompt = 
(
说明：
输入特定缩写执行特定命令
)
script_path = C:\backup_files\autohotkey\AHK-Script-Manager-master\scripts
;===============
!c::
	inputBox,command,快捷命令输入,%prompt%,,300,150,enter command															
	if ErrorLevel		
		return
    else
		if (command=="dd")			
			run %d_down_path%   ;;;打开指定文件夹 用两个百分号%%包围说明这是一个变量
		else if (command=="baidu")
			run http://www.baidu.com  ;;; 快速打开百度
		else if (command=="c" || command=="d" || command=="e" || command=="f")
			run %command%:/   ;;快速打开这些盘
		else if (command=="npp")
			run %npp_path%     ;;快速打开npp
		else if (command=="se")
			run %se_path%
		else if (command=="temp")
			run %temp_path%
		else if (command=="script")
			run %script_path%
	return
return

;==================测试,重载热键f5，放最后	
#IfWinActive ahk_exe SciTE.exe
f5::
Reload
Return
#IfWinActive

