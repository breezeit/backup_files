; http://ahk.5d6d.com/viewthread.php?tid=703

#IfWinActive ahk_group ccc
F2::
    WinID := WinExist("A")  ; ��ȡ��ǰ���ڵ� ID
    ControlGetFocus, ControlName, ahk_id %WinID%    ; ��ȡ��ǰ���ڻ�ý���Ŀؼ���

    IfNotInString, ControlName, Edit    ; �жϵ�ǰ�Ƿ�������״̬, Edit ���������༭�������
    {
		State = 0
        Send, {F2}
        Sleep, 100
    }

    ControlID := GetFocusControlID()    ; ��ȡ�������༭��� ID
    ControlGetText, FileName,, ahk_id %ControlID%   ; ��ȡ�ļ������ļ�����

    StringGetPos, DotPostion, FileName, ., R ; ��ȡ���ұߵ� "." ��λ��

    If !ErrorLevel   ; ���ļ����� "." ʱ�Ž��б任ѡ��
    {
        MoveCount := StrLen(FileName) - DotPostion
        if state=
            state=2
        Goto, RenameState%State%
    }
Return
#IfWinActive

RenameState0:
State = 1
Return

; ��ѡ����չ��
RenameState1:
    ExtensionMoveCount := MoveCount - 1
    Send, ^{End}+{Left %ExtensionMoveCount%}
		State =2
Return

; ȫѡ�ļ�����������չ����
RenameState2:
    Send, ^{Home}+^{End}
		State = 3
Return

; ���ͣ����չ����"."ǰ
RenameState3:
    Send, ^{End}{Left %MoveCount%}
		State = 4
Return

; ��ѡ���ļ�������������չ����
RenameState4:
Send, ^{Home}+^{End}+{Left %MoveCount%} ; ȫѡ��Ȼ��ס Shift ���ƣ���ѡ����չ��
	State = 1
Return

;-------------------------------------------------------------------------------

; ~ ���ص�ǰ���ڻ�ý���Ŀؼ��� ID
GetFocusControlID()
    {
        WinID := WinExist("A")
        ControlGetFocus, ControlName, ahk_id %WinID%
        ControlGet, ControlID, HWND,, %ControlName%, ahk_id %WinID%
        Return ControlID
    }

;-------------------------------------------------------------------------------