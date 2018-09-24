--------------------------------------------------
-- 脚本名称: Nonstop
-- 脚本描述: 20170617
--------------------------------------------------

-- 脚本入口
function main()
    bar.position(629,237)
    bar.showMsg("hhhhhhh")

    boss_fight_stat = true
--  boss_fight_stat = false
    boss_fighting_stat = false
    up_stat = true
--  up_stat = false
    only_gemBox_exp_stat  = false
    in_game_stat = true
    no_gemBox_stat = false
--  no_gemBox_stat =true

    boss_loss_count = 0
    boss_fight_max = 2

    pd_1_start_time = os.clock()
    pd_3_start_time = os.clock()
    pd_10_start_time = os.clock()
    pd_30_start_time = os.clock()
    pd_60_start_time = os.clock()
    boss_fight_reset_start_time = os.clock()

    while true do
        sleep(500)
        pd_1_start_time = my_timer(1, pd_1_start_time, pd_1)
        pd_3_start_time = my_timer(3, pd_3_start_time, pd_3)
        pd_10_start_time = my_timer(10, pd_10_start_time, pd_10)
        pd_30_start_time = my_timer(30, pd_30_start_time, pd_30)
        pd_60_start_time = my_timer(30, pd_60_start_time, pd_60)
        boss_fight_reset_start_time = my_timer(600, boss_fight_reset_start_time, boss_fight_reset)
    end
end

---------------------------------------------

function my_timer(cd_time, start_time, func_name) --cd_time(s)
    local time_val = os.clock() - start_time
    if time_val > cd_time then
        func_name()
        start_time = os.clock()
    end
    return start_time
end
----------------------------------------------

function pd_1()
    click_skills()
    pd_boss_fight_stat()
end

function pd_3()
    do_in_game()
    boss_enter()
    err_x()
    win_flag_c()
    do_ad()
end

function pd_10()
    do_gemBox()

    do_sbc()

    do_err_attr()
    do_left_other()
end

function pd_30()
    do_gold_fire()
    do_jew_heap()
    do_err_triangle()
    do_all_ad()
end

function pd_60()

    up()
    bar.position(629,237)
end
-----------------------------------
function err_x()
    boss_loss_x()
end
----------------------------------

function click_skills()
    if (in_game_stat and find_bag()) then
        touch.click(118,1169)  --s1
        touch.click(275,1180)  --s2
        touch.click(460,1175)  --s3
    end
end

function pd_boss_fight_stat()
    if (in_game_stat and  find_gold_kulo() and find_boss_bar()) then
        boss_fighting_stat =true
    else
        boss_fighting_stat = false
    end

end

function boss_loss_x()
    if (in_game_stat and  find_boss_loss_btn()) then
        sleep(200)
        touch.click(605,527)  --x
        boss_loss_count = boss_loss_count + 1
        toast("boss loss: "..boss_loss_count, 3000 )
        if (boss_loss_count > boss_fight_max) then
            boss_fight_stat = false
            boss_fight_reset_start_time = os.clock()
            toast("boss loss: "..boss_loss_count.." too much!", 3000)
        end
    end
end

function boss_enter()
    if (in_game_stat and find_boss_fight_btn() and boss_fight_stat  ) then
        touch.click(360,210)  --btn enter
        boss_fighting_stat = true
        sleep(2000)
    end
end

function boss_fight_reset()
    boss_fight_stat = true
    boss_loss_count = 0
end

function win_flag_c()
    if (in_game_stat and  find_win_flag()) then
        touch.click(349,638)
        sleep(1000)
        touch.click(349,638)
    end
end

function up()
    if (in_game_stat and up_stat and find_bag()) then
        touch.click(615,1177)  --c bag
        sleep(200)
        if (find_boss_ticket()==false) then
            if (find_up_green()) then
                for i=1,10 do
                    sleep(100)
                    touch.click(655,813)
                end
            end
            sleep(1000)
            if (find_triangle()) then
                touch.click(652,646)   --c triangle
            end
        else
            touch.click(74,648)   --weapon tab
            sleep(200)
            touch.click(649,642)   --triangle
        end
    end
end

function do_gemBox()

    if (in_game_stat and find_gemBox()) then
        touch.click(76,414)  --click
        return true
    end
    sleep(200)
    if (in_game_stat and no_gemBox_stat) then
        touch.click(605,525)  --x
        return true
    else
        if (in_game_stat and only_gemBox_exp_stat) then
            if (find_gemBox_exp()) then
                touch.click(359,795)  --(359,795)观看btn
                return true
            else
                touch.click(605,525)  --x
                return true
            end
        else
--          if (in_game_stat and find_gemBox_exp()) then
--              touch.click(359,795)  --(359,795)观看btn
--          end
--          if (in_game_stat and find_gemBox_gold()) then
--              touch.click(359,795)  --(359,795)观看btn
--          end
--          if (in_game_stat and find_gemBox_redBottle()) then
--  --          touch.click(605,525)  --x
--              touch.click(359,795)  --(359,795)观看btn
--          end
            if (in_game_stat and find_watch_btn()) then
                touch.click(359,795)  --(359,795)观看btn
                return true
            end
        end
    end
    return false
end

function do_sbc()
    if (in_game_stat and (find_shield() or find_badge() or find_chest() or find_jew() or find_gemBox_petBox())) then
        touch.click(80,409)  --c
    end
end

function do_ad()
    if (in_game_stat==false and find_ad_v()) then
        touch.click(1257,20)  --x
    end
    if (find_ad() and in_game_stat==false ) then
        sleep(200)
        touch.click(681,35)  --x
    end
end

function do_all_ad()
    if (find_in_nox()==false and in_game_stat==false) then
        touch.click(1257,20)  --x
        sleep(200)
        touch.click(681,35)  --x
        sleep(200)
    end
end

function do_in_game()
    if (find_in_game()) then
        in_game_stat = true
    else
        in_game_stat = false
    end
end

function do_err_attr()
    if (find_in_game() and find_err_attr()) then
        touch.click(610,283)   --x
        touch.click(610,283) --x
        sleep(200)
        touch.click(652,646)   --triangle
    end
end

function do_err_triangle()
    if (find_triangle()) then
        touch.click(655,645) --triangle
    end
end

function do_gold_fire()
    if (find_gold_fire()) then
        touch.click(78,416)  --c
        sleep(2000)
        touch.click(564,360)  --active
    end
end

function do_jew_heap()
    if (find_jew_heap()) then
        touch.click(79,409)  --c
        sleep(1000)
        if (find_store_ad_free()) then
            touch.click(172,417)  --stroe-add-free
            sleep(200)
            touch.click(359,792)  --watch btn
        end
    end
end

function do_left_other()
    if (find_gold_fire()==false and find_jew_heap()==false and do_gemBox()==false) then
        touch.click(77,427)   --补充
        sleep(500)
        touch.click(396,538)
        sleep(200)
        touch.click(396,538)

    end
end

----------------------------------------------------------------------------------------
function find_bag()  --(616,1182)
    local isFound = find.colors({0xD47A41, {24,19,0xB08E89}, {50,41,0x8D5B48}},95,545,1106,712,1264)
    return isFound
end

function find_kulo()
end

function find_gold_kulo()
    local isFound = find.colors({0xFFF21F, {-8,47,0xFFAB0F}, {12,75,0xFEBF06}},95,310,54,406,154)
    return isFound
end

function find_gray_gold_kulo()
    local isFound = find.colors({0x272505, {3,51,0x271A02}, {18,74,0x271F01}},95,307,57,414,152)

    return isFound
end

function find_boss_loss_btn()
    local isFound1 = find.colors({0xFFDD25, {-4,35,0xB861FF}, {-3,67,0xFBAA01}},951,302,749,368,850)
    local isFound2 = find.colors({0x270E09, {-1,10,0x250B08}, {0,19,0x250A08}},95,193,160,526,216)
    return (isFound1 or isFound2)
end

function find_boss_bar()
    local isFound = find.colors({0xF85D3E, {0,10,0xF04833}, {0,16,0xF14A36}},95,200,160,518,212)
    return isFound
end

function find_boss_fight_btn()
    local isFound = find.colors({0xFFDC24, {187,-2,0xFFDD26}, {-4,66,0xFBAB02}, {186,67,0xFBAB01}},95,233,156,482,269)
    if (isFound and boss_fight_stat==false) then
        toast("boss_fight_stat: false; time remain: "..(math.floor(os.clock()-boss_fight_reset_start_time)), 300)
--  elseif (isFound and boss_fight_stat==true) then
--      toast("find_boss_fight_btn",3000)
--  else
-- --       toast("not find_boss_fight_btn",3000)
    end
    return isFound
end

function find_win_flag()
    local isFound = find.colors({0xE3821C, {169,-9,0xF59624}, {378,6,0xCE6A16}},95,68,340,633,430)
    return isFound
end

function find_up_green()
    local isFound = find.colors({0x8DC834, {-1,42,0x6BAF11}, {82,3,0x8AC631}, {82,39,0x6DB012}},95,598,771,713,881)
    return isFound
end

function find_up_gray()
    local isFound = find.colors({0x777C93, {-2,44,0x5A5E70}, {78,5,0x616578}, {82,49,0x5B5F71}},95,598,767,712,880)
    return isFound
end

function find_triangle()
    local isFound = find.colors({0xC7CAFF, {32,0,0xC7CAFF}, {15,25,0xC7CAFF}, {33,19,0x4E5696}},95,616,615,690,681)
    return isFound
end

function find_gemBox()  --76,414
    local isFound1 = find.colors({0x735DCF, {25,30,0xF881FF}, {49,72,0x423993}, {59,43,0x6E82CC}},95,10,336,159,484)
    local isFound2 = find.colors({0x775BD3, {14,23,0xFA87FF}, {32,44,0x9188DF}, {55,64,0x413992}},95,13,313,147,726)
--  if (isFound1 or isFound2) then
--     toast("找到gemBox")
--  else
--      toast("未找到gemBox")
--  end
    return (isFound1 or isFound2)
end

function find_gemBox_exp()
    local isFound = find.colors({0x38BCE5, {44,19,0x89E4FD}, {91,46,0xD6FFFF}, {106,-26,0x4395DA}},95,92,574,254,736)
    return isFound
end

function find_gemBox_gold()
    local isFound = find.colors({0x0A6486, {-1,27,0xFFC247}, {69,30,0x1398CB}, {100,-39,0xE9C94C}},95,90,580,254,735)
    return isFound
end

function find_chest()
    local isFound = find.colors({0x825D41, {4,23,0x292E33}, {45,30,0x7291AC}, {72,48,0x3C2C21}},95,14,352,152,476)
    --wood
    return isFound
end

function find_ad()
    local isFound1 = find.colors({0xFFFFFF, {8,-5,0xD1D22D}, {11,0,0xFDFDF7}, {16,6,0xBCC022}},95,656,11,709,57)
    --682,35
    local isFound2 = find.colors({0xFFFFFF, {11,1,0xFFFFFF}, {11,-2,0xFFFFFF}, {-5,7,0xA39731}},95,656,8,700,54)
    --681,35
    local isFound3 = find.colors({0xFFFFFF, {10,-4,0x313256}, {8,7,0xFFFFFF}, {1,-1,0xFFFFFF}},95,656,13,701,57)
    --680,34
    return (isFound1 or isFound2 or isFound3)
end

function find_ad_v()
    local isFound1 = find.colors({0x777777, {4,1,0x101010}, {10,2,0x717171}, {13,3,0x101010}},95,1239,0,1276,39)
    --(1257,20) --x
    local isFound2 = find.colors({0x7B7E81, {5,-3,0x181C20}, {9,-2,0x808285}, {9,9,0x7E8083}, {10,3,0x181C20}},95,1239,2,1277,42)
    --(1257,20) --x
    local isFound3 = find.colors({0x7B7B7B, {-6,2,0xACADAE}, {6,0,0xCFCECE}, {0,6,0xFBFBFB}},95,1218,4,1267,57)
    --1240,32
    local isFound4 = find.colors({0xFFFFFF, {-9,-9,0xC08AD3}, {5,-6,0xE8C8F3}, {12,9,0xE5D5ED}},95,1213,6,1270,63)
    --1242,36
    return (isFound1 or isFound2 or isFound3 or isFound4)
end

function find_shield()  --80,409
    local isFound = find.colors({0xF1A323, {9,22,0x4A6382}, {16,59,0xB5651C}, {46,53,0xCE7C24}, {64,3,0xF7A828}},95,24,341,143,485)
    return isFound
end

function find_badge()
    local isFound = find.colors({0x6D5FC6, {7,29,0xCC93F3}, {11,4,0x4C49B3}, {46,6,0xBC89EB}, {15,-21,0x555895}},95,8,331,162,484)
    return isFound
end

function find_jew()
    local isFound = find.colors({0x92623D, {26,-23,0xD87DFA}, {43,-4,0xFFF243}, {53,11,0xB37143}},95,27,312,144,721)
    return isFound
end

function find_in_game()
    local isFound1 = find.colors({0x221509, {-12,14,0x26180A}, {8,14,0x241607}, {5,29,0x261806}},98,527,7,573,63)
    --dark right-top gold
    local isFound2 = find.colors({0xFFBA5E, {4,18,0x7453FF}, {20,21,0xFFB050}},95,199,6,250,64)
    --light daibi
    if (isFound1 or isFound2) then
--     toast("in game")
    else
        toast("not in game", 300)
    end
    return (isFound1 or isFound2)
end

function find_gemBox_redBottle()
    local isFound = find.colors({0xF96584, {26,7,0xFFDADA}, {25,-10,0xF26F89}, {18,-61,0xB39269}},95,101,583,247,730)
    return isFound
end

function find_gemBox_gem5()
    local isFound = find.colors({0xDDB4FD, {22,47,0xBF65FF}, {66,3,0xC24EFF}, {60,72,0xFFFFFF}},95,106,588,242,731)
    return isFound
end

function find_gemBox_petBox()
    local isFound  = find.colors({0x513B39, {9,13,0xFFC81C}, {44,10,0x5A3F3B}, {24,35,0xF38509}},95,20,339,151,779)
    return isFound
end

function find_in_nox()
    local isFound = find.colors({0x4D4D4D, {1,6,0x4D4D4D}, {-4,7,0xFFFFFF}, {5,1,0xFFFFFF}},95,638,1,660,33)
    if (isFound) then
        toast("in nox",300)
    end
    return isFound
end

function find_err_attr()
    local isFound = find.colors({0xF49C2E, {-11,13,0xF99724}, {130,-2,0xB353FF}, {131,9,0x8E45FF}},95,91,841,326,929)
    return isFound
end

function find_boss_ticket()
    local isFound = find.colors({0xBC5117, {9,31,0xB28253}, {36,19,0xEBA95F}, {27,45,0x67250D}},95,8,767,136,1137)
    return isFound
end

function find_gold_fire()
    local isFound,x,y,tb = find.colors({0xFFD552, {34,-1,0xFFC33C}, {-10,28,0xFF9D34}, {29,34,0xFFA231}},95,13,336,160,488)
    return isFound
end


function find_jew_heap()
    local isFound = find.colors({0xF7CC41, {11,10,0xC555F4}, {-14,25,0x8B5B38}, {24,56,0xC44DF4}},95,15,340,145,494)
    return isFound
end

function find_store_ad_free()
    local isFound = find.colors({0xFC4242, {0,22,0xE93030}, {12,14,0xFFFFFF}, {20,21,0xEA3131}},95,102,316,157,369)
    return isFound
end

function find_watch_btn()
    local isFound = find.colors({0xFFF7D8, {4,6,0xFFCC11}, {0,8,0xFFFFFF}, {1,16,0xFFC80F}, {2,23,0xFFFFFF}},95,318,775,338,821)
    --观看的“又”
    return isFound
end
-- 此行无论如何保持最后一行
main()
