--------------------------------------------------
-- 脚本名称: test
-- 脚本描述: 挖矿传说脚本v0.2 use xscript
--------------------------------------------------

-- 脚本入口
function main()
    bar.position(21,131)

    do_dig = true
    do_ad = true
    do_cave = true

--  do_free_diamond = false --控制事件的开启关闭 false
    do_free_diamond = true

    do_challenge = false
--     do_challenge = true
    do_challenge_reborn = false
--     do_challenge_reborn = true
    -- do_challenge_inspire = true  --inspire only when challenge
    challenge_loss_n = 0
    challenge_loss_m_to_reset = 2
    do_challenge_reset = true
------------------------------------------------
    in_game_status = true
------------------------------------------------
    dig_old_time = os.clock()
    free_diamond_old_time = os.clock()
    challenge_old_time = os.clock()
    challenge_reset_old_time = os.clock()
    cave_old_time = os.clock()
    ad_old_time = os.clock()
    free_diamond_post_old_time = os.clock()
    find_in_game_old_time = os.clock()
    err_post_old_time = os.clock()
------------------------------------------------
    while true do
        sleep(500)
        challenge_old_time = my_timer(5000,challenge_old_time,challenge_t)
        challenge_reset_old_time = my_timer(1200000,challenge_reset_old_time,challenge_reset)   --20m
        dig_old_time = my_timer(1000, dig_old_time, Dig_t)
        free_diamond_old_time = my_timer(30000, free_diamond_old_time, free_diamond_t)
        free_diamond_post_old_time = my_timer(5000,free_diamond_post_old_time,free_diamond_post)
        cave_old_time = my_timer(10000, cave_old_time, cave_t)
        ad_old_time = my_timer(5000,ad_old_time, ad_t)
        find_in_game_old_time = my_timer(500, find_in_game_old_time, find_in_game)
        err_post_old_time = my_timer(10000,err_post_old_time, err_post)

    end

end
-------------------------------------------------------
function my_timer(t, old_time, f)
--t=time_val(ms), old_time=timer start-time, f=function name
    time_val = os.clock() - old_time
    t = t/1000
    if time_val > t then
        f()
        old_time = os.clock()
    end
    return old_time
end

---------------------------------------------------------
function find_in_game()
    local isFound1 = find.colors({0xFEF05A, {-7,36,0xF0DF68}, {36,22,0xDDAD49}},100,4,25,94,112)
    local isFound2 = find.colors({0x696939, {-9,34,0x665F2D}, {34,16,0x574317}},95,1,29,90,111)
    --find_left_gold
    local isFound3 = find.colors({0x76F1FF, {27,13,0x1E5DC7}, {42,34,0x1D82C6}},100,4,25,94,112)
    local isFound4 = find.colors({0x0B2556, {-13,23,0x092449}, {36,21,0x144050}},95,630,26,711,120)
    --find_right_diamond
    in_game_status = isFound1 or isFound2 or isFound3 or isFound4
    return in_game_status
end
--------------------------------------------------------
function Dig_t()
    if (do_dig and in_game_status and find_dig()) then
        sleep(200)
        touch.click(448,1176)   --挖掘按钮
        --toast("click dig", 300)
    end
end

function find_dig()  --挖掘冷却(448,1180) --Dig skill cooldown
    local isFound = find.colors({0xEEDE23, {32,21,0x91BAE3}, {49,66,0x502E1B}},95,368,1107,529,1260)
--  if isFound then
--      toast("findDig()",300)
--  end
    return isFound
end
--------------------------------------------------
function find_cave()  --(659,234)
    local isFound = find.colors({0xC68C73, {17,31,0xB9B93C}, {41,10,0x45342C}},100,613,168,714,255)
    return isFound
 end

function find_cave_enter()
    local isFound = find.colors({0xFFFFFF, {-1,25,0xF9F9FC}, {18,7,0x4B3A91}, {17,21,0x4B3A91}, {28,10,0xFFFFFF}},100,318,744,361,790)
    return isFound
end

function cave_t()
    if (do_cave and in_game_status and find_cave()) then
        touch.click(659,234)  --cave
        sleep(300)
        touch.click(360,773)  --enter
    end

    if (do_cave and in_game_status and find_cave_enter()) then
        touch.click(360,773)  --enter
    end

end
--------------------------------------------------
function find_ad_x()
    ad_right_top_x = find.colors({0xFFFFFF, {12,0,0xDBDBDB}, {13,12,0xDBDBDB}, {6,13,0x000000}},95,680,5,714,38)
    --(697,21) x
    ad_right_top_x_t = find.colors({0xEFEAEF, {5,-1,0x8D6C8B}, {10,-1,0xEFEAEF}, {11,6,0x8D6C8A}},100,676,3,716,42)
    --(698,21) x
    ad_left_top_x_s = find.colors({0x515151, {10,0,0x5B5B5B}, {10,10,0x535353}, {3,12,0xFFFFFF}},95,15,16,68,69)
    --(44,42) x
    ad_left_top_x_l = find.colors({0x4F4F4F, {15,2,0x797979}, {17,18,0x4A4A4A}, {4,16,0xFFFFFF}},95,11,15,76,74)
    --(45,44) x
    ad_v_x = find.colors({0x7C7C7C, {19,3,0x7E7E7E}, {17,21,0x7C7C7C}, {9,22,0xFAFAFA}},95,1196,24,1256,78)
    --(1225,58) x
    ad_x_status = ad_right_top_x or ad_right_top_x_t or ad_left_top_x_s or ad_left_top_x_l or ad_v_x
    return ad_x_status
end

function ad_t()
    if (do_ad and in_game_status==false) then
        toast("not in game ")
        sleep(200)
        find_ad_x()
        if (ad_right_top_x) then
            sleep(200)
            toast("ad_right_top_x", 300)
            touch.click(697,21)  --close
            ad_post()
        end

        if (ad_right_top_x_t) then
            sleep(200)
            toast("ad_right_top_x_t", 300)
            touch.click(698,21)  --close
            ad_post()
        end
        if (ad_left_top_x_s and ad_left_top_x_l==false ) then
            sleep(200)
            toast("ad_left_top_x_s", 300)
            touch.click(44,42)  --close
            ad_post()
        end
        if (ad_left_top_x_l) then
            sleep(200)
            toast("ad_left_top_x_l", 300)
            touch.click(46,45)  --close
            ad_post()
        end
        if (ad_v_x) then
            sleep(200)
            toast("ad_v_x", 300)
            touch.click(1225,58)  --close
            ad_post()
        end
    end
end

function ad_post()
    sleep(1000)
    touch.click(352,660)
    sleep(1000)
    touch.click(352,660)
    sleep(1000)
    prompt_100ad_post()  --x
end

function prompt_100ad_post()  --find_err_ad_post()
    local isFound = find.colors({0x7D55EE, {-7,11,0xFF2323}, {-13,35,0xFF2323}, {22,22,0x7D56EF}},100,576,263,637,323)
    -- red x
    local isFound2 = find.colors({0x4E3D97, {-2,40,0x4E3D97}, {18,7,0x2E3359}, {21,50,0x2E3359}},100,532,859,604,977)
    -- no free
    --100ad post
    if (isFound and isFound2) then
        sleep(200)
        touch.click(611,293) -- x
        -- toast("err_ad_post", 300)
    end
end
-----------------------------------------------------
function findBag()   --(616,1183)
    local isFound = find.colors({0xBE662D, {29,24,0xBF7A37}, {39,52,0x945228}},90,540,1104,711,1262)
    return isFound
 end

function find_diamond_bag()  --click(402,659) to diamond_bag
    local isFound = find.colors({0x8628DF, {9,23,0xFFFFFF}, {30,46,0xFFFFFF}, {50,50,0x413838}},100,487,687,599,796)
    return isFound
end

function find_diamond_free() --(122,980)
    local isFound = find.colors({0xFC3BFD, {-1,36,0x206AD5}, {37,27,0xE0F5FA}, {58,59,0xFF61FF}},100,24,859,246,1112)
    return isFound
end

function find_diamond_free_dark()
    local isFound = find.colors({0x7E4190, {27,-56,0x803591}, {74,-39,0x813791}},100,43,907,216,1064)
    return isFound
end

function err_post()
    if (find_diamond_free_dark) then
        sleep(200)
        touch.click(650,657)  --x
    end

    if (find.colors({0xFFFFFF, {28,1,0xFFFFFF}, {19,6,0x2E3359}, {-1,20,0xFFFFFF}},98,420,603,465,649)) then
        --"石"字
        sleep(200)
        touch.click(361,772)  --check
    end
end


function free_diamond_t()
    if (do_free_diamond and in_game_status and findBag()) then
        sleep(200)
        touch.click(616,1183)  --click bag
        sleep(500)
        touch.click(402,659)  --click(402,659) to diamond_bag
        sleep(300)
        if (find_diamond_bag()) then
            if(find_diamond_free()) then
                toast("100 free!", 1000)
                touch.click(122,980)  --click ad-btn
                else
                    toast("not 100 free!", 1000)
                    touch.click(651,657)  --close
            end

        end
    end
end

function find_diamond_free_post()
    local isFound = find.colors({0x2F1937, {39,-54,0x25333B}, {93,-55,0x35163C}, {117,-26,0x111C32}},100,34,863,222,1076)
    -- free diamond dark
    local isFound2 = find.colors({0x7D56EE, {11,-12,0xFF2323}, {20,23,0x7D55EF}, {31,-9,0xFF2323}},100,595,425,683,512)
    -- red x
    return (isFound and isFound2)
end

function free_diamond_post()
    if (do_free_diamond and in_game_status and find_diamond_free_post()) then
        sleep(200)
        touch.click(362,770) --click check
        toast("free_diamond_post", 300)
        sleep(200)
        if (find_diamond_bag()) then
            touch.click(651,660)  --close
        end
    end


end
------------------------------------------------------
function find_challenge_btn()  --(362,165)btn
    local isFound = find.colors({0x1040AA, {20,20,0xFFFFFF}, {55,29,0xFFFFFF}, {83,33,0x0C488A}},95,274,126,442,209)
    local isFound2 = find.colors({0x781E95, {10,35,0x4D1675}, {52,15,0xFFFFFF}, {90,23,0x511879}},95,260,122,444,211)
    local isFound3 = find.colors({0x831F1A, {28,2,0xFFFFFF}, {58,6,0x7A191A}, {79,10,0xFFFFFF}},95,283,129,434,211)
     if (isFound or isFound2 or isFound3) then
         toast("find_challenge_btn")
     else
         toast("not   find_challenge_btn")
     end
    return (isFound or isFound2 or isFound3)
end

function find_shi()  --血条没完,挑战失败--还需改变
    local isFound = find.colors({0x3B0F09, {-1,16,0x3C0F09}, {-2,34,0x3C0F09}},100,158,132,559,204)
    --red
    local isFound2 = find.colors({0x07233C, {-3,18,0x07233C}, {-4,36,0x07233C}},98,158,130,214,207)
    --blue
    local isFound3 = find.colors({0x696969, {-16,35,0x696969}, {17,34,0x696969}, {1,28,0x25253A}, {-9,14,0x2A253B}, {14,12,0x25243A}},98,312,263,362,312)
    --“失”字
    return (isFound or isFound2 or isFound3)
end

function find_free_reborn()  --(490,778)
    local isFound = find.colors({0xDF3033, {10,6,0x07A7D2}, {16,28,0xFFFF67}},100,458,705,518,803)
    return isFound
end

function find_inspire()  --(270,1183) --无效，错误
    local isFound = find.colors({0xD5CC1D, {28,-10,0xDCDCDC}, {66,41,0xB09801}},95,196,1110,351,1260)
    if (isFound) then
        toast("find_inspire()")
    end
    return isFound
end

function challenge_reset()
    if (do_challenge_reset) then
        do_challenge = true
        challenge_loss_n = 0
        toast("challenge_reset", 2000)
    end
    return challenge_reset_old_time
 end

function challenge_t()
    if (do_challenge and in_game_status and find_challenge_btn() and find_cave()==false) then --防止冲突cave and
     toast("challenge_t 1")
        do_dig = false
        touch.click(361,169)  --enter
        sleep(300)
        do_dig = true
        Dig_t()
    end
    if (do_challenge and in_game_status and find_cave()==false and find_shi()) then  --防止冲突cave--失败处理
        toast("challenge_t 2")
        if (do_challenge_reborn and find_free_reborn()) then
            touch.click(490,778)  --free reborn
        else
            touch.click(640,470)  --x
            challenge_loss_n = 1 + challenge_loss_n
            if challenge_loss_n > challenge_loss_m_to_reset then
                do_challenge = false
            end
            toast("challenge失败"..challenge_loss_n, 2000)
        end

    end

end

main()
