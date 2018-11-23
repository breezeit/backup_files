#NoEnv
#SingleInstance, Force
#NoTrayIcon
#MaxHotkeysPerInterval 200
SendMode Input

;FileEncoding, utf-8
;SetWorkingDir %A_ScriptDir%

; �Զ����ɵĴ������ļ��б�
global g_SearchFileList := A_ScriptDir . "\Settings\Runz\SearchFileList.txt"
; �û����õĴ������ļ��б�
global g_UserFileList := A_ScriptDir . "\Settings\Runz\UserFileList.txt"
; �����ļ�
global g_ConfFile := A_ScriptDir . "\Settings\Runz\RunZ.ini"
; �Զ�д��������ļ�
global g_AutoConfFile := A_ScriptDir . "\Settings\Runz\RunZ.auto.ini"

if !FileExist(g_ConfFile)
{
    FileCopy, %g_ConfFile%.help.txt, %g_ConfFile%
}

if (FileExist(g_AutoConfFile ".EasyIni.bak"))
{
    MsgBox, % "�����ϴ�д�����õı����ļ���`n"
        . g_AutoConfFile . ".EasyIni.bak"
        . "`nȷ������ָ����������ֶ�����ļ������ټ���"
    FileMove, % g_AutoConfFile ".EasyIni.bak", % g_AutoConfFile
}
else if (!FileExist(g_AutoConfFile))
{
    FileAppend, % "; ���ļ��� RunZ �Զ�д�룬�����ֶ��޸����ȹر� RunZ ��`n`n"
        . "[Auto]`n[Rank]`n[History]" , % g_AutoConfFile
}

global g_Conf := class_EasyIni(g_ConfFile)
global g_AutoConf := class_EasyIni(g_AutoConfFile)

if (g_Conf.Gui.Skin != "")
{
    global g_SkinConf := class_EasyIni(A_ScriptDir "\Settings\Runz\Skins\" g_Conf.Gui.Skin ".ini").Gui
}
else
{
    global g_SkinConf := g_Conf.Gui
}

; ��ǰ��������Ĳ��������飬Ϊ�˷���û����� g_ ǰ׺
global Arg
; �������ùܵ������������������У������б�Ҫ�Ĳ��ʹ��
global FullPipeArg
; ������ RunZ.ahk ���Ӵ������򰴼��󶨻�������
global g_WindowName := "RunZ    "
; ��������
global g_Commands
; �������޽��ʱʹ�õ�����
global g_FallbackCommands
; �༭��ǰ����
global g_CurrentInput
; ��ǰƥ�䵽�ĵ�һ������
global g_CurrentCommand
; ��ǰƥ�䵽����������
global g_CurrentCommandList
; �Ƿ����� TCMatch
global g_EnableTCMatch = TCMatchOn(g_Conf.Config.TCMatchPath)
; �б��һ�е�����ĸ������
global g_FirstChar := Asc(g_SkinConf.FirstChar)
; ���б�����ʾ������
global g_DisplayRows := g_SkinConf.DisplayRows
; ����ʹ������ʾ��
global g_UseDisplay
; ��ʷ����
global g_HistoryCommands
; ��������ʱ��ʱ���ã�������Ϊ�����˳��޷�������Ҫ��Ȩ�����
global g_DisableAutoExit
; ��ǰ���������������������
global g_CurrentLine
; ʹ�ñ��õ�����
global g_UseFallbackCommands
; ������������ʵʱ����
global g_UseResultFilter
; �������ı��ʵʱ����ִ������
global g_UseRealtimeExec
; �ų�������
global g_ExcludedCommands
; �����������ļ��ʱ��
global g_ExecInterval
; �ϴμ�����еĹ��ܱ�ǩ
global g_LastExecLabel
; �������ùܵ��Ĳ�������������У�
global g_PipeArg
; ������ȫ�����õ�
global g_CommandFilter
; ����б�
global g_Plugins := Object()

global g_InputArea := "Edit1"
global g_DisplayArea := "Edit3"
global g_CommandArea := "Edit4"

FileRead, currentPlugins, %A_ScriptDir%\Runz\Plugins.ahk
needRestart := false

Loop, Files, %A_ScriptDir%\Runz\Plugins\*.ahk
{
    FileReadLine, firstLine, %A_LoopFileLongPath%, 1
    if (StrSplit(firstLine, ":")[1]!="; RunZ")
    {
      continue
    }
    pluginName := StrSplit(firstLine, ":")[2]
    if (!(g_Conf.GetValue("Plugins", pluginName) == 0))
    {
        if (RegExMatch(currentPlugins, "m)" pluginName ".ahk$"))
        {
            g_Plugins.Push(pluginName)
        }
        else
        {
            FileAppend, #include *i `%A_ScriptDir`%\Runz\Plugins\%pluginName%.ahk`n
                , %A_ScriptDir%\Runz\Plugins.ahk
            needRestart := true
        }
    }
}

if (needRestart)
{
    Reload
}

if (g_SkinConf.ShowTrayIcon)
{
    Menu, Tray, Icon
    Menu, Tray, NoStandard
    if (g_Conf.Config.RunInBackground)
    {
        Menu, Tray, Add, ��ʾ &S, ActivateRunZ
        Menu, Tray, Default, ��ʾ &S
        Menu, Tray, Click, 1
    }
    Menu, Tray, Add, ���� &C, EditConfig
    Menu, Tray, Add, ���� &H, KeyHelp
    Menu, Tray, Add,
    Menu, Tray, Add, ���� &R, RestartRunZ
    Menu, Tray, Add, �˳� &X, ExitRunZ
    Menu, Tray, Icon, %A_ScriptDir%\pic\RunZ.ico
}

if (FileExist(g_SearchFileList))
{
    LoadFiles()
}
else
{
    GoSub, ReindexFiles
}

Gui, Color, % g_SkinConf.BackgroundColor, % g_SkinConf.EditColor

if (FileExist(A_ScriptDir "\Settings\Runz\Skins\" g_SkinConf.BackgroundPicture))
{
    Gui, Add, Picture, x0 y0, % A_ScriptDir "\Settings\Runz\Skins\" g_SkinConf.BackgroundPicture
}

border := 10
if (g_SkinConf.BorderSize >= 0)
{
    border := g_SkinConf.BorderSize
}
windowHeight := border * 3 + g_SkinConf.EditHeight + g_SkinConf.DisplayAreaHeight

Gui, Font, % "C" g_SkinConf.FontColor " S" g_SkinConf.FontSize, % g_SkinConf.FontName
Gui, Add, Edit, % "x" border " y" border " gProcessInputCommand -WantReturn"
        . " w" g_SkinConf.WidgetWidth " h" g_SkinConf.EditHeight,
Gui, Add, Edit, y+0 w0 h0 ReadOnly -WantReturn
Gui, Add, Button, y+0 w0 h0 Default gRunCurrentCommand
Gui, Add, Edit, % "y+" border " -VScroll ReadOnly -WantReturn"
        . " w" g_SkinConf.WidgetWidth " h" g_SkinConf.DisplayAreaHeight
        , % AlignText(SearchCommand("", true))

if (g_SkinConf.ShowCurrentCommand)
{
    Gui, Add, Edit, % "y+" border " ReadOnly"
        . " w" g_SkinConf.WidgetWidth " h" g_SkinConf.EditHeight,
    windowHeight += border + g_SkinConf.EditHeight
}

if (g_SkinConf.ShowInputBoxOnlyIfEmpty)
{
    windowHeight := border * 2 + g_SkinConf.EditHeight
    SysGet, screenHeight, 79
    windowY := "y" (screenHeight - border * 2 - g_SkinConf.EditHeight - g_SkinConf.DisplayAreaHeight) / 2
}

if (g_SkinConf.HideTitle)
{
    Gui -Caption
}

cmdlineArg = %1%
if (cmdlineArg == "--hide") or !g_Conf.Config.firstrunshowwindow
{
    hideWindow := " Hide"
}

if  (cmdlineArg == "--show")
hideWindow := ""

Gui, Show, % windowY " w" border * 2 + g_SkinConf.WidgetWidth
    . " h" windowHeight hideWindow, % g_WindowName

if (g_SkinConf.RoundCorner > 0)
{
    WinSet, Region, % "0-0 w" border * 2 + g_SkinConf.WidgetWidth " h" windowHeight
        . " r" g_SkinConf.RoundCorner "-" g_SkinConf.RoundCorner, % g_WindowName
}

if (g_Conf.Config.SwitchToEngIME)
{
    IME_SwitchToEng()
}

if (g_Conf.Config.WindowAlwaysOnTop)
{
    WinSet, AlwaysOnTop, On, A
}

if (g_Conf.Config.ExitIfInactivate)
{
    OnMessage(0x06, "WM_ACTIVATE")
}

OnMessage(0x0200, "WM_MOUSEMOVE")

Hotkey, IfWinActive, % g_WindowName

Hotkey, Esc, EscFunction
Hotkey, !F4, ExitRunZ

Hotkey, Tab, TabFunction
Hotkey, F1, Help
Hotkey, +F1, KeyHelp
Hotkey, F2, EditConfig
Hotkey, F3, EditAutoConfig
Hotkey, ^q, RestartRunZ
Hotkey, ^l, ClearInput
Hotkey, ^d, OpenCurrentFileDir
Hotkey, ^x, DeleteCurrentFile
Hotkey, ^s, ShowCurrentFile
Hotkey, ^r, ReindexFiles
Hotkey, ^h, DisplayHistoryCommands
Hotkey, ^n, IncreaseRank
Hotkey, ^=, IncreaseRank
Hotkey, ^p, DecreaseRank
Hotkey, ^-, DecreaseRank
Hotkey, ^f, NextPage
Hotkey, ^b, PrevPage
Hotkey, ^i, HomeKey
Hotkey, ^o, EndKey
Hotkey, ^j, NextCommand
Hotkey, ^k, PrevCommand
Hotkey, Down, NextCommand
Hotkey, Up, PrevCommand
Hotkey, ~LButton, ClickFunction
;Hotkey, RButton, OpenContextMenu
Hotkey, AppsKey, OpenContextMenu
Hotkey, ^Enter, SaveResultAsArg

; ʣ�ఴ�� Ctrl + e g m t w

Loop, % g_DisplayRows
{
    key := Chr(g_FirstChar + A_Index - 1)
    ; lalt +
    Hotkey, !%key%, RunSelectedCommand
    ; tab +
    Hotkey, ~%key%, RunSelectedCommand
    ; shift +
    Hotkey, ~+%key%, GotoCommand
}

for key, label in g_Conf.Hotkey
{
    if (label != "Default")
    {
        Hotkey, %key%, %label%
    }
    else
    {
        Hotkey, %key%, Off
    }
}

Hotkey, IfWinActive

for key, label in g_Conf.GlobalHotkey
{
    if (label != "Default")
    {
        Hotkey, %key%, %label%
    }
    else
    {
        Hotkey, %key%, Off
    }
}

if (g_Conf.Config.SaveInputText && g_AutoConf.Auto.InputText != "")
{
    Send, % g_AutoConf.Auto.InputText
}

if (g_Conf.Config.SaveHistory)
{
    g_HistoryCommands := Object()
    LoadHistoryCommands()
}

UpdateSendTo(g_Conf.Config.CreateSendToLnk, false)
UpdateStartupLnk(g_Conf.Config.CreateStartupLnk, false)

SetTimer, WatchUserFileList, 3000
return

Default:
return

RestartRunZ:
    SaveAutoConf()
    Reload
return

Test:
    MsgBox, ����
return

HomeKey:
    Send, {home}
return

EndKey:
    Send, {End}
return

NextPage:
    if (!g_UseDisplay)
    {
        return
    }

    ControlFocus, %g_DisplayArea%
    Send, {pgdn}
    ControlFocus, %g_InputArea%
return

PrevPage:
    if (!g_UseDisplay)
    {
        return
    }

    ControlFocus, %g_DisplayArea%
    Send, {pgup}
    ControlFocus, %g_InputArea%
return

ActivateRunZ:
    Gui, Show, , % g_WindowName

    if (g_Conf.Config.SwitchToEngIME)
    {
        IME_SwitchToEng()
    }

    Loop, 5
    {
        Sleep, 50

        if (WinActive(g_WindowName))
        {
            ControlFocus, %g_InputArea%
            Send, ^a
            break
        }

        Gui, Show, , % g_WindowName
    }
return

ToggleWindow:
    if (WinActive(g_WindowName))
    {
        if (!g_Conf.Config.KeepInputText)
        {
            ControlSetText, %g_InputArea%, , %g_WindowName%
        }

        Gui, Hide
    }
    else
    {
        GoSub, ActivateRunZ
    }
return

getMouseCurrentLine()
{
    MouseGetPos, , mouseY, , classnn,
    if (classnn != g_DisplayArea)
    {
        return -1
    }

    ControlGetPos, , y, , h, %g_DisplayArea%
    lineHeight := h / g_DisplayRows
    index := Ceil((mouseY - y) / lineHeight)
    return index
}

ClickFunction:
    if (g_UseDisplay)
    {
        return
    }

    index := getMouseCurrentLine()
    if (index < 0)
    {
        return
    }

    if (g_CurrentCommandList[index] != "")
    {
        ChangeCommand(index - 1, true)
    }

    ControlFocus, %g_InputArea%
    Send, {end}

    if (g_Conf.Config.ClickToRun)
    {
        RunCommand(g_CurrentCommand)
    }
return

GuiContextMenu:
OpenContextMenu:
    if (!g_UseDisplay)
    {
        currentCommandText := ""
        if (!g_CurrentLine > 0)
        {
            currentCommandText .= Chr(g_FirstChar)
        }
        else
        {
            currentCommandText .= Chr(g_FirstChar + g_CurrentLine - 1)
        }
Menu, ContextMenu, Add
    Menu, ContextMenu, DeleteAll
        Menu, ContextMenu, Add, %currentCommandText% > ���� &Z, RunCurrentCommand
        Menu, ContextMenu, Add
    }

    Menu, ContextMenu, Add, �༭���� &E, EditConfig
    Menu, ContextMenu, Add, �ؽ����� &S, ReindexFiles
    Menu, ContextMenu, Add, ��ʾ��ʷ &H, DisplayHistoryCommands
    Menu, ContextMenu, Add, ��ӿ�ݷ�ʽ�������ͷ��͵� &C, ChangePath
    Menu, ContextMenu, Add
    Menu, ContextMenu, Add, ��ʾ���� &A, Help
    Menu, ContextMenu, Add, �������� &R, RestartRunZ
    Menu, ContextMenu, Add, �˳����� &X, ExitRunZ
    Menu, ContextMenu, Show
    Menu, ContextMenu, DeleteAll
return

TabFunction:
    ControlGetFocus, ctrl,
    if (ctrl == g_InputArea)
    {
        ; ��λ��һ�����ر༭��
        ControlFocus, Edit2
    }
    else
    {
        ControlFocus, %g_InputArea%
    }
return

EscFunction:
    ToolTip
    if (g_Conf.Config.ClearInputWithEsc && g_CurrentInput != "")
    {
        GoSub, ClearInput
    }
    else
    {
        if (!g_Conf.Config.KeepInputText)
        {
            ControlSetText, %g_InputArea%, , %g_WindowName%
        }
        GoSub, HideOrExit
    }
return

HideOrExit:
    ; ����Ǻ�̨����ģʽ��ֻ�رմ��ڣ����˳�����
    if (g_Conf.Config.RunInBackground)
    {
        Gui, Hide
    }
    else
    {
        GoSub, ExitRunZ
    }
return

NextCommand:
    if (g_UseDisplay)
    {
        ControlFocus, %g_DisplayArea%
        Send {down}
        return
    }
    ChangeCommand(1)
return

PrevCommand:
    if (g_UseDisplay)
    {
        ControlFocus, %g_DisplayArea%
        Send {up}
        return
    }
    ChangeCommand(-1)
return

GotoCommand:
    ControlGetFocus, ctrl,
    if (ctrl == g_InputArea)
    {
        return
    }

    index := Asc(SubStr(A_ThisHotkey, 0, 1)) - g_FirstChar + 1

    if (g_CurrentCommandList[index] != "")
    {
        ChangeCommand(index - 1, true)
    }
return

ChangeCommand(step, resetCurrentLine = false)
{
    ControlGetText, g_CurrentInput, %g_InputArea%

    if (resetCurrentLine
        || (SubStr(g_CurrentInput, 1, 1) != "@" && SubStr(g_CurrentInput, 1, 2) != "|@"))
    {
        g_CurrentLine := 1
    }

    row := g_CurrentCommandList.Length()
    if (row > g_DisplayRows)
    {
        row := g_DisplayRows
    }

    g_CurrentLine := Mod(g_CurrentLine + step, row)
    if (g_CurrentLine == 0)
    {
        g_CurrentLine := row
    }

    ; ���õ�ǰ����
    g_CurrentCommand := g_CurrentCommandList[g_CurrentLine]

    ; �޸����������
    currentChar := Chr(g_FirstChar + g_CurrentLine - 1)
    if (SubStr(g_CurrentInput, 1, 1) == "|")
    {
        newInput := "|@" currentChar " "
    }
    else
    {
        newInput := "@" currentChar " "
    }

    if (g_UseFallbackCommands)
    {
        if (SubStr(g_CurrentInput, 1, 1) == "@")
        {
            newInput .= SubStr(g_CurrentInput, 4)
        }
        else
        {
            newInput .= g_CurrentInput
        }
    }

    ControlGetText, result, %g_DisplayArea%
    result := StrReplace(result, ">| ", " | ")
    if (currentChar == Chr(g_FirstChar))
    {
        result := currentChar ">" SubStr(result, 3)
    }
    else
    {
        result := StrReplace(result, "`r`n" currentChar " | ", "`r`n" currentChar ">| ")
    }

    DisplaySearchResult(result)

    ControlSetText, %g_InputArea%, %newInput%, %g_WindowName%
    Send, {end}
}

GuiClose()
{
    if (!g_Conf.Config.RunInBackground)
    {
        GoSub, ExitRunZ
    }
}

SaveAutoConf()
{
    if (g_Conf.Config.SaveInputText)
    {
        g_AutoConf.DeleteKey("Auto", "InputText")
        g_AutoConf.AddKey("Auto", "InputText", g_CurrentInput)
    }

    if (g_Conf.Config.SaveHistory)
    {
        g_AutoConf.DeleteSection("History")
        g_AutoConf.AddSection("History")

        for index, element in g_HistoryCommands
        {
            if (element != "")
            {
                g_AutoConf.AddKey("History", index, element)
            }
        }
    }

    Loop
    {
        g_AutoConf.Save()

        if (!FileExist(g_AutoConfFile))
        {
            MsgBox, �����ļ� %g_AutoConfFile% д���ʧ��������̲���ȷ��������
        }
        else
        {
            break
        }
    }
}

ExitRunZ:
    SaveAutoConf()
    ExitApp
return

GenerateSearchFileList()
{
    FileDelete, %g_SearchFileList%

    searchFileType := g_Conf.Config.SearchFileType

    for dirIndex, dir in StrSplit(g_Conf.Config.SearchFileDir, " | ")
    {
        if (InStr(dir, "A_") == 1)
        {
            searchPath := %dir%
        }
        else
        {
            searchPath := dir
        }

        for extIndex, ext in StrSplit(searchFileType, " | ")
        {
            Loop, Files, %searchPath%\%ext%, R
            {
                if (g_Conf.Config.SearchFileExclude != ""
                        && RegExMatch(A_LoopFileLongPath, g_Conf.Config.SearchFileExclude))
                {
                    continue
                }
                FileAppend, file | %A_LoopFileLongPath%`n, %g_SearchFileList%,
            }
        }
    }
}

ReindexFiles:
    if (WinActive(g_WindowName))
    {
        ToolTip, �����ؽ����������Ժ�...
    }

    GenerateSearchFileList()

    GoSub, CleanupRank

    if (WinActive(g_WindowName))
    {
        CF_ToolTip("�ؽ��������",1000)
    }
return

EditConfig:
    if (g_Conf.Config.Editor != "")
    {
        Run, % g_Conf.Config.Editor " """ g_ConfFile """"
    }
    else
    {
        Run, % g_ConfFile
    }
return

EditAutoConfig:
    if (g_Conf.Config.Editor != "")
    {
        Run, % g_Conf.Config.Editor " """ g_AutoConfFile """"
    }
    else
    {
        Run, % g_AutoConfFile
    }
return


ProcessInputCommand:
    ControlGetText, g_CurrentInput, %g_InputArea%
    ; https://github.com/goreliu/runz/issues/40
    ; ����������������������Ļ�������������ܲ�����
    ;GoSub, ProcessInputCommandCallBack
    ;return

    ; ���ʹ���첽�ķ�ʽ��TurnOnResultFilter �������⣬����һ��
    if (SubStr(g_CurrentInput, 0, 1) == " ")
    {
        GoSub, ProcessInputCommandCallBack
        return
    }

    ; Ϊ�˱�������ʱ��������²��ٵ��� ProcessInputCommand
    ; ������������Ƿ�����������
    SetTimer, ProcessInputCommandCallBack, 0
return

ProcessInputCommandCallBack:
    SetTimer, ProcessInputCommandCallBack, Off

    if (g_SkinConf.ShowInputBoxOnlyIfEmpty)
    {
        if (g_CurrentInput != "")
        {
            if (g_SkinConf.ShowCurrentCommand)
            {
                windowHeight := g_SkinConf.BorderSize * 4
                    + g_SkinConf.EditHeight * 2 + g_SkinConf.DisplayAreaHeight
            }
            else
            {
                windowHeight := g_SkinConf.BorderSize * 3
                    + g_SkinConf.EditHeight + g_SkinConf.DisplayAreaHeight
            }
            WinMove, %g_WindowName%, , , , , %windowHeight%
        }
        else
        {
            windowHeight := g_SkinConf.BorderSize * 2 + g_SkinConf.EditHeight
            WinMove, %g_WindowName%, , , , , %windowHeight%
        }

        if (g_SkinConf.RoundCorner > 0)
        {
            WinSet, Region, % "0-0 w" border * 2 + g_SkinConf.WidgetWidth " h" windowHeight
                . " r" g_SkinConf.RoundCorner "-" g_SkinConf.RoundCorner, % g_WindowName
        }
    }

    SearchCommand(g_CurrentInput)
return

SearchCommand(command = "", firstRun = false)
{
    g_UseDisplay := false
    g_ExecInterval := -1
    result := ""
    ; ��ȥ��ʹ��
    fullResult := ""
    static resultToFilter := ""
    commandPrefix := SubStr(command, 1, 1)

    if (commandPrefix == ";" || commandPrefix == ":")
    {
        g_UseResultFilter := false
        g_UseRealtimeExec := false
        resultToFilter := ""
        g_PipeArg := ""

        if (commandPrefix == ";")
        {
            g_CurrentCommand := g_FallbackCommands[1]
        }
        else if (commandPrefix == ":")
        {
            g_CurrentCommand := g_FallbackCommands[2]
        }

        g_CurrentCommandList := Object()
        g_CurrentCommandList.Push(g_CurrentCommand)
        result .= Chr(g_FirstChar) ">| "
            . StrReplace(g_CurrentCommand, "function | ", "���� | ")
        DisplaySearchResult(result)
        return result
    }
    else if (commandPrefix == "|" && Arg != "")
    {
        ; ��¼�ܵ�����
        if (g_PipeArg == "")
        {
            g_PipeArg := Arg
        }
        ; ȥ�� |��Ȼ�󰴳�����������
        command := SubStr(command, 2)
        if (SubStr(command, 1, 1) == "@")
        {
            command := SubStr(command, 1, 4)
            return
        }
    }
    else if (InStr(command, " ") && g_CurrentCommand != "")
    {
        g_PipeArg := ""

        ; ��������ո�ʱ�����������

        if (g_UseResultFilter)
        {
            if (resultToFilter == "")
            {
                ControlGetText, resultToFilter, %g_DisplayArea%
            }

            ; ȡ���ո��ߵĲ���
            needle := SubStr(g_CurrentInput, InStr(g_CurrentInput, " ") + 1)
            DisplayResult(FilterResult(resultToFilter, needle))
        }
        else if (g_UseRealtimeExec)
        {
            RunCommand(g_CurrentCommand)
            resultToFilter := ""
        }
        else
        {
            resultToFilter := ""
        }

        return
    }
    else if (commandPrefix == "@")
    {
        g_UseResultFilter := false
        g_UseRealtimeExec := false
        resultToFilter := ""

        ; ���������������ֱ���˳�
        return
    }

    g_UseResultFilter := false
    g_UseRealtimeExec := false
    resultToFilter := ""

    if (commandPrefix != "|")
    {
        g_PipeArg := ""
    }

    g_CurrentCommandList := Object()

    order := g_FirstChar

    for index, element in g_Commands
    {
        if (InStr(fullResult, element "`n") || inStr(g_ExcludedCommands, element "`n"))
        {
            continue
        }

        splitedElement := StrSplit(element, " | ")

        if (splitedElement[1] == "file")
        {
            SplitPath, % splitedElement[2], fileName, fileDir, , fileNameNoExt

            ; ֻ������չʾ������չ�����ļ���
            elementToSearch := fileNameNoExt
            if (g_Conf.Config.ShowFileExt)
            {
                elementToShow := "file | " . fileName " | " splitedElement[3]
            }
            else
            {
                elementToShow := "file | " . fileNameNoExt " | " splitedElement[3]
            }


            if (splitedElement.Length() >= 3)
            {
                elementToSearch .= " " . splitedElement[3]
            }

            if (g_Conf.Config.SearchFullPath)
            {
                ; TCMatch ������·��ʱֻ�����ļ�����ǿ�н� \ ת�ɿո�
                elementToSearch := StrReplace(fileDir, "\", " ") . " " . elementToSearch
            }
        }
        else
        {
            elementToShow := splitedElement[1] " | " splitedElement[2]
            elementToSearch := StrReplace(splitedElement[2], "/", " ")
            elementToSearch := StrReplace(elementToSearch, "\", " ")

            if (splitedElement.Length() >= 3)
            {
                elementToShow .= " | " splitedElement[3]
                elementToSearch .= " " . splitedElement[3]
            }
        }

        if (command == "" || MatchCommand(elementToSearch, command))
        {
            fullResult .= element "`n"
            g_CurrentCommandList.Push(element)

            if (order == g_FirstChar)
            {
                g_CurrentCommand := element
                result .= Chr(order++) . ">| " . elementToShow
            }
            else
            {
                result .= "`n" Chr(order++) . " | " . elementToShow
            }

            if (order - g_FirstChar >= g_DisplayRows)
            {
                break
            }
            ; ��һ������ֻ���� function ����
            if (firstRun && (order - g_FirstChar >= g_DisplayRows - 4))
            {
                result .= "`n`n���� " g_Commands.Length() " �������"
                result .= "`n`n�������� �������س� ִ�е�ǰ���Alt + ��ĸ ִ�У�F1 ������Esc �رա�"

                break
            }
        }
    }

    if (result == "")
    {
        if (IsLabel("Calc") && Eval(g_CurrentInput) != 0)
        {
            DisplayResult(Eval(g_CurrentInput))
            return
        }

        g_UseFallbackCommands := true
        g_CurrentCommand := g_FallbackCommands[1]
        g_CurrentCommandList := g_FallbackCommands

        for index, element in g_FallbackCommands
        {
            if (index == 1)
            {
                result .= Chr(g_FirstChar - 1 + index++) . ">| " element
            }
            else
            {
                result .= "`n"
                result .= Chr(g_FirstChar - 1 + index++) . " | " element
            }
        }
    }
    else
    {
        g_UseFallbackCommands := false
    }

    if (g_SkinConf.HideCol2)
    {
        result := StrReplace(result, "file | ")
        result := StrReplace(result, "function | ")
        result := StrReplace(result, "cmd | ")
        result := StrReplace(result, "url | ")
    }
    else
    {
        result := StrReplace(result, "file | ", "�ļ� | ")
        result := StrReplace(result, "function | ", "���� | ")
        result := StrReplace(result, "cmd | ", "���� | ")
        result := StrReplace(result, "url | ", "��ַ | ")
    }

    DisplaySearchResult(result)
    return result
}

DisplaySearchResult(result)
{
    DisplayControlText(result)

    if (g_CurrentCommandList.Length() == 1 && g_Conf.Config.RunIfOnlyOne)
    {
        RunCommand(g_CurrentCommand)
    }

    if (g_SkinConf.ShowCurrentCommand)
    {
        commandToShow := SubStr(g_CurrentCommand, InStr(g_CurrentCommand, " | ") + 3)
        ControlSetText, %g_CommandArea%, %commandToShow%, %g_WindowName%
    }
}

FilterResult(text, needle)
{
    result := ""
    Loop, Parse, text, `n, `r
    {
        if (!InStr(A_LoopField, " | ") && MatchResult(A_LoopField, needle))
        {
            result .= A_LoopField "`n"
        }
        else if (MatchResult(StrReplace(SubStr(A_LoopField, 5), "\", " "), needle))
        {
            result .= A_LoopField "`n"
        }
    }

    return result
}

TurnOnResultFilter()
{
    if (!g_UseResultFilter)
    {
        g_UseResultFilter := true

        if (!InStr(g_CurrentInput, " "))
        {
            ControlFocus, %g_InputArea%
            Send, {space}
        }
    }
}

TurnOnRealtimeExec()
{
    if (!g_UseRealtimeExec)
    {
        g_UseRealtimeExec := true

        if (!InStr(g_CurrentInput, " "))
        {
            ControlFocus, %g_InputArea%
            Send, {space}
        }
    }
}

SetExecInterval(second)
{
    ; g_ExecInterval Ϊ 0 ʱ����ʾ���Խ���������״̬
    ; g_ExecInterval Ϊ -1 ʱ����ʾ״̬�Ա����ƣ���Ҫ�˳�
    if (g_ExecInterval >= 0)
    {
        g_ExecInterval := second * 1000
        return true
    }
    else
    {
        SetTimer, %g_LastExecLabel%, Off
        return false
    }
}

ClearInput:
    ClearInput()
return

; ������õĺ���
ClearInput()
{
    ControlSetText, %g_InputArea%, , %g_WindowName%
    ControlFocus, %g_InputArea%
}

RunCurrentCommand:
    RunCommand(g_CurrentCommand)
return

ParseArg:
    if (g_PipeArg != "")
    {
        Arg := g_PipeArg
        return
    }

    commandPrefix := SubStr(g_CurrentInput, 1, 1)

    ; �ֺŻ���ð�ŵ������ֱ��ȡ����Ϊ����
    if (commandPrefix == ";" || commandPrefix == ":")
    {
        Arg := SubStr(g_CurrentInput, 2)
        return
    }
    else if (commandPrefix == "@")
    {
        ; ���������˳�������
        Arg := SubStr(g_CurrentInput, 4)
        return
    }

    ; �ÿո����жϲ���
    if (InStr(g_CurrentInput, " ") && !g_UseFallbackCommands)
    {
        Arg := SubStr(g_CurrentInput, InStr(g_CurrentInput, " ") + 1)
    }
    else if (g_UseFallbackCommands)
    {
        Arg := g_CurrentInput
    }
    else
    {
        Arg := ""
    }
return

MatchCommand(Haystack, Needle)
{
    if (g_EnableTCMatch)
    {
        return TCMatch(Haystack, Needle)
    }

    return InStr(Haystack, Needle)
}

MatchResult(Haystack, Needle)
{
    if (g_EnableTCMatch)
    {
        return TCMatch(Haystack, Needle)
    }

    return InStr(Haystack, Needle)
}

RunCommand(originCmd)
{
    GoSub, ParseArg

    g_UseDisplay := false
    g_DisableAutoExit := true
    g_ExecInterval := 0

    splitedOriginCmd := StrSplit(originCmd, " | ")
    cmd := splitedOriginCmd[2]

    if (splitedOriginCmd[1] == "file")
    {
        if (InStr(cmd, ".lnk"))
        {
            ; ���� 32 λ ahk ���в���ĳЩ 64 λϵͳ .lnk ������
            FileGetShortcut, %cmd%, filePath
            if (!FileExist(filePath))
            {
                filePath := StrReplace(filePath, "C:\Program Files (x86)", "C:\Program Files")
                if (FileExist(filePath))
                {
                    cmd := filePath
                }
            }
        }

        SplitPath, cmd, , fileDir, ,

        if (Arg == "")
        {
            Run, %cmd%, %fileDir%, UseErrorLevel
            if UseErrorLevel
               Run, "%cmd%", "%fileDir%"
        }
        else
        {
            Run, %cmd% %Arg%, %fileDir%,UseErrorLevel
            if UseErrorLevel
               Run, "%cmd%" "%Arg%", "%fileDir%"
        }
    }
    else if (splitedOriginCmd[1] == "function")
    {
        ; ���ĸ������ǲ���
        if (splitedOriginCmd.Length() >= 4)
        {
            Arg := splitedOriginCmd[4]
        }

        if (IsLabel(cmd))
        {
            GoSub, %cmd%
        }
    }
    else if (splitedOriginCmd[1] == "cmd")
    {
        RunWithCmd(cmd)
    }
    else if (splitedOriginCmd[1] == "url")
    {
        url := splitedOriginCmd[2]
        if (!Instr(url, "http"))
        {
            url := "http://" . url
        }

        Run, %url%
    }

    if (g_Conf.Config.SaveHistory && cmd != "DisplayHistoryCommands")
    {
        if (splitedOriginCmd.Length() == 3 && Arg != "")
        {
            g_HistoryCommands.InsertAt(1, originCmd " | " Arg)
        }
        else if (originCmd != "")
        {
            g_HistoryCommands.InsertAt(1, originCmd)
        }

        if (g_HistoryCommands.Length() > g_Conf.Config.HistorySize)
        {
            g_HistoryCommands.Pop()
        }
    }

    if (g_Conf.Config.AutoRank)
    {
        ChangeRank(originCmd)
    }

    g_DisableAutoExit := false

    if (g_Conf.Config.RunOnce && !g_UseDisplay)
    {
        if (!g_Conf.Config.KeepInputText)
        {
            GoSub, ClearInput
        }
        GoSub, HideOrExit
    }

    if (g_ExecInterval > 0 && splitedOriginCmd[1] == "function")
    {
        SetTimer, %cmd%, %g_ExecInterval%
        g_LastExecLabel := cmd
    }

    g_PipeArg := ""
    FullPipeArg := ""
}

ChangeRank(cmd, show = false, inc := 1)
{
    splitedCmd := StrSplit(cmd, " | ")

    if (splitedCmd.Length() >= 4 && splitedCmd[1] == "function")
    {
        ; ȥ������
        cmd := splitedCmd[1]  " | " splitedCmd[2] " | " splitedCmd[3]
    }

    cmdRank := g_AutoConf.GetValue("Rank", cmd)
    if cmdRank is integer
    {
        g_AutoConf.DeleteKey("Rank", cmd)
        cmdRank += inc
    }
    else
    {
        cmdRank := inc
    }

    if (cmdRank != 0 && cmd != "")
    {
        ; ������������������ó� -1��Ȼ������
        if (cmdRank < 0)
        {
            cmdRank := -1
            g_ExcludedCommands .= cmd "`n"
        }

        g_AutoConf.AddKey("Rank", cmd, cmdRank)
    }
    else
    {
        cmdRank := 0
    }

    if (show)
    {
        CF_ToolTip("����" cmd "��Ȩ�ص�" cmdRank,1000)
    }
}

; �ȽϺ�ʱ����Ҫʱ��ʹ�ã�Ҳ�����ֶ��༭ RunZ.auto.ini
CleanupRank:
    ; �Ȱ� g_Commands ��� Rank ��Ϣ���
    LoadFiles(false)

    for command, rank in g_AutoConf.Rank
    {
        cleanup := true
        for index, element in g_Commands
        {
            if (InStr(element, command) == 1)
            {
                cleanup := false
                break
            }
        }
        if (cleanup)
        {
            g_AutoConf.DeleteKey("Rank", command)
        }
    }

    Loop
    {
        g_AutoConf.Save()

        if (!FileExist(g_AutoConfFile))
        {
            MsgBox, �����ļ� %g_AutoConfFile% д���ʧ��������̲���ȷ��������
        }
        else
        {
            break
        }
    }

    LoadFiles()
return

RunSelectedCommand:
    if (SubStr(A_ThisHotkey, 1, 1) == "~")
    {
        ControlGetFocus, ctrl,
        if (ctrl == g_InputArea)
        {
            return
        }
    }

    index := Asc(SubStr(A_ThisHotkey, 0, 1)) - g_FirstChar + 1

    RunCommand(g_CurrentCommandList[index])
return

IncreaseRank:
    if (g_CurrentCommand != "")
    {
        ChangeRank(g_CurrentCommand, true)
        LoadFiles()
    }
return

DecreaseRank:
    if (g_CurrentCommand != "")
    {
        ChangeRank(g_CurrentCommand, true, -1)
        LoadFiles()
    }
return

LoadFiles(loadRank := true)
{
    g_Commands := Object()
    g_FallbackCommands := Object()

    if (loadRank)
    {
        rankString := ""
        for command, rank in g_AutoConf.Rank
        {
            if (StrLen(command) > 0)
            {
                if (rank >= 1)
                {
                    rankString .= rank "`t" command "`n"
                }
                else
                {
                    g_ExcludedCommands .= command "`n"
                }
            }
        }

        if (rankString != "")
        {
            Sort, rankString, R N

            Loop, Parse, rankString, `n
            {
                if (A_LoopField == "")
                {
                    continue
                }

                g_Commands.Push(StrSplit(A_LoopField, "`t")[2])
            }
        }
    }


    for key, value in g_Conf.Command
    {
        if (value != "")
        {
            g_Commands.Push(key . " | " . value)
        }
        else
        {
            g_Commands.Push(key)
        }
    }

    for index, element in g_Plugins
    {
        if (IsLabel(element))
        {
            GoSub, %element%
        }
        else
        {
            MsgBox, δ�� %A_ScriptDir%\Runz\Plugins\%element%.ahk �з��� %element% ��ǩ�����޸ģ�
        }
    }

    g_FallbackCommands := Object()
    for key, value in g_Conf.FallbackCommand
    {
        if (IsLabel(StrSplit(key, " | ")[2]))
        {
            g_FallbackCommands.Push(key)
        }
    }

    if (g_FallbackCommands.Length() == 0)
    {
        g_FallbackCommands.Push("function | AhkRun | ʹ�� Ahk �� Run ����")
    }

    if (FileExist(A_ScriptDir "\Settings\Runz\UserFunctionsAuto.txt"))
    {
        userFunctionLabel := "UserFunctionsAuto"
        if (IsLabel(userFunctionLabel))
        {
            GoSub, %userFunctionLabel%
        }
        else
        {
            MsgBox, δ�� %A_ScriptDir%\Settings\Runz\UserFunctionsAuto.txt �з��� %userFunctionLabel% ��ǩ�����޸ģ�
        }
    }

    if (FileExist(g_UserFileList))
    {
        Loop, Read, %g_UserFileList%
        {
            g_Commands.Push(A_LoopReadLine)
        }
    }

    Loop, Read, %g_SearchFileList%
    {
        g_Commands.Push(A_LoopReadLine)
    }

    if (g_Conf.Config.LoadControlPanelFunctions)
    {
        Loop, Read, %A_ScriptDir%\Runz\txt\ControlPanelFunctions.txt
        {
            g_Commands.Push(A_LoopReadLine)
        }
    }
}

; ������ʾ���ƽ���
DisplayControlText(text)
{
    ControlSetText, %g_DisplayArea%, % AlignText(text), %g_WindowName%
}

; ������ʾ������
DisplayResult(result := "")
{
    textToDisplay := StrReplace(result, "`n", "`r`n")
    ControlSetText, %g_DisplayArea%, %textToDisplay%, %g_WindowName%
    g_UseDisplay := true
    result := ""
    textToDisplay := ""
}

LoadHistoryCommands()
{
    historySize := g_Conf.Config.HistorySize

    index := 0
    for key, value in g_AutoConf.History
    {
        if (StrLen(value) > 0)
        {
            g_HistoryCommands.Push(value)
            index++

            if (index == historySize)
            {
                return
            }
        }
    }
}

DisplayHistoryCommands:
    g_UseDisplay := false
    result := ""
    g_CurrentCommandList := Object()
    g_CurrentLine := 1

    for index, element in g_HistoryCommands
    {
        if (index == 1)
        {
            result .= Chr(g_FirstChar + index - 1) . ">| "
            g_CurrentCommand := element
        }
        else
        {
            result .= Chr(g_FirstChar + index - 1) . " | "
        }

        splitedElement := StrSplit(element, " | ")

        result .= splitedElement[1] " | " splitedElement[2]
            . " | " splitedElement[3] " #������ " splitedElement[4] "`n"

        g_CurrentCommandList.Push(element)
    }

    result := StrReplace(result, "file | ", "�ļ� | ")
    result := StrReplace(result, "function | ", "���� | ")
    result := StrReplace(result, "cmd | ", "���� | ")
    result := StrReplace(result, "url | ", "��ַ | ")

    DisplayControlText(result)
return

; ���������������� fallback�����ã�Ϊ�˼��ݲ��ı���ĸ������ĺ���
@(label, info, fallback = false, key = "")
{
    if (!IsLabel(label))
    {
        MsgBox, δ�ҵ� %label% ��ǩ������ %A_ScriptDir%\Settings\Runz\UserFunctions.ahk �ļ���ʽ��
        return
    }

    g_Commands.Push("function | " . label . " | " . info )

    if (key != "")
    {
        Hotkey, %key%, %label%
    }
}

RunAndGetOutput(command)
{
    tempFileName := "RunZ.stdout.log"
    FileDelete, %A_Temp%\%tempFileName%
    fullCommand = %ComSpec% /C "%command% > %tempFileName%"

    /*
    fullCommand = bash -c "%command% &> %tempFileName%"

    if (!FileExist("c:\msys64\usr\bin\bash.exe"))
    {
        fullCommand = %ComSpec% /C "%command% > %tempFileName%"
    }
    */

    RunWait, %fullCommand%, %A_Temp%, Hide
    FileRead, result, %A_Temp%\%tempFileName%
    FileDelete, %A_Temp%\%tempFileName%
    return result
}

RunWithCmd(command, onlyCmd = false)
{
    if (!onlyCmd && FileExist("c:\msys64\usr\bin\mintty.exe"))
    {
        Run, % "mintty -e sh -c '" command "; read'"
    }
    else
    {
        Run, % ComSpec " /C " command " & pause"
    }
}

OpenPath(filePath)
{
    if (!FileExist(filePath))
    {
        return
    }

    if (FileExist(g_Conf.Config.TCPath))
    {
        TCPath := g_Conf.Config.TCPath
        Run, %TCPath% /O /A /L="%filePath%"
    }
    else
    {
        SplitPath, filePath, , fileDir, ,
        Run, explorer "%fileDir%"
    }
}

GetAllFunctions()
{
    result := ""

    for index, element in g_Commands
    {
        if (InStr(element, "function | ") == 1 and !InStr(result, element "`n"))
        {
            result .= "* | " element "`n"
        }
    }

    result := StrReplace(result, "function | ", "���� | ")

    return AlignText(result)
}

OpenCurrentFileDir:
    filePath := StrSplit(g_CurrentCommand, " | ")[2]
    OpenPath(filePath)
return

DeleteCurrentFile:
    filePath := StrSplit(g_CurrentCommand, " | ")[2]

    if (!FileExist(filePath))
    {
        return
    }

    FileRecycle, % filePath
    GoSub, ReindexFiles
return

ShowCurrentFile:
    clipboard := StrSplit(g_CurrentCommand, " | ")[2]
    CF_ToolTip(clipboard, 1000)
return

WM_MOUSEMOVE(wParam, lParam)
{
    if (wparam = 1) ; LButton
    {
        PostMessage, 0xA1, 2, , , A ; WM_NCLBUTTONDOWN
    }

    if (!g_Conf.Config.ChangeCommandOnMouseMove)
    {
        return
    }

    MouseGetPos, , mouseY, , classnn,
    if (classnn != g_DisplayArea)
    {
        return -1
    }

    ControlGetPos, , y, , h, %g_DisplayArea%
    lineHeight := h / g_DisplayRows
    index := Ceil((mouseY - y) / lineHeight)

    if (g_CurrentCommandList[index] != "")
    {
        ChangeCommand(index - 1, true)
    }
}

WM_ACTIVATE(wParam, lParam)
{
    if (g_DisableAutoExit)
    {
        return
    }

    if (wParam >= 1) ; ���ڼ���
    {
        return
    }
    else if (wParam <= 0) ; ���ڷǼ���
    {
        ; �����п��ܵ�һ����ʾ������ʱ������ʧȥ����󲻹ر�
        ; ��ʱû�кõĽ��������������� SetTimer ���ã��ᵼ���ÿ�ݼ���ʾ������ʧ��

		if (!WinExist("RunZ.ahk"))
		{
			if (!g_Conf.Config.KeepInputText)
			{
				ControlSetText, %g_InputArea%, , %g_WindowName%
			}

			GoSub, HideOrExit
		}
    }
}

KeyHelpText()
{
    return AlignText(""
    . "* | ���� | Shift + F1 | ��ʾ�ö��İ�����ʾ`n"
    . "* | ���� | Alt + F4   | �˳��ö��İ�����ʾ`n"
    . "* | ���� | �س�       | ִ�е�ǰ����`n"
    . "* | ���� | Esc        | �رմ���`n"
    . "* | ���� | Alt +      | ��ÿ�������ַ�ִ��`n"
    . "* | ���� | Tab +      | �ٰ�ÿ�������ַ�ִ��`n"
    . "* | ���� | Tab +      | �ٰ� Shift + �����ַ� ��λ`n"
    . "* | ���� | Win  + j   | ��ʾ�����ش���`n"
    . "* | ���� | Ctrl + j   | �ƶ�����һ������`n"
    . "* | ���� | Ctrl + k   | �ƶ�����һ������`n"
    . "* | ���� | Ctrl + f   | ���������з�����һҳ`n"
    . "* | ���� | Ctrl + b   | ���������з�����һҳ`n"
    . "* | ���� | Ctrl + h   | ��ʾ��ʷ��¼`n"
    . "* | ���� | Ctrl + n   | �����ӵ�ǰ���ܵ�Ȩ��`n"
    . "* | ���� | Ctrl + p   | �ɼ��ٵ�ǰ���ܵ�Ȩ��`n"
    . "* | ���� | Ctrl + l   | ����༭������`n"
    . "* | ���� | Ctrl + r   | ���´����������ļ��б�`n"
    . "* | ���� | Ctrl + q   | ����`n"
    . "* | ���� | Ctrl + d   | �� TC �򿪵�һ���ļ�����Ŀ¼`n"
    . "* | ���� | Ctrl + s   | ��ʾ�����Ƶ�ǰ�ļ�������·��`n"
    . "* | ���� | Ctrl + x   | ɾ����ǰ�ļ�`n"
    . "* | ���� | Ctrl + i   | �ƶ���굱����`n"
    . "* | ���� | Ctrl + o   | �ƶ���굱��β`n"
    . "* | ���� | F2         | �༭�����ļ�`n"
    . "* | ���� | F3         | �༭�Զ�д��������ļ�`n"
    . "* | ���� | ������ַ   | ��ֱ������ www �� http ��ͷ����ַ`n"
    . "* | ���� | `;         | �Էֺſ�ͷ����� ahk ����`n"
    . "* | ���� | :          | ��ð�ſ�ͷ������� cmd ����`n"
    . "* | ���� | �޽��     | �����޽�����س��� ahk ����`n"
    . "* | ���� | �ո�       | ����ո��������������")
}

UpdateSendTo(create = true, overwrite = false)
{
    lnkFilePath := StrReplace(A_StartMenu, "\Start Menu", "\SendTo\") "RunZ.lnk"

    if (!create)
    {
        FileDelete, %lnkFilePath%
        return
    }

    if (!overwrite && FileExist(lnkFilePath))
    {
        return
    }

    FileCreateShortcut, %A_AhkPath%, % A_ScriptDir "\Runz\SendToRunZ.lnk"
        , , "%A_ScriptDir%\Runz\RunZCmdTool.ahk", ���͵� RunZ, % A_ScriptDir "\pic\RunZ.ico"
    FileCopy, % A_ScriptDir "\Runz\SendToRunZ.lnk"
        , % StrReplace(A_StartMenu, "\Start Menu", "\SendTo\") "RunZ.lnk", 1
}

UpdateStartupLnk(create = true, overwrite = false)
{
    lnkFilePath := A_Startup "\RunZ.lnk"

    if (!create)
    {
        FileDelete, %lnkFilePath%
        return
    }

    if (!FileExist(lnkFilePath) || overwrite)
    {
        FileCreateShortcut, %A_AhkPath%, %lnkFilePath%, %A_ScriptDir%, RunZ.ahk --hide, RunZ, % A_ScriptDir "\pic\RunZ.ico"
    }
}

ChangePath:
    UpdateSendTo(g_Conf.Config.CreateSendToLnk, true)
    UpdateStartupLnk(g_Conf.Config.CreateStartupLnk, true)
return

AlignText(text)
{
    col3MaxLen := g_SkinConf.DisplayCol3MaxLength
    col4MaxLen := g_SkinConf.DisplayCol4MaxLength
    col3Pos := 10

    StrSpace := " "
    Loop, % col3MaxLen + col4MaxLen
        StrSpace .= " "

    result := ""

    if (g_SkinConf.HideCol2)
    {
        ; ���صڶ��еĻ����ѵڶ��еĿռ�ָ�������
        col3MaxLen += 7
        col3Pos := 5

        hasCol2 := true
        Loop, Parse, text, `n, `r
        {
            if (SubStr(text, 3, 1) != "|" || SubStr(text, 8, 1) != "|")
            {
                hasCol2 := false
                break
            }
        }

        if (hasCol2)
        {
            col3Pos := 10
        }
    }

    if (g_SkinConf.HideCol4IfEmpty)
    {
        Loop, Parse, text, `n, `r
        {
            if (StrSplit(SubStr(A_LoopField, col3Pos), " | ")[2] != "")
            {
                hasCol4 := true
                break
            }
        }

        if (!hasCol4)
        {
            ; �����м�� " | "
            col3MaxLen += col4MaxLen + 3
            col4MaxLen := 0
        }
    }

    Loop, Parse, text, `n, `r
    {
        if (!InStr(A_LoopField, " | "))
        {
            result .= A_LoopField "`r`n"
            continue
        }

        if (hasCol2)
        {
            ; ���ݰ����ڶ��У���Ҫȥ��
            result .= SubStr(A_LoopField, 1, 4)
        }
        else
        {
            result .= SubStr(A_LoopField, 1, col3Pos - 1)
        }

        splitedLine := StrSplit(SubStr(A_LoopField, col3Pos), " | ")
        col3RealLen := StrLen(RegExReplace(splitedLine[1], "[^\x00-\xff]", "`t`t"))

        if (col3RealLen > col3MaxLen)
        {
            result .= SubStrByByte(splitedLine[1], col3MaxLen)
        }
        else
        {
            result .= splitedLine[1] . SubStr(StrSpace, 1, col3MaxLen - col3RealLen)
        }

        if (col4MaxLen > 0)
        {
            result .= " | "

            col4RealLen := StrLen(RegExReplace(splitedLine[2], "[^\x00-\xff]", "`t`t"))

            if (col4RealLen > col4MaxLen)
            {
                result .= SubStrByByte(splitedLine[2], col4MaxLen)
            }
            else
            {
                result .= splitedLine[2]
            }
        }

        result .= "`r`n"
    }

    return result
}

WatchUserFileList:
    FileGetTime, newUserFileListModifyTime, %g_UserFileList%
    if (newUserFileListModifyTime == "")
    {
        FileAppend, , %g_UserFileList%
    }

    if (lastUserFileListModifyTime != "" && lastUserFileListModifyTime != newUserFileListModifyTime)
    {
        LoadFiles()
    }
    lastUserFileListModifyTime := newUserFileListModifyTime

    FileGetTime, newConfFileModifyTime, %g_ConfFile%
    if (lastConfFileModifyTime != "" && lastConfFileModifyTime != newConfFileModifyTime)
    {
        GoSub, RestartRunZ
    }
    lastConfFileModifyTime := newConfFileModifyTime
return

SaveResultAsArg:
    Arg := ""
    ControlGetText, result, %g_DisplayArea%

    ; �������صڶ��е����
    if (g_SkinConf.HideCol2)
    {
        FullPipeArg := ""
        Loop, Parse, result, `n, `r
        {
            FullPipeArg .= SubStr(A_LoopField, 1, 2) "| ռλ | " SubStr(A_LoopField, 5) "`n"
        }
    }
    else
    {
        FullPipeArg := result
    }

    if (InStr(g_CurrentCommand, "file | ") == 1)
    {
        Arg .= StrSplit(g_CurrentCommand, " | ")[2]
    }
    else if (!InStr(result, " | "))
    {
        Arg .= StrReplace(result, "`n", " ")
        Arg := StrReplace(Arg, "`r")
    }
    else
    {
        if (g_SkinConf.HideCol2)
        {
            Loop, Parse, result, `n, `r
            {
                Arg .= Trim(StrSplit(A_LoopField, " | ")[2]) " "
            }
        }
        else
        {
            Loop, Parse, result, `n, `r
            {
                Arg .= Trim(StrSplit(A_LoopField, " | ")[3]) " "
            }
        }
    }

    Arg := Trim(Arg)

    ControlFocus, %g_InputArea%
    ControlSetText, %g_InputArea%, |
    Send, {End}
    if (g_CommandFilter != "")
    {
        ; ��һ�� | ����Ҫ�ùܵ�ִ�У���Ȼ g_PipeArg �ᱻ���
        SearchCommand("|" g_CommandFilter)
        g_CommandFilter := ""
    }
return

; ��ʽ��
; �� command1&command2
; �� command1|command2
; �� !command1
SetCommandFilter(command)
{
    g_CommandFilter := command
}

Help:
    DisplayResult(KeyHelpText() . GetAllFunctions())
return

KeyHelp:
    CF_ToolTip(KeyHelpText(),5000)
return

#include %A_ScriptDir%\Lib\EasyIni.ahk
#include %A_ScriptDir%\Lib\TCMatch.ahk
#include %A_ScriptDir%\Lib\Eval.ahk
#include %A_ScriptDir%\Lib\IME.ahk
#include %A_ScriptDir%\Lib\String.ahk
#include %A_ScriptDir%\Lib\Class_WinHttp.ahk
#include %A_ScriptDir%\Lib\ProcessMemory.ahk
#include *i %A_ScriptDir%\Runz\Plugins.ahk
; ���͵��˵��Զ����ɵ�����
#include *i %A_ScriptDir%\Settings\Runz\UserFunctionsAuto.txt
