; RunZ:Kanji
; ���己�廥��ת��

Kanji:
    @("T2S", "�����а�����������еķ���ת�ɼ���")
    @("S2T", "�����а�����������еļ���ת�ɷ���")
return

T2S:
    text := Arg == "" ? clipboard : Arg
    clipboard := ""
    clipboard := Kanji_t2s(text)
    ClipWait
    DisplayResult(clipboard)
return

S2T:
    text := Arg == "" ? clipboard : Arg
    clipboard := ""
    clipboard := Kanji_s2t(text)
    ClipWait
    DisplayResult(clipboard)
return

Kanji_s2t(text)
{
    return Kanji(text, 1)
}

Kanji_t2s(text)
{
    return Kanji(text)
}

; https://autohotkey.com/boards/viewtopic.php?t=9133
Kanji(s, r := "")
{
    ; r = 1-�� ""-����
    static f := __Kanji()
    n := r ? f.1 : f.2
    Loop, Parse, s
        b .= n[A_Loopfield] ? n[A_Loopfield] : A_Loopfield
    Return b
}

__Kanji()
{
    FileRead, s, % A_ScriptDir "\Runz\txt\Kanji.txt"
    f := [], h := [], s := Trim(s)
    Loop, Parse, s, % A_Space
        f[a := SubStr(A_Loopfield, 1, 1)] := b := SubStr(A_Loopfield, 2), h[b] := a
    return [f, h]
}
