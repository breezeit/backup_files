; RunZ:Core
; ���Ĺ���

Core:
    @("Help", "������Ϣ")
    @("KeyHelp", "�ö��İ���������Ϣ")
    @("AhkRun", "ʹ�� Ahk �� Run ����")
    @("CmdRun", "ʹ�� cmd ���� : command")
    @("CmdRunOnly", "ֻʹ�� cmd ����")
    @("WinRRun", "ʹ�� win + r ����")
    @("RunAndDisplay", "ʹ�� cmd ���У�����ʾ���")
    @("ReindexFiles", "���������������ļ�")
    @("EditConfig", "�༭�����ļ�")
    @("RunClipboard", "ʹ�� ahk �� Run ���м��а�����")
    @("CleanupRank", "��������Ȩ���е���Ч����")
    @("ShowArg", "��ʾ������ShowArg arg1 arg2 ...")
    @("AhkTest", "���в������߼��а��е� AHK ����")
    @("InstallPlugin", "��װ���")
    @("RemovePlugin", "ж�ز��")
    @("ListPlugin", "�г����")
    @("CleanupPlugin", "������")
    @("CountNumber", "�������� wc")
    @("Open", "��")
return

CmdRun:
    RunWithCmd(Arg)
return

CmdRunOnly:
    RunWithCmd(Arg, true)
return

AhkRun:
    if (!g_Conf.Config.DebugMode)
    {
        try
        {
            Run, "%Arg%"
        }
        catch e
        {
            MsgBox, �������� %Arg% ʧ��`n���������ļ��� DebugMode Ϊ 1 �ɲ鿴��������
        }
    }
    else
    {
        Run, "%Arg%"
    }
return

ShowArg:
    args := StrSplit(Arg, " ")
    result := "���� " . args.Length() . " ��������`n`n"

    for index, argument in args
    {
        result .= "�� " . index . " ��������" . argument . "`n"
    }

    DisplayResult(result)
return

RunClipboard:
    Run, %clipboard%
return

RunAndDisplay:
    DisplayResult(RunAndGetOutput(Arg))
return

WinRRun:
    Send, #r
    Sleep, 100
    Send, %Arg%
    Send, {enter}
return

AhkTest:
    text := Arg == "" ? clipboard : Arg
    FileDelete, %A_Temp%\RunZ.AhkTest.ahk
    FileAppend, %text%, %A_Temp%\RunZ.AhkTest.ahk
    Run, %A_Temp%\RunZ.AhkTest.ahk
return

InstallPlugin:
    pluginPath := Arg

    if (InStr(pluginPath, "http") == 1)
    {
        DisplayResult("�����У����Ժ�...")
        UrlDownloadToFile, %pluginPath%, %A_Temp%\RunZ.Plugin.txt
        pluginPath := A_Temp "\RunZ.Plugin.txt"
    }

    if (FileExist(pluginPath))
    {
        FileReadLine, firstLine, %pluginPath%, 1
        if (!InStr(firstLine, "; RunZ:"))
        {
            DisplayResult(pluginPath " ��������Ч�� RunZ ���")
            return
        }

        pluginName := StrSplit(firstLine, "; RunZ:")[2]
        if (FileExist(A_ScriptDir "\Runz\Plugins\" pluginName ".ahk"))
        {
            DisplayResult("�ò���Ѵ���")
            return
        }

        FileMove, %pluginPath%, %A_ScriptDir%\Runz\Plugins\%pluginName%.ahk
        FileAppend, #include *i `%A_ScriptDir`%\Runz\Plugins\%pluginName%.ahk`n
            , %A_ScriptDir%\Runz\Core\Plugins.ahk

        DisplayResult(pluginName " �����װ�ɹ���RunZ �����������øò��")
        Sleep, 1000
        GoSub, RestartRunZ
    }
    else
    {
        DisplayResult(pluginPath " �ļ�������")
    }
return

RemovePlugin:
    pluginName := Arg
    if (!FileExist(A_ScriptDir "\Runz\Plugins\" pluginName ".ahk"))
    {
        DisplayResult("δ��װ�ò��")
        return
    }

    FileRead, currentPlugins, %A_ScriptDir%\Runz\Core\Plugins.ahk
    StringReplace, currentPlugins, currentPlugins
        , #include *i `%A_ScriptDir`%\Runz\Plugins\%pluginName%.ahk`r`n
    FileDelete, %A_ScriptDir%\Runz\Core\Plugins.ahk
    FileAppend, %currentPlugins%, %A_ScriptDir%\Runz\Core\Plugins.ahk
    FileDelete, %A_ScriptDir%\Runz\Plugins\%pluginName%.ahk

    DisplayResult(pluginName " ���ɾ���ɹ���RunZ ����������Ч")
    Sleep, 1000
    GoSub, RestartRunZ
return

ListPlugin:
    result := ""
    Loop, Files, %A_ScriptDir%\Runz\Plugins\*.ahk
    {
        pluginName := StrReplace(A_LoopFileName, ".ahk")
        FileReadLine, secondLine, %A_LoopFileLongPath%, 2
        if (g_Conf.GetValue("Plugins", pluginName) == 0)
        {
            result .= "* | ��� | " pluginName " | �ѽ���  ������" SubStr(secondLine, 3) "`n"
        }
        else
        {
            result .= "* | ��� | " pluginName " | ������  ������" SubStr(secondLine, 3) "`n"
        }
    }

    DisplayResult(AlignText(result))
    TurnOnResultFilter()
    SetCommandFilter("RemovePlugin")
return

CleanupPlugin:
    result := ""
    FileRead, currentPlugins, %A_ScriptDir%\Runz\Core\Plugins.ahk
    Loop, Parse, currentPlugins, `n, `r
    {
        SplitPath, A_LoopField , , , , pluginName,
        if (g_Conf.GetValue("Plugins", pluginName) == 0)
        {
            result .= pluginName " ����ѱ������´����� RunZ ����������`n"
            StringReplace, currentPlugins, currentPlugins
                , #include *i `%A_ScriptDir`%\Runz\Plugins\%pluginName%.ahk`r`n
        }
    }

    if (result != "")
    {
        DisplayResult(result)
        FileDelete, %A_ScriptDir%\Runz\Core\Plugins.ahk
        FileAppend, %currentPlugins%, %A_ScriptDir%\Runz\Core\Plugins.ahk
    }
    else
    {
        DisplayResult("�޿�������")
    }
return

CountNumber:
    result := "* | ���� | " StrSplit(Arg, " ").Length() " | �Կո�Ϊ�ָ���`n"
    if (SubStr(FullPipeArg, 0, -1) = "`n")
    {
        result .= "* | ���� | " StrSplit(FullPipeArg, "`n").Length()  - 1 " | �Ի���Ϊ�ָ���`n"
    }
    else
    {
        result .= "* | ���� | " StrSplit(FullPipeArg, "`n").Length() " | �Ի���Ϊ�ָ���`n"
    }

    DisplayResult(AlignText(result))
return

Open:
    runtar:= StrSplit(FullPipeArg, "`r")[1]
    Run, "%runtar%"
return
