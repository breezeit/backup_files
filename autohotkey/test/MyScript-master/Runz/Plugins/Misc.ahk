; RunZ:Misc
; ʵ�ù��߼���

Misc:
    @("Dictionary", "�е��ʵ����߷���")
    @("Calc", "������")
    @("SearchOnBaidu", "ʹ�� �ٶ� �������а����������")
    @("SearchOnGoogle", "ʹ�� �ȸ� �������а����������")
    @("SearchOnBing", "ʹ�� ��Ӧ �������а����������")
    @("SearchOnTaobao", "ʹ�� �Ա� �������а����������")
    @("SearchOnJD", "ʹ�� ���� �������а����������")
    @("ShowIp", "��ʾ IP")
    @("Calendar", "���������������")
    ;@("CurrencyRate", "���� ʹ��ʾ���� hl JPY EUR 2")  ; API ʧЧ��ԭ����
    ;@("CNY2USD", "���� ����Ҷһ���Ԫ")
    ;@("USD2CNY", "���� ��Ԫ�һ������")
    @("UrlEncode", "URL ����")
return

ShowIp:
    DisplayResult(A_IPAddress1
            . "`r`n" . A_IPAddress2
            . "`r`n" . A_IPAddress3
            . "`r`n" . A_IPAddress4)
return

Dictionary:
    word := Arg == "" ? clipboard : Arg

    url := "http://fanyi.youdao.com/openapi.do?keyfrom=YouDaoCV&key=659600698&"
            . "type=data&doctype=json&version=1.2&q=" UrlEncode(word)

    jsonText := StrReplace(WinHttp.URLGet(url), "-phonetic", "_phonetic")

    if (jsonText == "no query")
    {
        DisplayResult("δ�鵽���")
        return
    }

    parsed := JSON.Load(jsonText)
    result := parsed.query

    if (parsed.basic.uk_phonetic != "" && parsed.basic.us_phonetic != "")
    {
        result .= " UK: [" parsed.basic.uk_phonetic "], US: [" parsed.basic.us_phonetic "]`n"
    }
    else if (parsed.basic.phonetic != "")
    {
        result .= " [" parsed.basic.phonetic "]`n"
    }
    else
    {
        result .= "`n"
    }

    if (parsed.basic.explains.Length() > 0)
    {
        result .= "`n"
        for index, explain in parsed.basic.explains
        {
            result .= "    * " explain "`n"
        }
    }

    if (parsed.web.Length() > 0)
    {
        result .= "`n----`n"

        for i, element in parsed.web
        {
            result .= "`n    * " element.key
            for j, value in element.value
            {
                if (j == 1)
                {
                    result .= "`n       "
                }
                else
                {
                    result .= "`; "
                }

                result .= value
            }
        }
    }

    DisplayResult(result)
    clipboard := result
return

Calendar:
    Run % "http://www.baidu.com/baidu?wd=%CD%F2%C4%EA%C0%FA"
return

SearchOnBaidu:
    word := Arg == "" ? clipboard : Arg

    Run, https://www.baidu.com/s?wd=%word%
return

SearchOnGoogle:
    word := UrlEncode(Arg == "" ? clipboard : Arg)

    Run, https://www.google.com.hk/#newwindow=1&safe=strict&q=%word%
return

SearchOnBing:
    word := Arg == "" ? clipboard : Arg

    Run, http://cn.bing.com/search?q=%word%
return

SearchOnTaobao:
    word := Arg == "" ? clipboard : Arg

    Run, https://s.taobao.com/search?q=%word%
return

SearchOnJD:
    word := Arg == "" ? clipboard : Arg

    Run, http://search.jd.com/Search?keyword=%word%&enc=utf-8
return

Calc:
    result := Eval(Arg)
    DisplayResult(result)
    clipboard := result
    TurnOnRealtimeExec()
return

UrlEncode:
    text := Arg == "" ? clipboard : Arg
    clipboard := UrlEncode(text)
    DisplayResult(clipboard)
return


#include %A_ScriptDir%\Lib\Eval.ahk
#include %A_ScriptDir%\Lib\class_JSON.ahk