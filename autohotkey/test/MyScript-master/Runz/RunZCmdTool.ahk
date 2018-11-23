#NoEnv
#NoTrayIcon
SendMode Input
SetWorkingDir %A_ScriptDir%

;FileEncoding, utf-8

; ������ļ�����˵�� UserFunctionsAuto.txt �ļ������ظ���ǩ����Ҫ�ֶ��޸Ļ�ɾ��

global g_ConfFile := A_ScriptDir . "\..\..\Settings\Runz\RunZ.ini"
global g_Conf := class_EasyINI(g_ConfFile)
global g_UserFunctionsAutoFileName := A_ScriptDir "\..\..\Settings\Runz\UserFunctionsAuto.txt"
global g_UserFileList := A_ScriptDir "\..\..\Settings\Runz\UserFileList.txt"
global g_FileContent

allLabels := Object()
index := 1

Loop, %0%
{
    inputFileName := %A_Index%
    SplitPath, inputFileName, fileName, fileDir, fileExt, fileNameNoExt

    if (fileNameNoExt == "")
    {
        continue
    }

    if (fileExt == "ahk")
    {
        FileReadLine, firstLine, %inputFileName%, 1
        if (InStr(firstLine, " RunZ:"))
        {
            pluginName := StrSplit(firstLine, "; RunZ:")[2]
            if (FileExist(A_ScriptDir "\Plugins\" pluginName ".ahk"))
            {
                CF_ToolTip(pluginName "����Ѵ���",1500)
                ExitApp
            }
            FileMove, %inputFileName%, %A_ScriptDir%\Plugins\%pluginName%.ahk
            FileAppend, #include *i `%A_ScriptDir`%\RunZ\Plugins\%pluginName%.ahk`n
                , %A_ScriptDir%\Plugins.ahk
            CF_ToolTip(pluginName, "�����װ�ɹ������ֶ����� RunZ ����Ч��", 1500)
            ExitApp
        }
    }

    labelName := SafeLabel(fileNameNoExt)
    fileExt := SafeFilename(fileExt)
    fileDir := SafeFilename(fileDir)
    fileName := SafeFilename(fileName)
    filePath := fileDir "\" fileName
    fileDesc := ""

    if (fileExt == "lnk" && g_Conf.Config.SendToMenuReadLnkFile)
    {
        FileGetShortcut, %filePath%, filePath, fileDir, targetArg, fileDesc

        if (fileDesc = filePath)
        {
            fileDesc := ""
        }

        filePath .= " " targetArg

        if (!g_Conf.Config.SendToMenuSimpleMode)
        {
            filePath := SafeFilename(filePath)
        }
    }

    if (g_Conf.Config.SendToMenuSimpleMode)
    {
        FileAppend, file | %filePath% | %fileDesc%`r`n, %g_UserFileList%

        continue
    }

    if (!FileExist(g_UserFunctionsAutoFileName))
    {
        FileCopy, %g_UserFunctionsAutoFileName%.template, %g_UserFunctionsAutoFileName%
    }

    FileRead, g_FileContent, %g_UserFunctionsAutoFileName%


    uniqueLabelName := labelName

    ; ��������б�ǩ���������ʱ��
    if (IsLabel(uniqueLabelName) || allLabels.HasKey(uniqueLabelName))
    {
        uniqueLabelName .= "_" A_Now "_" index
        index++
    }

    AddFile(uniqueLabelName, labelName, filePath, fileDir)
    allLabels[uniqueLabelName] := true
}

if (g_Conf.Config.SendToMenuSimpleMode)
{
    CF_ToolTip("�ļ������ϣ�3 ������Ч", 1500)
    ExitApp
}

FileMove, %g_UserFunctionsAutoFileName%, %g_UserFunctionsAutoFileName%.bak, 1
FileAppend, %g_FileContent%, %g_UserFunctionsAutoFileName%

; ���ļ����༭
if (g_Conf.Config.Editor != "")
{
    Run, % g_Conf.Config.Editor " """ g_UserFunctionsAutoFileName """"
}
else
{
    Run, %g_UserFunctionsAutoFileName%
}


return

; ���һ����Ҫ���е��ļ�
AddFile(name, comment, path, dir)
{
    addFunctionsText = @("%name%", "%comment%")
    addLabelsText = %name%:`r`n    `; �÷���  Run, "�ļ���" "����..", ����Ŀ¼, Max|Min|Hide`r`n
    addLabelsText = %addLabelsText%    Run, "%path%", "%dir%"`r`nreturn`r`n

    g_FileContent := StrReplace(g_FileContent
        , "    `; -*-*-*-*-*-", "    `; -*-*-*-*-*-`r`n    " addFunctionsText)
    g_FileContent := StrReplace(g_FileContent
        , "`r`n`; -*-*-*-*-*-", "`r`n`; -*-*-*-*-*-`r`n" addLabelsText)
}

SafeLabel(label)
{
    StringReplace, label, label, ", _, All
    return RegExReplace(label, "[ `%```t',]", "_")
}

SafeFilename(label)
{
    StringReplace, label, label, ", `"`", All
    StringReplace, label, label, ``, ````, All
    StringReplace, label, label, `%, ```%, All
    StringReplace, label, label, `,, ```,, All
    return label
}

; α @ ���������ڱ������г���
@(a = "", b = "", c = "", d = "", e = "", f = "")
{
}

#include %A_ScriptDir%\..\Lib\EasyIni.ahk
; �����ж��Ƿ����ظ���ǩ
#include *i %A_ScriptDir%\..\Settings\Runz\UserFunctionsAuto.txt