; RunZ:System
; ����ϵͳ��ع���

System:
    @("Clip", "��ʾ���а�����")
    @("ClearClipboardFormat", "������а������ֵĸ�ʽ")
    @("EmptyRecycle", "��ջ���վ")
    @("Logoff", "ע�� �ǳ�")
    @("RestartMachine", "����")
    @("ShutdownMachine", "�ػ�")
    @("SuspendMachine", "���� ˯�� ����")
    @("HibernateMachine", "����")
    @("TurnMonitorOff", "�ر���ʾ��")
    @("ListProcess", "�г����� ps")
    @("DiskSpace", "�鿴���̿ռ� df")
    @("IncreaseVolume", "�������")
    @("DecreaseVolume", "��������")
    @("SystemState", "ϵͳ״̬ top")
    @("KillProcess", "ɱ������")
    @("SendToClip", "���͵����а�")
    @("ListWindow", "�����б�")
    @("ActivateWindow", "�����")
    @("ListRunningService", "�г����еķ���")
    @("ListAllService", "�г����еķ���")
    @("ShowService", "��ʾ��������")
    @("ShowProcess", "��ʾ��������")
return

Clip:
    GoSub, ActivateRunZ
    DisplayResult("���а����ݳ��� " . StrLen(clipboard) . " ��`n`n" . clipboard)
return

ClearClipboardFormat:
    clipboard := clipboard
return

Logoff:
    MsgBox, 4, , ��Ҫע�����Ƿ�ִ�У�
    IfMsgBox Yes
    {
        Shutdown, 0
    }
return

ShutdownMachine:
    MsgBox, 4, , ��Ҫ�ػ����Ƿ�ִ�У�
    IfMsgBox Yes
    {
        Shutdown, 1
    }
return

RestartMachine:
    MsgBox, 4, , ��Ҫ�����������Ƿ�ִ�У�
    IfMsgBox Yes
    {
        Shutdown, 2
    }
return

HibernateMachine:
    MsgBox, 4, , ��Ҫ���ߣ��Ƿ�ִ�У�
    IfMsgBox Yes
    {
        ; ���� #1: ʹ�� 1 ���� 0 ���������߶����ǹ���
        ; ���� #2: ʹ�� 1 ���� 0 �������������ѯ��ÿ��Ӧ�ó����Ի����ɡ�
        ; ���� #3: ʹ�� 1 ������ 0 ����ֹ���еĻ����¼���
        DllCall("PowrProf\SetSuspendState", "int", 1, "int", 0, "int", 0)
    }
return

SuspendMachine:
    MsgBox, 4, , ��Ҫ�������Ƿ�ִ�У�
    IfMsgBox Yes
    {
        DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
    }
return

TurnMonitorOff:
    ; �ر���ʾ��:
    SendMessage, 0x112, 0xF170, 2,, Program Manager
    ; 0x112 is WM_SYSCOMMAND, 0xF170 is SC_MONITORPOWER.
    ; �����������ע��: ʹ�� -1 ���� 2 ������ʾ��.
    ; ʹ�� 1 ���� 2 ��������ʾ���Ľ���ģʽ.
return

EmptyRecycle:
    MsgBox, 4, , ��Ҫ��ջ���վ���Ƿ�ִ�У�
    IfMsgBox Yes
    {
        FileRecycleEmpty,
    }
return

ListProcess:
    result := ""

    for process in ComObjGet("winmgmts:").ExecQuery("select * from Win32_Process")
    {
        result .= "* | ���� | " process.Name " | " process.CommandLine "`n"
    }
    Sort, result

    SetCommandFilter("KillProcess|ShowProcess|CountNumber")
    DisplayResult(FilterResult(AlignText(result), Arg))
    TurnOnResultFilter()
return

DiskSpace:
    result := ""

    DriveGet, list, list
    Loop, Parse, list
    {
        drive := A_LoopField ":"
        DriveGet, label, label, %drive%
        DriveGet, cap, capacity, %drive%
        DrivespaceFree, free, %drive%
        SetFormat, float, 5.2
        percent := 100 * (cap - free) / cap
        SetFormat, float, 6.2
        cap /= 1024.0
        free /= 1024.0
        result = %result%* | %drive% | �ܹ�: %cap% G  ����: %free% G | ��ʹ�ã�%percent%`%  ���: %label%`n
    }

    DisplayResult(AlignText(result))
return

IncreaseVolume:
    SoundSet, +5
return

DecreaseVolume:
    SoundSet, -5
return

SystemState:
    if (!SetExecInterval(1))
    {
        return
    }

    GMSEx := GlobalMemoryStatusEx()
    result := "* | ״̬ | ����ʱ�� | " Round(A_TickCount / 1000 / 3600, 3) " Сʱ`n"
    result .= "* | ״̬ | CPU ռ�� | " CPULoad() "% `n"
    result .= "* | ״̬ | �ڴ�ռ�� | " Round(100 * (GMSEx[2] - GMSEx[3]) / GMSEx[2], 2) "% `n"
    result .= "* | ״̬ | �������� | " GetProcessCount() "`n"
    result .= "* | ״̬ | �ڴ����� | " Round(GMSEx[2] / 1024**2, 2) "MB `n"
    result .= "* | ״̬ | �����ڴ� | " Round(GMSEx[3] / 1024**2, 2) "MB `n"
    DisplayResult(AlignText(result))
return

KillProcess:
    args := StrSplit(Arg, " ")
    for index, argument in args
    {
        Process, Close, %argument%
    }

    DisplayResult("�ѳ���ɱ�� " Arg " ����")
return

SendToClip:
    clipboard := Arg
    GoSub, Clip
return

ListWindow:
    result := ""

    WinGet, id, list, , , Program Manager
    Loop, %id%
    {
        thisId := id%A_Index%
        WinGetTitle, title, ahk_id %thisId%
        WinGet, name, ProcessName, ahk_id %thisId%
        if (title == "")
        {
            continue
        }
        result .= "* | ���� | " name " | " title "`n"
    }

    SetCommandFilter("ActivateWindow|KillProcess")
    DisplayResult(AlignText(result))
    TurnOnResultFilter()
return

ActivateWindow:
    DisplayResult()
    ClearInput()

    if (FullPipeArg != "")
    {
        Loop, Parse, FullPipeArg, `n, `r
        {
            if (A_LoopField == "")
            {
                return
            }
            splitedLine := StrSplit(A_LoopField, " | ")
            WinActivate, % Trim(splitedLine[4])
        }
    }
    else
    {
        for index, argument in StrSplit(Arg, " ")
        {
            WinActivate, ahk_exe %argument%
        }
    }
return

ListAllService:
    result :=
    for service in ComObjGet("winmgmts:").ExecQuery("select * from Win32_Service")
    {
        result .= "* | ���� | " service.Name " | " service.DisplayName "`n"
    }
    Sort, result

    SetCommandFilter("CountNumber|ShowService")
    DisplayResult(FilterResult(AlignText(result), Arg))
    TurnOnResultFilter()
return

ListRunningService:
    result :=
    for service in ComObjGet("winmgmts:").ExecQuery("select * from Win32_Service")
    {
        if (service.Started != 0)
        {
            result .= "* | ���� | " service.Name " | " service.DisplayName "`n"
        }
    }
    Sort, result

    SetCommandFilter("CountNumber|ShowService")
    DisplayResult(FilterResult(AlignText(result), Arg))
    TurnOnResultFilter()
return

ShowService:
    result :=
    ; ��ʱֻ֧��һ����ѡ�ö��˲�����̫��
    for service in ComObjGet("winmgmts:")
        .ExecQuery("select * from Win32_Service where Name = '" StrSplit(Arg, " ")[1] "'")
    {
        ; https://msdn.microsoft.com/en-us/library/windows/desktop/aa394418%28v=vs.85%29.aspx
        result .= "* | ���� | ���� | " service.Name "`n"
        result .= "* | ���� | ���� | " service.Description "`n"
        result .= "* | ���� | �Ƿ������� | " service.Started "`n"
        result .= "* | ���� | ·�� | " service.PathName "`n"
        result .= "* | ���� | ���� ID | " service.ProcessId "`n"
        result .= "* | ���� | ���� | " service.ServiceType "`n"
        break
    }

    DisplayResult(AlignText(result))
return

ShowProcess:
    result :=
    ; ��ʱֻ֧��һ����ѡ�ö��˲�����̫��
    for process in ComObjGet("winmgmts:")
        .ExecQuery("select * from Win32_Process where Name = '" StrSplit(Arg, " ")[1] "'")
    {
        ; https://msdn.microsoft.com/en-us/library/windows/desktop/aa394372%28v=vs.85%29.aspx
        result .= "* | ���� | ���� | " process.Name "`n"
        result .= "* | ���� | ���� | " process.Description "`n"
        result .= "* | ���� | ������ | " process.CommandLine "`n"
        result .= "* | ���� | ����ʱ�� | " process.CreationDate "`n"
        result .= "* | ���� | ID | " process.ProcessId "`n"
        break
    }

    DisplayResult(AlignText(result))
return
