local STATE = vci.state
local ASSET = vci.assets
local STUDIO = vci.studio
local ASHU_MESS = "ASHU_ZINRO_MESS_"
local CHOSE_COL = Color.__new(0, 1, 0)
local NO_CHOSE_COL = Color.__new(1, 1, 1)
local DEATH_COL = Color.__new(0.3, 0.3, 0.3)

local R = {
    {
        name = "人狼",
        first_fortune = false,
        fortune_result = true,
        night_act = true,
        side = 1,
        ookami = true,
        kitune = false
    },
    {
        name = "村人",
        first_fortune = true,
        fortune_result = false,
        night_act = false,
        side = 2,
        ookami = false,
        kitune = false
    },
    {
        name = "占い師",
        first_fortune = true,
        fortune_result = false,
        night_act = true,
        side = 2,
        ookami = false,
        kitune = false
    },
    {
        name = "霊媒師",
        first_fortune = true,
        fortune_result = false,
        night_act = false,
        side = 2,
        ookami = false,
        kitune = false
    },
    {
        name = "騎士",
        first_fortune = true,
        fortune_result = false,
        night_act = true,
        side = 2,
        ookami = false,
        kitune = false
    },
    {
        name = "狂人",
        first_fortune = true,
        fortune_result = false,
        night_act = false,
        side = 1,
        ookami = false,
        kitune = false
    },
    {
        name = "狂信者",
        first_fortune = true,
        fortune_result = false,
        night_act = false,
        side = 2,
        ookami = false,
        kitune = false
    },
    {
        name = "妖狐",
        first_fortune = false,
        fortune_result = false,
        night_act = false,
        side = 3,
        ookami = false,
        kitune = true
    },
    {
        name = "背徳者",
        first_fortune = true,
        fortune_result = false,
        night_act = false,
        side = 3,
        ookami = false,
        kitune = false
    },
    {
        name = "てるてる",
        first_fortune = true,
        fortune_result = false,
        night_act = false,
        side = 4,
        ookami = false,
        kitune = false
    },
    {
        name = "共有者",
        first_fortune = true,
        fortune_result = false,
        night_act = false,
        side = 2,
        ookami = false,
        kitune = false
    },
    {
        name = "黒騎士",
        first_fortune = false,
        fortune_result = true,
        night_act = true,
        side = 1,
        ookami = false,
        kitune = false
    },
    {
        name = "猫又",
        first_fortune = false,
        fortune_result = false,
        night_act = false,
        side = 1,
        ookami = false,
        kitune = false
    },
    --陣営
    side_zinro = 1,
    side_mura = 2,
    side_youko = 3,
    side_teruteru = 4,
    --役職番号
    zinro = 1,
    murabito = 2,
    uranaisi = 3,
    reibaisi = 4,
    kisi = 5,
    kyozin = 6,
    kyosinsya = 7,
    youko = 8,
    haitokusya = 9,
    teruteru = 10,
    kyoyuusya = 11,
    kurokisi = 12,
    nekomata = 13,
    role_max = 13
}
local DATA = {
    --待機時間
    game_start_timer = 30,
    str = {"部屋", "部屋名", "矢印"},
    str_si = {},
    --参加最小人数
    player_min = 4,
    --参加最大人数
    player_max = 16,
    str_house_num = 1,
    str_house_name_num = 2,
    str_yazirushi_num = 3,
    --家の最小距離
    house_def_min_dist = 1.2,
    --家の最大距離
    house_def_max_dist = 9.6,
    --時間関係a
    str_clock = {"管理タイマー", "時計", "投票結果"},
    str_clock_si = {},
    str_clock_timer = 1,
    str_clock_clock = 2,
    str_clock_vote_result = 3,
    --操作関係
    str_operator = {"操作内容", "操作文"},
    str_operator_si = {},
    str_operator_num = 1,
    str_operator_txt_num = 2,
    operator_player_max = 22 + 2,
    ---------------------------------
    --変更有
    game_player_max = 16,
    option_role_max = 6 * 5 + 2,
    ---------------------------------
    operator_max = 6 * 6,
    operator_high = 6,
    --操作行動関係
    str_operator_act = {"操作盤", "閉じる", "ゲーム参加者", "役職決定", "ゲームオプション設定"},
    str_operator_act_si = {},
    str_operator_act_operator = 1,
    str_operator_act_close = 2,
    str_operator_act_join = 3,
    str_operator_act_role = 4,
    str_operator_act_option = 5,
    --行動関係
    str_role_act = {
        "欠けあり",
        "初日占いなし",
        "パターン2仕様",
        "役職オプション設定仕様",
        "初日占い手動可能",
        "タイマー非回転",
        "(1/2)タイマー",
        "(1/3)タイマー",
        "(1/4)タイマー",
        "(1/8)タイマー"
    },
    str_role_act_chip = 1,
    str_role_act_fortune = 2,
    str_role_act_pattern = 3,
    str_role_act_option = 4,
    str_role_act_fortune_hand = 5,
    str_role_act_timer_rot = 6,
    str_role_act_timer2 = 7,
    str_role_act_timer3 = 8,
    str_role_act_timer4 = 9,
    str_role_act_timer8 = 10,
    --役職関係

    str_option_role_act = {},
    Daytime = 60 * 5,
    Nightime = 60 * 1.5
}
DATA.str_option_role_act = {
    R[R.murabito],
    R[R.murabito],
    R[R.murabito],
    R[R.murabito],
    R[R.murabito],
    R[R.murabito],
    R[R.murabito],
    R[R.murabito],
    R[R.murabito],
    R[R.murabito],
    --------------------------
    R[R.murabito],
    R[R.murabito],
    R[R.uranaisi],
    R[R.reibaisi],
    R[R.kisi],
    R[R.kyozin],
    R[R.kyozin],
    R[R.kyozin],
    R[R.kyozin],
    R[R.zinro],
    --------------------------
    R[R.zinro],
    R[R.zinro],
    R[R.zinro],
    R[R.zinro],
    R[R.kyosinsya],
    R[R.youko],
    R[R.haitokusya],
    R[R.teruteru],
    R[R.kyoyuusya],
    R[R.kyoyuusya],
    --------------------------
    R[R.kurokisi],
    R[R.nekomata]
}
local MOVE = {
    --入室フラグ
    enter_flg = true,
    --ゲーム初期化関係
    game_before_flg = true,
    game_noon_flg = true,
    game_vote_flg = true,
    --現在参加人数
    player_count = 0,
    --現在参加可能プレイヤー名
    enable_player_name = {},
    --現在参加者
    player_flg = {},
    --操作パネル番号
    operator_act = DATA.str_operator_act_close,
    --役職決定設定
    role_flg = {},
    --オプション役職設定
    option_role_flg = {},
    --役割内容決定
    role_input = {},
    --各プレイヤー役職
    player_role_input = {},
    --各プレイヤー役職
    chose_data = {},
    --各プレイヤー状態
    player_state = {},
    day = 1,
    --ゲームスタートからの時間
    game_clock = -1,
    --減算時間
    day_add = 90,
    --減算最大値
    day_min = (60 * 5 - 2 * 90),
    bairitu = 1
}

--役職カード関係(https://jinro-gm.com/rule/casting-table/)
function RoleInput()
    --各人数ごとの役割表(https://jinro-gm.com/rule/casting-table/)：参考

    if not MOVE.role_flg[DATA.str_role_act_option] then
        if not MOVE.role_flg[DATA.str_role_act_pattern] then
            MOVE.role_input = {
                --1人
                {R[R.zinro]},
                --2人
                {R[R.zinro], R[R.murabito]},
                --3人
                {R[R.zinro], R[R.murabito], R[R.murabito]},
                --4人
                {R[R.zinro], R[R.murabito], R[R.murabito], R[R.uranaisi]},
                --5人
                {R[R.zinro], R[R.murabito], R[R.murabito], R[R.murabito], R[R.uranaisi]},
                --6人
                {R[R.zinro], R[R.murabito], R[R.murabito], R[R.murabito], R[R.murabito], R[R.uranaisi]},
                --7人
                {R[R.zinro], R[R.zinro], R[R.murabito], R[R.murabito], R[R.uranaisi], R[R.kisi], R[R.reibaisi]},
                --8人
                {
                    R[R.zinro],
                    R[R.zinro],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.uranaisi],
                    R[R.kisi],
                    R[R.reibaisi]
                },
                --9人
                {
                    R[R.zinro],
                    R[R.zinro],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.uranaisi],
                    R[R.kisi],
                    R[R.kyozin],
                    R[R.reibaisi]
                },
                --標準はここまで
                --10人
                {
                    R[R.zinro],
                    R[R.zinro],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.uranaisi],
                    R[R.kisi],
                    R[R.reibaisi],
                    R[R.kyozin]
                },
                --11人
                {
                    R[R.zinro],
                    R[R.zinro],
                    R[R.zinro],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.uranaisi],
                    R[R.kisi],
                    R[R.reibaisi]
                },
                --12人
                {
                    R[R.zinro],
                    R[R.zinro],
                    R[R.zinro],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.uranaisi],
                    R[R.kisi],
                    R[R.reibaisi]
                },
                --13人
                {
                    R[R.zinro],
                    R[R.zinro],
                    R[R.zinro],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.uranaisi],
                    R[R.kisi],
                    R[R.reibaisi],
                    R[R.kyozin]
                },
                --14人
                {
                    R[R.zinro],
                    R[R.zinro],
                    R[R.zinro],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.uranaisi],
                    R[R.kisi],
                    R[R.reibaisi],
                    R[R.kyozin]
                },
                --15人
                {
                    R[R.zinro],
                    R[R.zinro],
                    R[R.zinro],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.uranaisi],
                    R[R.kisi],
                    R[R.reibaisi],
                    R[R.kyozin]
                },
                --16人
                {
                    R[R.zinro],
                    R[R.zinro],
                    R[R.zinro],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.uranaisi],
                    R[R.kisi],
                    R[R.reibaisi],
                    R[R.kyozin]
                },
                --17人
                {
                    R[R.zinro],
                    R[R.zinro],
                    R[R.zinro],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.uranaisi],
                    R[R.uranaisi],
                    R[R.kisi],
                    R[R.reibaisi],
                    R[R.kyozin]
                }
            }
            local role = {}
            if MOVE.player_count > 0 then
                if MOVE.role_flg[DATA.str_role_act_chip] then
                    for i = 1, #MOVE.role_input[MOVE.player_count + 1] do
                        role[i] = MOVE.role_input[MOVE.player_count + 1][i]
                    end
                else
                    for i = 1, #MOVE.role_input[MOVE.player_count] do
                        role[i] = MOVE.role_input[MOVE.player_count][i]
                    end
                end
            end
            MOVE.role_input = role
        else
            MOVE.role_input = {
                --1人
                {R[R.zinro]},
                --2人
                {R[R.zinro], R[R.murabito]},
                --3人
                {R[R.zinro], R[R.murabito], R[R.murabito]},
                --4人
                {R[R.zinro], R[R.kisi], R[R.uranaisi], R[R.kyozin]},
                --5人
                {R[R.zinro], R[R.murabito], R[R.kisi], R[R.uranaisi], R[R.kyozin]},
                --6人
                {R[R.zinro], R[R.murabito], R[R.murabito], R[R.uranaisi], R[R.kisi], R[R.kyozin]},
                --7人
                {R[R.zinro], R[R.kyosinsya], R[R.murabito], R[R.murabito], R[R.murabito], R[R.uranaisi], R[R.kisi]},
                --8人
                {
                    R[R.zinro],
                    R[R.zinro],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.uranaisi],
                    R[R.kisi],
                    R[R.reibaisi],
                    R[R.teruteru]
                },
                --9人
                {
                    R[R.zinro],
                    R[R.zinro],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.uranaisi],
                    R[R.kisi],
                    R[R.reibaisi],
                    R[R.youko]
                },
                --標準はここまで
                --10人
                {
                    R[R.zinro],
                    R[R.zinro],
                    R[R.zinro],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.uranaisi],
                    R[R.kisi],
                    R[R.reibaisi],
                    R[R.kyoyuusya],
                    R[R.kyoyuusya]
                },
                --11人
                {
                    R[R.zinro],
                    R[R.zinro],
                    R[R.zinro],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.uranaisi],
                    R[R.kisi],
                    R[R.reibaisi],
                    R[R.kyozin],
                    R[R.kyoyuusya],
                    R[R.kyoyuusya]
                },
                --12人
                {
                    R[R.zinro],
                    R[R.zinro],
                    R[R.zinro],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.uranaisi],
                    R[R.kisi],
                    R[R.reibaisi],
                    R[R.kyozin],
                    R[R.kyoyuusya],
                    R[R.kyoyuusya]
                },
                --13人
                {
                    R[R.zinro],
                    R[R.zinro],
                    R[R.zinro],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.uranaisi],
                    R[R.kisi],
                    R[R.reibaisi],
                    R[R.kyozin],
                    R[R.kyoyuusya],
                    R[R.kyoyuusya],
                    R[R.youko]
                },
                --14人
                {
                    R[R.zinro],
                    R[R.zinro],
                    R[R.zinro],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.uranaisi],
                    R[R.kisi],
                    R[R.reibaisi],
                    R[R.youko]
                },
                --15人
                {
                    R[R.zinro],
                    R[R.zinro],
                    R[R.zinro],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.kyozin],
                    R[R.uranaisi],
                    R[R.kisi],
                    R[R.reibaisi],
                    R[R.youko]
                },
                --16人
                {
                    R[R.zinro],
                    R[R.zinro],
                    R[R.zinro],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.kyozin],
                    R[R.uranaisi],
                    R[R.haitokusya],
                    R[R.kisi],
                    R[R.reibaisi],
                    R[R.youko]
                },
                --17人
                {
                    R[R.zinro],
                    R[R.zinro],
                    R[R.zinro],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.murabito],
                    R[R.kyozin],
                    R[R.uranaisi],
                    R[R.haitokusya],
                    R[R.kisi],
                    R[R.reibaisi],
                    R[R.youko]
                }
            }

            local role = {}
            if MOVE.player_count > 0 then
                if MOVE.role_flg[DATA.str_role_act_chip] then
                    for i = 1, #MOVE.role_input[MOVE.player_count + 1] do
                        role[i] = MOVE.role_input[MOVE.player_count + 1][i]
                    end
                else
                    for i = 1, #MOVE.role_input[MOVE.player_count] do
                        role[i] = MOVE.role_input[MOVE.player_count][i]
                    end
                end
            end
            MOVE.role_input = role
        end
    else
        --フラグついてるのだけ出す
        local count = 1
        MOVE.role_input = {}
        for i = 1, #DATA.str_option_role_act do
            if MOVE.option_role_flg[i] then
                MOVE.role_input[count] = DATA.str_option_role_act[i]
                count = count + 1
            end
        end
    end
end
--役職カード配布関係
function RandFirstData()
    --フラグ付け
    local role_flg = {}
    local player_flg = {}
    if MOVE.role_flg[DATA.str_role_act_chip] then
        for i = 1, MOVE.player_count + 1 do
            role_flg[i] = true
            player_flg[i] = i
        end
        table.remove(player_flg, #player_flg)
    else
        for i = 1, MOVE.player_count do
            role_flg[i] = true
            player_flg[i] = i
        end
    end
    math.randomseed(os.clock())

    local kind_count = {}
    for i = 1, R.role_max do
        kind_count[i] = 1
    end

    --人狼1人確定
    MOVE.player_role_input = {}
    for i = 1, #MOVE.role_input do
        if MOVE.role_input[i].name == R[R.zinro].name then
            role_flg[i] = false
            local rand_num = math.random(1, #player_flg)
            local rand_player = player_flg[rand_num]
            --人に紐付け
            MOVE.player_role_input[rand_player] = MOVE.role_input[i]
            --人に紐付け後削除
            table.remove(player_flg, rand_num)

            for i2 = 1, #kind_count do
                if R[i2].name == MOVE.role_input[i].name then
                    local card = ASSET.GetSubItem(MOVE.role_input[i].name .. tostring(kind_count[i2]))
                    card._ALL_SetActive(true)
                    local set_rot = Quaternion.Euler(0, 360 * (rand_player - 1) / MOVE.player_count, 0)
                    local set_pos = Vector3.zero
                    set_pos.x =
                        DATA.house_def_min_dist +
                        (DATA.house_def_max_dist - DATA.house_def_min_dist) * (MOVE.player_count - 1) /
                            (DATA.player_max - 1) +
                        2
                    set_pos.y = 0.501
                    set_pos.z = 0.5
                    card.SetLocalPosition(set_rot * set_pos)
                    card.SetLocalRotation(set_rot * Quaternion.Euler(90, 0, 0))

                    kind_count[i2] = kind_count[i2] + 1
                    break
                end
            end

            break
        end
    end

    --共有者2人確定
    for i = 1, #MOVE.role_input do
        if MOVE.role_input[i].name == R[R.kyoyuusya].name then
            role_flg[i] = false
            local rand_num = math.random(1, #player_flg)
            local rand_player = player_flg[rand_num]
            --人に紐付け
            MOVE.player_role_input[rand_player] = MOVE.role_input[i]
            --人に紐付け後削除
            table.remove(player_flg, rand_num)

            for i2 = 1, #kind_count do
                if R[i2].name == MOVE.role_input[i].name then
                    local card = ASSET.GetSubItem(MOVE.role_input[i].name .. tostring(kind_count[i2]))
                    card._ALL_SetActive(true)
                    local set_rot = Quaternion.Euler(0, 360 * (rand_player - 1) / MOVE.player_count, 0)
                    local set_pos = Vector3.zero
                    set_pos.x =
                        DATA.house_def_min_dist +
                        (DATA.house_def_max_dist - DATA.house_def_min_dist) * (MOVE.player_count - 1) /
                            (DATA.player_max - 1) +
                        2
                    set_pos.y = 0.501
                    set_pos.z = 0.5
                    card.SetLocalPosition(set_rot * set_pos)
                    card.SetLocalRotation(set_rot * Quaternion.Euler(90, 0, 0))

                    kind_count[i2] = kind_count[i2] + 1
                    break
                end
            end
        end
    end

    --妖狐1人確定
    for i = 1, #MOVE.role_input do
        if MOVE.role_input[i].name == R[R.youko].name then
            role_flg[i] = false
            local rand_num = math.random(1, #player_flg)
            local rand_player = player_flg[rand_num]
            --人に紐付け
            MOVE.player_role_input[rand_player] = MOVE.role_input[i]
            --人に紐付け後削除
            table.remove(player_flg, rand_num)

            for i2 = 1, #kind_count do
                if R[i2].name == MOVE.role_input[i].name then
                    local card = ASSET.GetSubItem(MOVE.role_input[i].name .. tostring(kind_count[i2]))
                    card._ALL_SetActive(true)
                    local set_rot = Quaternion.Euler(0, 360 * (rand_player - 1) / MOVE.player_count, 0)
                    local set_pos = Vector3.zero
                    set_pos.x =
                        DATA.house_def_min_dist +
                        (DATA.house_def_max_dist - DATA.house_def_min_dist) * (MOVE.player_count - 1) /
                            (DATA.player_max - 1) +
                        2
                    set_pos.y = 0.501
                    set_pos.z = 0.5
                    card.SetLocalPosition(set_rot * set_pos)
                    card.SetLocalRotation(set_rot * Quaternion.Euler(90, 0, 0))

                    kind_count[i2] = kind_count[i2] + 1
                    break
                end
            end

            break
        end
    end

    local timer_d = os.clock()
    --その他役職割り当て
    while 1 do
        local rand_role_num = math.random(1, #role_flg)

        --未割当ならば
        if role_flg[rand_role_num] then
            role_flg[rand_role_num] = false
            local rand_num = math.random(1, #player_flg)
            local rand_player = player_flg[rand_num]
            --人に紐付け
            MOVE.player_role_input[rand_player] = MOVE.role_input[rand_role_num]
            --人に紐付け後削除
            table.remove(player_flg, rand_num)
            for i2 = 1, #kind_count do
                if R[i2].name == MOVE.role_input[rand_role_num].name then
                    local card = ASSET.GetSubItem(MOVE.role_input[rand_role_num].name .. tostring(kind_count[i2]))
                    card._ALL_SetActive(true)
                    local set_rot = Quaternion.Euler(0, 360 * (rand_player - 1) / MOVE.player_count, 0)
                    local set_pos = Vector3.zero
                    set_pos.x =
                        DATA.house_def_min_dist +
                        (DATA.house_def_max_dist - DATA.house_def_min_dist) * (MOVE.player_count - 1) /
                            (DATA.player_max - 1) +
                        2
                    set_pos.y = 0.501
                    set_pos.z = 0.5
                    card.SetLocalPosition(set_rot * set_pos)
                    card.SetLocalRotation(set_rot * Quaternion.Euler(90, 0, 0))

                    kind_count[i2] = kind_count[i2] + 1
                    break
                end
            end
        end

        local count = 0
        for i = 1, #role_flg do
            if role_flg[i] == false then
                count = count + 1
            end
            if i == #role_flg then
                if count == MOVE.player_count then
                    return
                end
            end
        end
    end

    if (os.clock() - timer_d) >= (1 / 85) then
        coroutine.yield()
        timer_d = os.clock()
    end
end
function ShowCard()
    local counts = {}

    for i = 1, R.role_max do
        counts[i] = 1
    end
    --カード制御
    for i = 1, R.role_max do
        for i2 = 1, 20 do
            local card = ASSET.GetSubItem(R[i].name .. tostring(i2))
            if card ~= nil then
                card.SetActive(false)
            end
        end
    end
    for i = 1, #MOVE.player_role_input do
        for i2 = 1, R.role_max do
            if MOVE.player_role_input[i].name == R[i2].name then
                local card = ASSET.GetSubItem(R[i2].name .. tostring(counts[i2]))
                card._ALL_SetActive(true)
                counts[i2] = counts[i2] + 1
            end
        end
    end
end
--サブアイテム
for i = 1, #DATA.str do
    DATA.str_si[i] = {}
    for i2 = 1, DATA.player_max do
        DATA.str_si[i][i2] = ASSET.GetSubItem(DATA.str[i] .. tostring(i2))
    end
end
for i = 1, #DATA.str_clock do
    DATA.str_clock_si[i] = ASSET.GetSubItem(DATA.str_clock[i])
end
for i = 1, #DATA.str_operator do
    DATA.str_operator_si[i] = {}
    for i2 = 1, DATA.operator_max do
        DATA.str_operator_si[i][i2] = ASSET.GetSubItem(DATA.str_operator[i] .. tostring(i2))
    end
end
for i = 1, #DATA.str_operator_act do
    DATA.str_operator_act_si[i] = ASSET.GetSubItem(DATA.str_operator_act[i])
end

--時間処理
local timer = 0
local timer_count = 1 / 10
function updateAll()
    if (os.clock() - timer) > timer_count then
        if MOVE.enter_flg then
            --変数操作
            for i = 1, DATA.operator_max do
                MOVE.option_role_flg[i] = false
            end
            for i = 1, DATA.operator_player_max do
                MOVE.enable_player_name[i] = ""
                MOVE.player_flg[i] = false
                if i == DATA.operator_player_max then
                    MOVE.enable_player_name[i] = "名称再取得\nゲームリセット"
                elseif i == DATA.operator_player_max - 1 then
                    MOVE.enable_player_name[i] = "ゲームスタート"
                end
            end

            --初期化
            for i3 = 1, DATA.player_max do
                ASSET.SetText("役職行動" .. tostring(i3), "")
            end
            for i = 1, DATA.player_max do
                MOVE.player_state[i] = false
                MOVE.chose_data[i] = 0
            end
            for i = 1, #DATA.str_role_act do
                MOVE.role_flg[i] = false
            end
            OperatorShowFunc()
            ShowCard()
            --初期化
            for i3 = 1, DATA.player_max do
                ASSET.SetText("役職行動" .. tostring(i3), "")
            end
            --初期化処理
            vci.message.EmitWithId(ASHU_MESS .. "SYNC", -1, ASSET.GetInstanceId())
        end

        timer = os.clock()
    end
end

function onUse(use)
    if not MOVE.enter_flg then
        for i = 2, DATA.str_operator_act_option do
            if use == DATA.str_operator_act_si[i].GetName() then
                MOVE.operator_act = i
                vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(1), ASSET.GetInstanceId())
                break
            end
        end

        --操作盤番号
        if MOVE.operator_act == DATA.str_operator_act_join then
            for i = 1, DATA.operator_player_max do
                --最低限文言があるやつのみ押せる
                if MOVE.enable_player_name[i] ~= "" then
                    if use == DATA.str_operator_si[DATA.str_operator_num][i].GetName() then
                        --最終データのリセット/取得ならば
                        if i == DATA.operator_player_max then
                            vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(2), ASSET.GetInstanceId())
                            break
                        elseif i == DATA.operator_player_max - 1 then
                            if MOVE.player_count >= DATA.player_min then
                                --役職オプションオンである
                                if MOVE.role_flg[DATA.str_role_act_option] then
                                    --オプション役職人数と現在人数比較
                                    local count = 0
                                    local human_count = 0
                                    local zinro_count = 0
                                    local youko_count = 0
                                    local haitokusya_count = 0
                                    for i = 1, #MOVE.option_role_flg do
                                        if MOVE.option_role_flg[i] then
                                            count = count + 1
                                            for i2 = 1, R.role_max do
                                                if DATA.str_option_role_act[i].name == R[i2].name then
                                                    if R[i2].ookami then
                                                        zinro_count = zinro_count + 1
                                                    elseif R[i2].kitune then
                                                        youko_count = youko_count + 1
                                                    else
                                                        if R[i2].name == R[R.haitokusya].name then
                                                            haitokusya_count = haitokusya_count + 1
                                                            human_count = human_count + 1
                                                        --elseif R[i2].name == R[R.teruteru].name then
                                                        --elseif R[i2].name == R[R.kyosinsya].name then
                                                        --elseif R[i2].name == R[R.kyozin].name then
                                                        else
                                                            human_count = human_count + 1
                                                        end
                                                    end
                                                    break
                                                end
                                            end
                                        end
                                    end

                                    --欠けありならば
                                    if MOVE.role_flg[DATA.str_role_act_chip] then
                                        count = count - 1
                                    end

                                    --人数比較
                                    if count == MOVE.player_count then
                                        if (haitokusya_count > 0) and (youko_count == 0) then
                                            ASSET.audio._ALL_Play("狐いない", 0.35, false)
                                            break
                                        end
                                        if zinro_count >= human_count then
                                            ASSET.audio._ALL_Play("人狼多い", 0.35, false)
                                            break
                                        end
                                        if zinro_count == 0 then
                                            ASSET.audio._ALL_Play("役職数不足", 0.35, false)
                                            break
                                        end
                                        vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(7), ASSET.GetInstanceId())
                                        ASSET.audio._ALL_Play("人狼開始", 0.35, false)
                                        break
                                    elseif count < MOVE.player_count then
                                        ASSET.audio._ALL_Play("役職数不足", 0.35, false)
                                        break
                                    elseif count > MOVE.player_count then
                                        ASSET.audio._ALL_Play("役職数多い", 0.35, false)
                                        break
                                    end
                                else
                                    vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(7), ASSET.GetInstanceId())
                                    ASSET.audio._ALL_Play("人狼開始", 0.35, false)
                                    break
                                end
                            else
                                ASSET.audio._ALL_Play("人数が足りない", 0.35, false)
                                break
                            end
                        end

                        --ゲーム開始前ならば押せる
                        if MOVE.game_clock < 0 then
                            --参加が多い場合抜ける
                            MOVE.player_flg[i] = not MOVE.player_flg[i]
                            --参加人数把握
                            local count = 0
                            for i = 1, DATA.operator_max do
                                if MOVE.player_flg[i] then
                                    count = count + 1
                                end
                            end
                            if count > DATA.game_player_max then
                                MOVE.player_flg[i] = not MOVE.player_flg[i]
                                break
                            end

                            --人選択
                            vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(4), ASSET.GetInstanceId())
                        end
                    end
                end
            end
        elseif MOVE.operator_act == DATA.str_operator_act_option then
            --ゲーム開始前ならば押せる
            if MOVE.game_clock < 0 then
                for i = 1, #DATA.str_option_role_act do
                    if use == DATA.str_operator_si[DATA.str_operator_num][i].GetName() then
                        --共有者は2人一気に
                        if DATA.str_option_role_act[i].name == R[R.kyoyuusya].name then
                            if i > 1 then
                                --共有者は2人一気に
                                if DATA.str_option_role_act[i - 1].name == R[R.kyoyuusya].name then
                                    MOVE.option_role_flg[i - 1] = not MOVE.option_role_flg[i - 1]
                                end
                            end
                            if i < #DATA.str_option_role_act then
                                --共有者は2人一気に
                                if DATA.str_option_role_act[i + 1].name == R[R.kyoyuusya].name then
                                    MOVE.option_role_flg[i + 1] = not MOVE.option_role_flg[i + 1]
                                end
                            end
                        end

                        --役職選択
                        MOVE.option_role_flg[i] = not MOVE.option_role_flg[i]
                        vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(5), ASSET.GetInstanceId())
                    end
                end
            end
        elseif MOVE.operator_act == DATA.str_operator_act_role then
            --ゲーム開始前ならば押せる
            if MOVE.game_clock < 0 then
                for i = 1, #DATA.str_role_act do
                    if use == DATA.str_operator_si[DATA.str_operator_num][i].GetName() then
                        --役職選択
                        MOVE.role_flg[i] = not MOVE.role_flg[i]
                        if (i >= DATA.str_role_act_timer2) and (i <= DATA.str_role_act_timer8) then
                            for i2 = DATA.str_role_act_timer2, DATA.str_role_act_timer8 do
                                if i ~= i2 then
                                    MOVE.role_flg[i2] = false
                                end
                            end
                        end
                        vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(6), ASSET.GetInstanceId())
                    end
                end
            end

        end
    end
end

function onCollisionEnter(item, hit)
    print(item)
    print(hit)
    print("---------------")
end

function onTriggerEnter(item, hit)
    --print(item)
    --print(hit)
    --print("---------------")
    for i = 1, DATA.player_max do
        if MOVE.player_state[i] then
            local yazirushi = DATA.str_si[DATA.str_yazirushi_num][i]
            if (yazirushi.GetName() == item) or (yazirushi.GetName() == hit) then
                for i2 = 1, #MOVE.player_state do
                    --自分以外かつ、生きている場合選択可能
                    if (i2 ~= i) and (MOVE.player_state[i2]) then
                        local touhyou = "投票用" .. tostring(i) .. "_" .. tostring(i2)
                        if (touhyou == item) or (touhyou == hit) then
                            vci.message.EmitWithId(
                                ASHU_MESS .. "SYNC",
                                {num = 9, player_house = i, chose = i2},
                                ASSET.GetInstanceId()
                            )
                        end
                    end
                end
            end
        end
    end
end

function onGrab(use)
    OperatorShowFunc()
end

--カード表示関係
vci.StartCoroutine(
    coroutine.create(
        function()
            local operater_si = DATA.str_operator_act_si[DATA.str_operator_act_operator]
            local timer_si = DATA.str_clock_si[DATA.str_clock_timer]
            local hozi_clock = 0
            while 1 do
                --時計回転
                if not MOVE.role_flg[DATA.str_role_act_timer_rot] then
                    if timer_si.IsMine then
                        local timer_rot = timer_si.GetRotation()
                        timer_rot.ToEuler()
                        timer_rot.y = timer_rot.y + os.clock() * 75
                        local est_rot = Quaternion.Euler(0, timer_rot.y, 0)
                        timer_si.SetRotation(est_rot)
                    end
                end

                if MOVE.game_clock >= 0 then
                    --ゲーム初期化
                    if (MOVE.game_clock == 0) and (operater_si.IsMine) then
                        RoleInput()
                        --ランダム配置
                        RandFirstData()
                        vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(8), ASSET.GetInstanceId())
                    else
                        MOVE.game_clock = MOVE.game_clock + os.clock() - hozi_clock
                        if (MOVE.game_clock < DATA.game_start_timer / MOVE.bairitu) then
                            Clock()
                            --わかる為
                            if MOVE.player_role_input[1] ~= nil then
                                KyousinsyaShow()
                                HaitokusyaShow()
                                OokamiVoteShow()
                                KyouyuusyaShow()
                            end
                        else
                            if MOVE.game_before_flg then
                                --スタートする
                                if MOVE.game_noon_flg then
                                    if MOVE.game_clock >= 5 then
                                        if operater_si.IsMine then
                                            --初日占いあり
                                            FirstDayFortune()
                                        end
                                        ASSET.audio.Play("投票朝", 0.35, false)
                                    end
                                    MOVE.game_noon_flg = false
                                else
                                    --ゲーム開始
                                    if not DayClock(false) then
                                        HouseShowFunc(true)
                                    end

                                    --わかる為
                                    KyousinsyaShow()
                                    HaitokusyaShow()
                                    OokamiVoteShow()
                                    KyouyuusyaShow()

                                    if operater_si.IsMine then
                                        --投票検索
                                        for i = 1, MOVE.player_count do
                                            --選んでいない人がいる、生きていれば
                                            if (MOVE.chose_data[i] == 0) and (MOVE.player_state[i]) then
                                                break
                                            end

                                            if i == MOVE.player_count then
                                                local dousuu = false
                                                local counts = {}
                                                for i = 1, DATA.player_max do
                                                    counts[i] = 0
                                                end
                                                for i = 1, DATA.player_max do
                                                    if MOVE.chose_data[i] ~= 0 then
                                                        counts[MOVE.chose_data[i]] = counts[MOVE.chose_data[i]] + 1
                                                    end
                                                end
                                                local max = 0
                                                local max_num = 0
                                                for i = 1, DATA.player_max do
                                                    if max < counts[i] then
                                                        max = counts[i]
                                                        max_num = i
                                                    end
                                                end
                                                for i = 1, DATA.player_max do
                                                    if i ~= max_num then
                                                        if max == counts[i] then
                                                            ASSET.audio._ALL_Play("投票同数", 0.35, false)
                                                            vci.message.EmitWithId(
                                                                ASHU_MESS .. "SYNC",
                                                                Sync(12),
                                                                ASSET.GetInstanceId()
                                                            )
                                                            dousuu = true
                                                        end
                                                    end
                                                end

                                                if not dousuu then
                                                    --死亡判定(吊り)
                                                    MOVE.player_state[max_num] = false
                                                    --狐の処理
                                                    if MOVE.player_role_input[max_num].kitune then
                                                        --背徳者の処理
                                                        for i4 = 1, #MOVE.player_role_input do
                                                            if MOVE.player_state[i4] then
                                                                if
                                                                    MOVE.player_role_input[i4].name ==
                                                                        R[R.haitokusya].name
                                                                 then
                                                                    MOVE.player_state[i4] = false
                                                                end
                                                            end
                                                        end
                                                    end

                                                    --猫又全員道連れ
                                                    if MOVE.player_role_input[max_num].name == R[R.nekomata].name then
                                                        NekomataVoteShow(true)
                                                        ASSET.audio.Play("猫又蜜連れ", 0.35, false)
                                                    end
                                                    --霊媒師処理
                                                    ReibaisiVoteShow(max_num)
                                                    local flg = true
                                                    --てるてる勝利
                                                    if MOVE.player_role_input[max_num].name == R[R.teruteru].name then
                                                        if MOVE.player_count <= 4 then
                                                            if MOVE.day >= 1 then
                                                                ASSET.audio.Play("てるてる勝利", 0.35, false)
                                                                ASSET._ALL_SetText(
                                                                    DATA.str_clock_si[DATA.str_clock_clock].GetName(),
                                                                    "てるてる勝利"
                                                                )
                                                                flg = false
                                                            end
                                                        elseif MOVE.player_count <= 6 then
                                                            if MOVE.day >= 2 then
                                                                ASSET.audio.Play("てるてる勝利", 0.35, false)
                                                                ASSET._ALL_SetText(
                                                                    DATA.str_clock_si[DATA.str_clock_clock].GetName(),
                                                                    "てるてる勝利"
                                                                )
                                                                flg = false
                                                            end
                                                        elseif MOVE.player_count <= 10 then
                                                            if MOVE.day >= 3 then
                                                                ASSET.audio.Play("てるてる勝利", 0.35, false)
                                                                ASSET._ALL_SetText(
                                                                    DATA.str_clock_si[DATA.str_clock_clock].GetName(),
                                                                    "てるてる勝利"
                                                                )
                                                                flg = false
                                                            end
                                                        elseif MOVE.player_count <= 16 then
                                                            if MOVE.day >= 4 then
                                                                ASSET.audio.Play("てるてる勝利", 0.35, false)
                                                                ASSET._ALL_SetText(
                                                                    DATA.str_clock_si[DATA.str_clock_clock].GetName(),
                                                                    "てるてる勝利"
                                                                )
                                                                flg = false
                                                            end
                                                        end
                                                        vci.message.EmitWithId(
                                                            ASHU_MESS .. "SYNC",
                                                            Sync(13),
                                                            ASSET.GetInstanceId()
                                                        )
                                                        hozi_clock = os.clock()
                                                        coroutine.yield()
                                                    end
                                                    if flg then
                                                        --夜になる
                                                        vci.message.EmitWithId(
                                                            ASHU_MESS .. "SYNC",
                                                            Sync(11),
                                                            ASSET.GetInstanceId()
                                                        )
                                                        coroutine.yield()
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            else
                                --スタートする
                                if
                                    MOVE.game_noon_flg and
                                        (MOVE.game_clock >= (DATA.game_start_timer + 5) / MOVE.bairitu)
                                 then
                                    ASSET.audio.Play("夜行動", 0.35, false)
                                    MOVE.game_noon_flg = false
                                    HouseShowFunc(true)
                                else
                                    --狼投票中見えるように
                                    local death_player = OokamiVoteShow()
                                    local difend_player = KisiVoteShow()
                                    local difend_player2 = KuroKisiVoteShow()
                                    --わかる為
                                    KyousinsyaShow()
                                    HaitokusyaShow()
                                    OokamiVoteShow()
                                    KyouyuusyaShow()

                                    --ゲーム開始
                                    if
                                        NightClock(false) and
                                            (MOVE.game_clock >=
                                                (DATA.game_start_timer + DATA.Nightime + 5) / MOVE.bairitu)
                                     then
                                        if operater_si.IsMine then
                                            --勝敗
                                            if Victry() then
                                                --日数追加
                                                MOVE.day = MOVE.day + 1
                                                vci.message.EmitWithId(
                                                    ASHU_MESS .. "SYNC",
                                                    Sync(13),
                                                    ASSET.GetInstanceId()
                                                )
                                                hozi_clock = os.clock()
                                                coroutine.yield()
                                            else
                                                --投票検索
                                                for i = 1, MOVE.player_count do
                                                    --選んでいない人がいる
                                                    local active = true
                                                    --行動できない人は飛ばす
                                                    if not MOVE.player_role_input[i].night_act then
                                                        active = false
                                                    end
                                                    --行動可能かつ選んでいないならばぬける、生きているならば
                                                    if active and (MOVE.chose_data[i] == 0) and (MOVE.player_state[i]) then
                                                        break
                                                    end

                                                    if i == MOVE.player_count then
                                                        --妖狐は人狼で死なない
                                                        if MOVE.player_role_input[death_player].kitune then
                                                            death_player = 0
                                                        end
                                                        --騎士が守れた
                                                        if death_player == difend_player then
                                                            death_player = 0
                                                        end
                                                        --黒騎士が守れた
                                                        if death_player == difend_player2 then
                                                            death_player = 0
                                                        end

                                                        --騎士が守れなかった場合
                                                        if death_player ~= 0 then
                                                            --狼による死亡判定
                                                            MOVE.player_state[death_player] = false
                                                            if MOVE.player_role_input[death_player].kitune then
                                                                --背徳者の処理
                                                                for i4 = 1, #MOVE.player_role_input do
                                                                    if MOVE.player_state[i4] then
                                                                        if
                                                                            MOVE.player_role_input[i4].name ==
                                                                                R[R.haitokusya].name
                                                                         then
                                                                            MOVE.player_state[i4] = false
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                            --猫又狼道連れ
                                                            if
                                                                MOVE.player_role_input[death_player].name ==
                                                                    R[R.nekomata].name
                                                             then
                                                                NekomataVoteShow(false)
                                                                ASSET.audio.Play("猫又蜜連れ", 0.35, false)
                                                            end
                                                        end

                                                        --占い師
                                                        FortuneVote()

                                                        --日数追加
                                                        MOVE.day = MOVE.day + 1

                                                        --朝になる
                                                        vci.message.EmitWithId(
                                                            ASHU_MESS .. "SYNC",
                                                            Sync(11),
                                                            ASSET.GetInstanceId()
                                                        )
                                                        hozi_clock = os.clock()
                                                        coroutine.yield()
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end

                hozi_clock = os.clock()
                coroutine.yield()
            end
        end
    )
)

--勝敗
function Victry()
    local ookami_count = 0
    local human_count = 0
    local youko_count = 0
    for i = 1, #MOVE.player_role_input do
        --生きている
        if MOVE.player_state[i] then
            --狼である
            if MOVE.player_role_input[i].ookami then
                ookami_count = ookami_count + 1
            elseif not MOVE.player_role_input[i].ookami then
                if MOVE.player_role_input[i].kitune then
                    youko_count = youko_count + 1
                --elseif MOVE.player_role_input[i].name == R[R.haitokusya].name then
                --elseif MOVE.player_role_input[i].name == R[R.teruteru].name then
                --elseif MOVE.player_role_input[i].name == R[R.kyosinsya].name then
                --elseif MOVE.player_role_input[i].name == R[R.kyozin].name then
                else
                    human_count = human_count + 1
                end
            end
        end
    end

    --村人勝利
    if ookami_count == 0 then
        if youko_count > 0 then
            ASSET.audio._ALL_Stop("夜行動")
            ASSET.audio._ALL_Stop("役職投票")
            ASSET.audio._ALL_Play("妖狐勝利", 0.35, false)
            ASSET._ALL_SetText(DATA.str_clock_si[DATA.str_clock_clock].GetName(), "妖狐勝利")
            return true
        end
        ASSET.audio._ALL_Stop("夜行動")
        ASSET.audio._ALL_Stop("役職投票")
        ASSET.audio._ALL_Play("村人勝利", 0.35, false)
        ASSET._ALL_SetText(DATA.str_clock_si[DATA.str_clock_clock].GetName(), "村人勝利")
        return true
    elseif ookami_count >= human_count then
        if youko_count > 0 then
            ASSET.audio._ALL_Stop("夜行動")
            ASSET.audio._ALL_Stop("役職投票")
            ASSET.audio._ALL_Play("妖狐勝利", 0.35, false)
            ASSET._ALL_SetText(DATA.str_clock_si[DATA.str_clock_clock].GetName(), "妖狐勝利")
            return true
        end
        ASSET.audio._ALL_Stop("夜行動")
        ASSET.audio._ALL_Stop("役職投票")
        ASSET.audio._ALL_Play("狼勝利", 0.35, false)
        ASSET._ALL_SetText(DATA.str_clock_si[DATA.str_clock_clock].GetName(), "狼勝利")
        return true
    end

    return false
end

--初日占い
function FirstDayFortune()
    if not MOVE.role_flg[DATA.str_role_act_fortune] then
        for i = 1, MOVE.player_count do
            --占い師がいる(生きている)
            if (MOVE.player_role_input[i].name == R[R.uranaisi].name) and (MOVE.player_state[i]) then
                --手動で準備中に判定在りか、1日目のみ
                if (MOVE.chose_data[i] ~= 0) and (MOVE.role_flg[MOVE.str_role_act_fortune_hand]) and (MOVE.day == 1) then
                    local count = 1
                    local str = ""
                    local enable_count = MOVE.chose_data[i]
                    for i3 = 1, DATA.operator_player_max do
                        if MOVE.player_flg[i3] then
                            if count == enable_count then
                                str = MOVE.enable_player_name[i3] .. ":"
                                if MOVE.player_role_input[enable_count].fortune_result then
                                    str = str .. "\n黒"
                                else
                                    --狐の処理
                                    if MOVE.player_role_input[count].kitune then
                                        MOVE.player_state[count] = false
                                        --背徳者の処理
                                        for i4 = 1, #MOVE.player_role_input do
                                            if MOVE.player_state[i4] then
                                                if MOVE.player_role_input[i4].name == R[R.haitokusya].name then
                                                    MOVE.player_state[i4] = false
                                                end
                                            end
                                        end
                                    end
                                    str = str .. "\n白"
                                end

                                ASSET._ALL_SetText("役職行動" .. tostring(i), str)
                                break
                            end
                            count = count + 1
                        end
                    end
                elseif (MOVE.day == 1) then
                    --占えるやつがいるかどうか
                    local fortune_enable = {}
                    local enable_count = 1
                    for i2 = 1, MOVE.player_count do
                        if MOVE.player_role_input[i2].first_fortune then
                            if i2 ~= i then
                                fortune_enable[enable_count] = i2
                                enable_count = enable_count + 1
                            end
                        end
                    end

                    --占えるやつがいた場合
                    if #fortune_enable > 0 then
                        local rand_num = math.random(1, #fortune_enable)
                        local rand = fortune_enable[rand_num]
                        local count = 1
                        local str = ""
                        for i3 = 1, DATA.operator_player_max do
                            if MOVE.player_flg[i3] then
                                if count == rand then
                                    str = MOVE.enable_player_name[i3] .. ":"
                                    if MOVE.player_role_input[count].fortune_result then
                                        str = str .. "\n黒"
                                    else
                                        --狐の処理
                                        if MOVE.player_role_input[count].kitune then
                                            MOVE.player_state[count] = false
                                            --背徳者の処理
                                            for i4 = 1, #MOVE.player_role_input do
                                                if MOVE.player_state[i4] then
                                                    if MOVE.player_role_input[i4].name == R[R.haitokusya].name then
                                                        MOVE.player_state[i4] = false
                                                    end
                                                end
                                            end
                                        end
                                        str = str .. "\n白"
                                    end

                                    ASSET._ALL_SetText("役職行動" .. tostring(i), str)
                                    break
                                end
                                count = count + 1
                            end
                        end
                    end
                end
                break
            end
        end
    end
end

function FortuneVote()
    for i = 1, MOVE.player_count do
        --占い師がいる(生きている)
        if (MOVE.player_role_input[i].name == R[R.uranaisi].name) and (MOVE.player_state[i]) then
            --手動で準備中に判定在りか、1日目のみ
            if (MOVE.chose_data[i] ~= 0) then
                local count = 1
                local str = ""
                local enable_count = MOVE.chose_data[i]
                for i3 = 1, DATA.operator_player_max do
                    if MOVE.player_flg[i3] then
                        if count == enable_count then
                            str = MOVE.enable_player_name[i3]
                            str = str .. ":"
                            if MOVE.player_role_input[enable_count].fortune_result then
                                str = str .. "\n黒"
                            else
                                --狐の処理
                                if MOVE.player_role_input[count].kitune then
                                    MOVE.player_state[count] = false
                                    --背徳者の処理
                                    for i4 = 1, #MOVE.player_role_input do
                                        if MOVE.player_state[i4] then
                                            if MOVE.player_role_input[i4].name == R[R.haitokusya].name then
                                                MOVE.player_state[i4] = false
                                            end
                                        end
                                    end
                                end
                                str = str .. "\n白"
                            end

                            ASSET._ALL_SetText("役職行動" .. tostring(i), str)
                            break
                        end
                        count = count + 1
                    end
                end
                break
            end
            break
        end
    end
end

--狂信者が人狼わかる
function KyousinsyaShow()
    for i = 1, #MOVE.player_role_input do
        --狂信者がいる
        if (MOVE.player_role_input[i].name == R[R.kyosinsya].name) then
            local count = 1
            local str = ""
            for i3 = 1, DATA.operator_player_max do
                if MOVE.player_flg[i3] then
                    if MOVE.player_role_input[count].ookami then
                        str = str .. MOVE.enable_player_name[i3] .. ":黒\n"
                    end
                    count = count + 1
                end
            end
            ASSET._ALL_SetText("役職行動" .. tostring(i), str)
        end
    end
end

--背徳者が狐わかる
function HaitokusyaShow()
    for i = 1, #MOVE.player_role_input do
        --狂信者がいる
        if (MOVE.player_role_input[i].name == R[R.haitokusya].name) then
            local count = 1
            local str = ""
            for i3 = 1, DATA.operator_player_max do
                if MOVE.player_flg[i3] then
                    if MOVE.player_role_input[count].kitune then
                        str = str .. MOVE.enable_player_name[i3] .. ":狐\n"
                    end
                    count = count + 1
                end
            end
            ASSET._ALL_SetText("役職行動" .. tostring(i), str)
        end
    end
end

--共有者が共有者わかる
function KyouyuusyaShow()
    for i = 1, #MOVE.player_role_input do
        --共有者がいる
        if (MOVE.player_role_input[i].name == R[R.kyoyuusya].name) then
            local count = 1
            local str = ""
            for i3 = 1, DATA.operator_player_max do
                if MOVE.player_flg[i3] then
                    if MOVE.player_role_input[count].name == R[R.kyoyuusya].name then
                        str = str .. MOVE.enable_player_name[i3] .. ":共有者\n"
                    end
                    count = count + 1
                end
            end
            ASSET._ALL_SetText("役職行動" .. tostring(i), str)
        end
    end
end

--狼投票中見えるように
function OokamiVoteShow()
    local max_count = {}
    for i = 1, DATA.player_max do
        max_count[i] = 0
    end

    local count2 = 1
    --投票人物表示用
    local str = ""
    for i = 1, DATA.operator_player_max do
        if MOVE.player_flg[i] then
            --人狼がいる(生きている)
            if (MOVE.player_role_input[count2].name == R[R.zinro].name) and (MOVE.player_state[count2]) then
                str = str .. MOVE.enable_player_name[i] .. ":"
                if (MOVE.chose_data[count2] ~= 0) then
                    local count = 1
                    local enable_count = MOVE.chose_data[count2]
                    for i3 = 1, DATA.operator_player_max do
                        if MOVE.player_flg[i3] then
                            if count == enable_count then
                                str = str .. MOVE.enable_player_name[i3] .. "\n"
                                max_count[count] = max_count[count] + 1
                                break
                            end
                            count = count + 1
                        end
                    end
                else
                    str = str .. "未投票\n"
                end
            end
            count2 = count2 + 1
        end
    end
    count2 = 1
    for i = 1, DATA.operator_player_max do
        if MOVE.player_flg[i] then
            --人狼がいる(生きている)
            if (MOVE.player_role_input[count2].name == R[R.zinro].name) then
                ASSET._ALL_SetText("役職行動" .. tostring(count2), str)
            end
            count2 = count2 + 1
        end
    end

    local max = 0
    local max_num = 0
    for i = 1, DATA.player_max do
        if max < max_count[i] then
            max = max_count[i]
            max_num = i
        end
    end
    for i = 1, DATA.player_max do
        if i ~= max_num then
            if max == max_count[i] then
                --同数なので何もない0を返す
                return 0
            end
        end
    end

    --最大投票者を返す(投票なしも0)
    return max_num
end

--騎士投票中見えるように
function KisiVoteShow()
    local max_count = 0
    local count2 = 1
    for i = 1, DATA.operator_player_max do
        if MOVE.player_flg[i] then
            --騎士がいる(生きている)
            if (MOVE.player_role_input[count2].name == R[R.kisi].name) and (MOVE.player_state[count2]) then
                --投票人物表示用
                local str = MOVE.enable_player_name[i] .. ":"
                if (MOVE.chose_data[count2] ~= 0) then
                    local count = 1
                    local enable_count = MOVE.chose_data[count2]
                    for i3 = 1, DATA.operator_player_max do
                        if MOVE.player_flg[i3] then
                            if count == enable_count then
                                str = str .. MOVE.enable_player_name[i3] .. "\n"
                                max_count = count
                                break
                            end
                            count = count + 1
                        end
                    end
                else
                    str = str .. "未投票\n"
                end
                ASSET._ALL_SetText("役職行動" .. tostring(count2), str)
                break
            end
            count2 = count2 + 1
        end
    end

    --最大投票者を返す(投票なしも0)
    return max_count
end

--黒騎士投票中見えるように
function KuroKisiVoteShow()
    local max_count = 0
    local count2 = 1
    for i = 1, DATA.operator_player_max do
        if MOVE.player_flg[i] then
            --黒騎士がいる(生きている)
            if (MOVE.player_role_input[count2].name == R[R.kurokisi].name) and (MOVE.player_state[count2]) then
                --投票人物表示用
                local str = MOVE.enable_player_name[i] .. ":"
                if (MOVE.chose_data[count2] ~= 0) then
                    local count = 1
                    local enable_count = MOVE.chose_data[count2]
                    for i3 = 1, DATA.operator_player_max do
                        if MOVE.player_flg[i3] then
                            if count == enable_count then
                                str = str .. MOVE.enable_player_name[i3] .. "\n"
                                max_count = count
                                break
                            end
                            count = count + 1
                        end
                    end
                else
                    str = str .. "未投票\n"
                end
                ASSET._ALL_SetText("役職行動" .. tostring(count2), str)
                break
            end
            count2 = count2 + 1
        end
    end

    --最大投票者を返す(投票なしも0)
    return max_count
end

--猫又道ずれ処理
function NekomataVoteShow(flg)
    local max_count = 0
    local count2 = 1
    for i = 1, DATA.operator_player_max do
        if MOVE.player_flg[i] then
            --猫又がいる(今死んだ)
            if (MOVE.player_role_input[count2].name == R[R.nekomata].name) then
                --フラグ付け
                local role_flg = {}
                local player_flg = {}
                local hosei = 0
                if MOVE.role_flg[DATA.str_role_act_chip] then
                    hosei = 1
                    for i = 1, MOVE.player_count + 1 do
                        role_flg[i] = true
                        player_flg[i] = i
                    end
                else
                    hosei = 0
                    for i = 1, MOVE.player_count do
                        role_flg[i] = true
                        player_flg[i] = i
                    end
                end
                math.randomseed(os.clock())

                local count = 1
                --1人確定
                for i = 1, #MOVE.role_input do
                    --生きている人で
                    if MOVE.player_state[i] then
                        --人狼か全員
                        if (MOVE.player_role_input[i].name == R[R.zinro].name) or flg then
                            player_flg[count] = i
                            count = count + 1
                        end
                    end
                end
                --1人確定
                local rand_num = math.random(1, #player_flg)
                local rand_player = player_flg[rand_num]
                --人に紐付け
                MOVE.player_state[rand_player] = false

                if MOVE.player_role_input[rand_player].kitune then
                    --背徳者の処理
                    for i4 = 1, #MOVE.player_role_input do
                        if MOVE.player_state[i4] then
                            if MOVE.player_role_input[i4].name == R[R.haitokusya].name then
                                MOVE.player_state[i4] = false
                            end
                        end
                    end
                end
            end
            count2 = count2 + 1
        end
    end
end

--霊媒師投票中見えるように
function ReibaisiVoteShow(death_player)
    for i = 1, #MOVE.player_role_input do
        --霊媒師がいる(生きている)
        if (MOVE.player_role_input[i].name == R[R.reibaisi].name) and (MOVE.player_state[i]) then
            --投票人物表示用
            local count = 1
            local enable_count = death_player
            for i3 = 1, DATA.operator_player_max do
                if MOVE.player_flg[i3] then
                    if count == enable_count then
                        local str = MOVE.enable_player_name[i3] .. ":"
                        if MOVE.player_role_input[enable_count].fortune_result then
                            str = str .. "\n黒"
                        else
                            str = str .. "\n白"
                        end

                        ASSET._ALL_SetText("役職行動" .. tostring(i), str)
                        break
                    end
                    count = count + 1
                end
            end
        end
    end
end

--生死判定
function LiveAndDie()
    for i = 1, DATA.player_max do
        if MOVE.player_state[i] then
            ASSET.material.SetColor("投票用" .. tostring(i), CHOSE_COL)
        else
            ASSET.material.SetColor("投票用" .. tostring(i), DEATH_COL)
        end
    end
end

--家表示処理
function HouseShowFunc(flg)
    if not flg then
        local count = 1
        --部屋名指定
        for i = 1, DATA.operator_player_max - 2 do
            if MOVE.player_flg[i] then
                ASSET.SetText(DATA.str[DATA.str_house_name_num] .. tostring(count), MOVE.enable_player_name[i])
                count = count + 1
            end
        end
    end

    --家関係
    for i = 1, DATA.player_max do
        local house = DATA.str_si[DATA.str_house_num][i]
        local yazirushi = DATA.str_si[DATA.str_yazirushi_num][i]
        if MOVE.player_count >= i then
            if not flg then
                house.SetActive(true)

                local set_rot = Quaternion.Euler(0, 360 * (i - 1) / MOVE.player_count, 0)
                local set_pos = Vector3.zero
                set_pos.x =
                    DATA.house_def_min_dist +
                    (DATA.house_def_max_dist - DATA.house_def_min_dist) * (MOVE.player_count - 1) /
                        (DATA.player_max - 1)

                house.SetLocalPosition(set_rot * set_pos)
                house.SetLocalRotation(set_rot)

                for i2 = 1, DATA.player_max do
                    local touhyou = ASSET.GetSubItem("投票用" .. tostring(i) .. "_" .. tostring(i2))
                    if MOVE.player_count >= i2 then
                        touhyou.SetActive(true)
                    else
                        touhyou.SetActive(false)
                    end
                end
            end
            yazirushi.SetActive(true)
            if yazirushi.IsMine then
                local set_rot = Quaternion.Euler(0, 360 * (i - 1) / MOVE.player_count, 0)
                local set_pos = Vector3.zero
                set_pos.x =
                    DATA.house_def_min_dist +
                    (DATA.house_def_max_dist - DATA.house_def_min_dist) * (MOVE.player_count - 1) /
                        (DATA.player_max - 1) +
                    2
                set_pos.y = 0.64
                set_pos.z = 0.5
                yazirushi.SetLocalPosition(set_rot * set_pos)
                yazirushi.SetLocalRotation(set_rot * Quaternion.Euler(90, 0, 0))
            end
        else
            if not flg then
                house.SetActive(false)
                yazirushi.SetActive(false)

                for i2 = 1, DATA.player_max do
                    local touhyou = ASSET.GetSubItem("投票用" .. tostring(i) .. "_" .. tostring(i2))
                    touhyou.SetActive(false)
                end
            end
        end
    end
end

--操作盤表示処理関係
function OperatorShowFunc()
    local mozi = ""
    if MOVE.role_flg[DATA.str_role_act_timer_rot] then
        mozi = mozi .. "・タイマー非回転中\n"
    else
        mozi = mozi .. "・タイマー回転\n"
    end

    if MOVE.role_flg[DATA.str_role_act_timer2] then
        mozi = mozi .. "・タイマー1/2\n"
    elseif MOVE.role_flg[DATA.str_role_act_timer3] then
        mozi = mozi .. "・タイマー1/3\n"
    elseif MOVE.role_flg[DATA.str_role_act_timer4] then
        mozi = mozi .. "・タイマー1/4\n"
    elseif MOVE.role_flg[DATA.str_role_act_timer8] then
        mozi = mozi .. "・タイマー1/8\n"
    else
        mozi = mozi .. "・タイマーデフォルト\n"
    end

    if MOVE.role_flg[DATA.str_role_act_chip] then
        mozi = mozi .. "・役職の欠けあり\n"
    else
        mozi = mozi .. "・役職の欠けなし\n"
    end
    if MOVE.role_flg[DATA.str_role_act_fortune] then
        mozi = mozi .. "・初日占いなし\n"
    else
        mozi = mozi .. "・初日占いあり\n"
    end
    if MOVE.role_flg[DATA.str_role_act_fortune_hand] then
        mozi = mozi .. "・初日占い手動可能(制限外ランダム)\n"
    else
        mozi = mozi .. "・初日占いランダム\n"
    end
    if MOVE.role_flg[DATA.str_role_act_option] then
        mozi = mozi .. "・役職のオプション設定使用\n"

        RoleInput()

        local count = 0
        for i = 1, #MOVE.option_role_flg do
            if MOVE.option_role_flg[i] then
                count = count + 1
            end
        end
        if count == 0 then
            mozi = mozi .. "・役職のオプション設定がされていません\n"

            mozi = mozi .. "\n・役職一覧\n"
            mozi = mozi .. "・使用役職数:" .. tostring(0) .. "人\n"
        else
            mozi = mozi .. "\n・役職一覧\n"
            for i = 1, #MOVE.role_input do
                mozi = mozi .. "・" .. MOVE.role_input[i].name .. "\n"
            end
            mozi = mozi .. "・使用役職数:" .. tostring(#MOVE.role_input) .. "人\n"
        end
        mozi = mozi .. "・現在参加人数:" .. tostring(MOVE.player_count) .. "人\n"
    else
        mozi = mozi .. "・役職デフォルトパターン設定使用\n"
        if MOVE.role_flg[DATA.str_role_act_pattern] then
            mozi = mozi .. "・パターン2\n"
        else
            mozi = mozi .. "・パターン1\n"
        end

        RoleInput()
        mozi = mozi .. "\n・役職一覧\n"
        for i = 1, #MOVE.role_input do
            mozi = mozi .. "・" .. MOVE.role_input[i].name .. "\n"
        end
        mozi = mozi .. "・使用役職数:" .. tostring(#MOVE.role_input) .. "人\n"
        mozi = mozi .. "・現在参加人数:" .. tostring(MOVE.player_count) .. "人\n"
    end

    ASSET.SetText("操作説明", mozi)

    --操作盤
    local operator = DATA.str_operator_act_si[DATA.str_operator_act_operator]
    local operator_pos = operator.GetLocalPosition()
    local operator_rot = operator.GetLocalRotation()
    if MOVE.operator_act == DATA.str_operator_act_close then
        --操作表示系
        for i = 1, DATA.operator_max do
            --文章系
            local si = DATA.str_operator_si[DATA.str_operator_num][i]
            si.SetActive(false)
        end

        --色指定
        for i = 2, #DATA.str_operator_act do
            ASSET.material.SetColor(DATA.str_operator_act[i], NO_CHOSE_COL)
        end
    elseif MOVE.operator_act == DATA.str_operator_act_join then
        --操作表示系
        for i = 1, DATA.operator_max do
            --文章系
            local si = DATA.str_operator_si[DATA.str_operator_num][i]
            if i > DATA.operator_player_max then
                si.SetActive(false)
            else
                si.SetActive(false)
                --文章系
                ASSET.SetText(DATA.str_operator[DATA.str_operator_txt_num] .. tostring(i), MOVE.enable_player_name[i])
                --色指定
                if MOVE.player_flg[i] then
                    ASSET.material.SetColor(DATA.str_operator[DATA.str_operator_num] .. tostring(i), CHOSE_COL)
                else
                    ASSET.material.SetColor(DATA.str_operator[DATA.str_operator_num] .. tostring(i), NO_CHOSE_COL)
                end
                if si.IsMine then
                    local est_pos =
                        operator_pos +
                        operator_rot *
                            Vector3.__new(
                                0,
                                0.25 - 0.1 * ((i - 1) % DATA.operator_high),
                                -0.19 - 0.24 * math.floor((i - 1) / DATA.operator_high)
                            )
                    si.SetLocalPosition(est_pos)
                    si.SetLocalRotation(operator_rot)
                end
                si.SetActive(true)
            end
        end
        --色指定
        for i = 2, #DATA.str_operator_act do
            if MOVE.operator_act == i then
                ASSET.material.SetColor(DATA.str_operator_act[i], CHOSE_COL)
            else
                ASSET.material.SetColor(DATA.str_operator_act[i], NO_CHOSE_COL)
            end
        end
    elseif MOVE.operator_act == DATA.str_operator_act_role then
        --操作表示系
        for i = 1, DATA.operator_max do
            --文章系
            local si = DATA.str_operator_si[DATA.str_operator_num][i]

            if i > #DATA.str_role_act then
                si.SetActive(false)
            else
                si.SetActive(false)
                ASSET.SetText(DATA.str_operator[DATA.str_operator_txt_num] .. tostring(i), DATA.str_role_act[i])
                if si.IsMine then
                    local est_pos =
                        operator_pos +
                        operator_rot *
                            Vector3.__new(
                                0,
                                0.25 - 0.1 * ((i - 1) % DATA.operator_high),
                                -0.19 - 0.24 * math.floor((i - 1) / DATA.operator_high)
                            )
                    si.SetLocalPosition(est_pos)
                    si.SetLocalRotation(operator_rot)
                end
                si.SetActive(true)
            end
            --色指定
            if MOVE.role_flg[i] then
                ASSET.material.SetColor(DATA.str_operator[DATA.str_operator_num] .. tostring(i), CHOSE_COL)
            else
                ASSET.material.SetColor(DATA.str_operator[DATA.str_operator_num] .. tostring(i), NO_CHOSE_COL)
            end
        end

        --色指定
        for i = 2, #DATA.str_operator_act do
            if MOVE.operator_act == i then
                ASSET.material.SetColor(DATA.str_operator_act[i], CHOSE_COL)
            else
                ASSET.material.SetColor(DATA.str_operator_act[i], NO_CHOSE_COL)
            end
        end
    elseif MOVE.operator_act == DATA.str_operator_act_option then
        --操作表示系
        for i = 1, DATA.operator_max do
            --文章系
            local si = DATA.str_operator_si[DATA.str_operator_num][i]

            if i > DATA.option_role_max then
                si.SetActive(false)
            else
                si.SetActive(false)
                ASSET.SetText(
                    DATA.str_operator[DATA.str_operator_txt_num] .. tostring(i),
                    DATA.str_option_role_act[i].name
                )

                if si.IsMine then
                    local est_pos =
                        operator_pos +
                        operator_rot *
                            Vector3.__new(
                                0,
                                0.25 - 0.1 * ((i - 1) % DATA.operator_high),
                                -0.19 - 0.24 * math.floor((i - 1) / DATA.operator_high)
                            )
                    si.SetLocalPosition(est_pos)
                    si.SetLocalRotation(operator_rot)
                end
                si.SetActive(true)
            end
            --色指定
            if MOVE.option_role_flg[i] then
                ASSET.material.SetColor(DATA.str_operator[DATA.str_operator_num] .. tostring(i), CHOSE_COL)
            else
                ASSET.material.SetColor(DATA.str_operator[DATA.str_operator_num] .. tostring(i), NO_CHOSE_COL)
            end
        end

        --色指定
        for i = 2, #DATA.str_operator_act do
            if MOVE.operator_act == i then
                ASSET.material.SetColor(DATA.str_operator_act[i], CHOSE_COL)
            else
                ASSET.material.SetColor(DATA.str_operator_act[i], NO_CHOSE_COL)
            end
        end
    end
end

--名前再取得処理関係
function GetNameFunc()
    --初期化
    for i = 1, DATA.operator_max do
        MOVE.enable_player_name[i] = ""
        MOVE.player_flg[i] = false
        if i == DATA.operator_player_max then
            MOVE.enable_player_name[i] = "名称再取得\nゲームリセット"
        elseif i == DATA.operator_player_max - 1 then
            MOVE.enable_player_name[i] = "ゲームスタート"
        end
    end

    --アバター取得
    local avater = STUDIO.GetAvatars()
    for i = 1, #avater do
        if #MOVE.enable_player_name > i then
            MOVE.enable_player_name[i] = avater[i].GetName()
            for i2 = 1, 0 do
                MOVE.enable_player_name[i + i2] = avater[i].GetName() .. tostring(i2)
            end
        end
    end
end

--投票示処理
function VoteShowFunc()
    if MOVE.game_before_flg then
        local str = ""
        local count = 1
        for i = 1, DATA.operator_player_max do
            if MOVE.player_flg[i] then
                str = str .. MOVE.enable_player_name[i] .. "→"

                if MOVE.chose_data[count] ~= 0 then
                    local count2 = 1
                    for i2 = 1, DATA.operator_player_max do
                        if MOVE.player_flg[i2] then
                            if count2 == MOVE.chose_data[count] then
                                str = str .. MOVE.enable_player_name[i2]
                                break
                            end
                            count2 = count2 + 1
                        end
                    end
                else
                    if MOVE.player_state[count] then
                        str = str .. "未投票"
                    else
                        str = str .. "死亡"
                    end
                end
                str = str .. "\n"
                count = count + 1
            end
        end
        ASSET.SetText("投票結果", str)
    end
end

--昼時計処理
function Clock()
    --ゲーム開始時
    local timer = MOVE.game_clock
    timer = math.floor(timer)
    local time_data = DATA.game_start_timer / MOVE.bairitu
    time_data = time_data - timer
    local str = tostring(math.floor((time_data) / 60)) .. ":"
    if math.floor(time_data) % 60 == 0 then
        str = str .. "0" .. tostring(math.floor(time_data) % 60)
    elseif (math.floor(time_data) % 60) < 10 then
        str = str .. "0" .. tostring(math.floor(time_data) % 60)
    else
        str = str .. tostring(math.floor(time_data) % 60)
    end
    ASSET.SetText(DATA.str_clock_si[DATA.str_clock_clock].GetName(), "準備期間\n" .. str)
end

--昼時計処理
function DayClock(flg)
    --ゲーム開始時
    local timer = MOVE.game_clock - DATA.game_start_timer / MOVE.bairitu
    local day = MOVE.day
    if day > 3 then
        day = 3
    end
    --投票可能
    if (DATA.Daytime / MOVE.bairitu - (day - 1) * MOVE.day_add / MOVE.bairitu) < timer then
        if not flg then
            timer = DATA.Daytime / MOVE.bairitu - (day - 1) * MOVE.day_add / MOVE.bairitu
            for i = 1, DATA.player_max do
                ASSET.SetText(DATA.str_clock_si[DATA.str_clock_clock].GetName(), "投票\n行動")
            end
            if MOVE.game_vote_flg then
                ASSET.audio.Play("昼投票", 0.35, false)
                MOVE.game_vote_flg = false
            end
        end
        return true
    end

    if not flg then
        local time_data = DATA.Daytime / MOVE.bairitu - (day - 1) * MOVE.day_add / MOVE.bairitu
        if time_data < MOVE.day_min / MOVE.bairitu then
            time_data = MOVE.day_min / MOVE.bairitu
        end
        time_data = time_data - timer
        local str = tostring(math.floor((time_data) / 60)) .. ":"
        if math.floor(time_data) % 60 == 0 then
            str = str .. "0" .. tostring(math.floor(time_data) % 60)
        elseif (math.floor(time_data) % 60) < 10 then
            str = str .. "0" .. tostring(math.floor(time_data) % 60)
        else
            str = str .. tostring(math.floor(time_data) % 60)
        end
        ASSET.SetText(DATA.str_clock_si[DATA.str_clock_clock].GetName(), " 昼\n" .. str)
        MOVE.game_vote_flg = true
    end
    return false
end

--夜時計処理
function NightClock(flg)
    --ゲーム開始時
    local timer = MOVE.game_clock - DATA.game_start_timer / MOVE.bairitu

    --投票可能
    if DATA.Nightime / MOVE.bairitu < timer then
        if not flg then
            timer = DATA.Nightime / MOVE.bairitu
            for i = 1, DATA.player_max do
                ASSET.SetText(DATA.str_clock_si[DATA.str_clock_clock].GetName(), "役職\n行動")
            end
            if MOVE.game_vote_flg then
                ASSET.audio.Play("役職投票", 0.35, false)
                MOVE.game_vote_flg = false
            end
        end
        return true
    end

    if not flg then
        local time_data = DATA.Nightime / MOVE.bairitu
        time_data = time_data - timer
        local str = tostring(math.floor((time_data) / 60)) .. ":"
        if math.floor(time_data) % 60 == 0 then
            str = str .. "0" .. tostring(math.floor(time_data) % 60)
        elseif (math.floor(time_data) % 60) < 10 then
            str = str .. "0" .. tostring(math.floor(time_data) % 60)
        else
            str = str .. tostring(math.floor(time_data) % 60)
        end
        ASSET.SetText(DATA.str_clock_si[DATA.str_clock_clock].GetName(), " 夜\n" .. str)
        MOVE.game_vote_flg = true
    end
    return false
end

function Sync(num)
    if num == 0 then
        return {
            num = num,
            --操作番号
            operator_act = MOVE.operator_act,
            enable_player_name = MOVE.enable_player_name,
            player_flg = MOVE.player_flg,
            option_role_flg = MOVE.option_role_flg,
            role_flg = MOVE.role_flg,
            game_clock = MOVE.game_clock,
            role_input = MOVE.role_input,
            player_role_input = MOVE.player_role_input,
            chose_data = MOVE.chose_data,
            day = MOVE.day,
            game_before_flg = MOVE.game_before_flg,
            player_state = MOVE.player_state
        }
    elseif num == 1 then
        return {
            num = num,
            operator_act = MOVE.operator_act
        }
    elseif num == 2 then
        return {
            num = num
        }
    elseif num == 3 then
        return {
            num = num,
            enable_player_name = MOVE.enable_player_name,
            player_flg = MOVE.player_flg
        }
    elseif num == 4 then
        return {
            num = num,
            player_flg = MOVE.player_flg
        }
    elseif num == 5 then
        return {
            num = num,
            option_role_flg = MOVE.option_role_flg
        }
    elseif num == 6 then
        return {
            num = num,
            role_flg = MOVE.role_flg
        }
    elseif num == 7 then
        return {
            num = num
        }
    elseif num == 8 then
        return {
            num = num,
            role_input = MOVE.role_input,
            player_role_input = MOVE.player_role_input
        }
    elseif num == 9 then
    elseif num == 10 then
        return {
            num = num,
            chose_data = MOVE.chose_data
        }
    elseif num == 11 then
        return {
            num = num,
            game_before_flg = not MOVE.game_before_flg,
            player_state = MOVE.player_state,
            day = MOVE.day
        }
    elseif num == 12 then
        return {
            num = num
        }
    elseif num == 13 then
        return {
            num = num
        }
    end
end

function SyncMess(sender, name, num)
    local operater_si = DATA.str_operator_act_si[DATA.str_operator_act_operator]
    if num == -1 then
        if operater_si.IsMine then
            vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(0), ASSET.GetInstanceId())
        end
    elseif num.num == 0 then
        if MOVE.enter_flg then
            MOVE.enable_player_name = num.enable_player_name
            MOVE.operator_act = num.operator_act
            MOVE.player_flg = num.player_flg
            MOVE.option_role_flg = num.option_role_flg
            MOVE.role_flg = num.role_flg
            MOVE.role_input = num.role_input
            MOVE.player_role_input = num.player_role_input
            MOVE.day = num.day
            MOVE.chose_data = num.chose_data
            MOVE.game_noon_flg = false
            MOVE.game_vote_flg = false
            MOVE.game_before_flg = num.game_before_flg
            MOVE.player_state = num.player_state
            if MOVE.role_flg[DATA.str_role_act_timer2] then
                MOVE.bairitu = 2
            elseif MOVE.role_flg[DATA.str_role_act_timer3] then
                MOVE.bairitu = 3
            elseif MOVE.role_flg[DATA.str_role_act_timer4] then
                MOVE.bairitu = 4
            elseif MOVE.role_flg[DATA.str_role_act_timer8] then
                MOVE.bairitu = 8
            else
                MOVE.bairitu = 1
            end
            LiveAndDie()
            --参加人数把握
            local count = 0
            for i = 1, DATA.operator_player_max do
                if MOVE.player_flg[i] then
                    count = count + 1
                end
                if i == DATA.operator_player_max then
                    MOVE.enable_player_name[i] = "名称再取得\nゲームリセット"
                elseif i == DATA.operator_player_max - 1 then
                    MOVE.enable_player_name[i] = "ゲームスタート"
                end
            end

            --初期化
            for i3 = 1, DATA.player_max do
                ASSET.SetText("役職行動" .. tostring(i3), "")
            end
            MOVE.player_count = count
            OperatorShowFunc()
            HouseShowFunc(false)
            MOVE.game_clock = num.game_clock
        end
        VoteShowFunc()
        MOVE.enter_flg = false
    elseif num.num == 1 then
        MOVE.operator_act = num.operator_act
        OperatorShowFunc()
    elseif num.num == 2 then
        if operater_si.IsMine then
            GetNameFunc()
            vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(3), ASSET.GetInstanceId())
        end
    elseif num.num == 3 then
        MOVE.game_clock = -1
        MOVE.enable_player_name = num.enable_player_name
        MOVE.player_flg = num.player_flg
        --参加人数把握
        local count = 0
        for i = 1, DATA.operator_player_max do
            if MOVE.player_flg[i] then
                count = count + 1
            end
        end
        MOVE.player_count = count
        OperatorShowFunc()
        HouseShowFunc(false)

        MOVE.player_role_input = {}
        ShowCard()
    elseif num.num == 4 then
        MOVE.player_flg = num.player_flg
        --参加人数把握
        local count = 0
        for i = 1, DATA.operator_player_max do
            if MOVE.player_flg[i] then
                count = count + 1
            end
        end
        MOVE.player_count = count
        OperatorShowFunc()
        HouseShowFunc(false)
    elseif num.num == 5 then
        MOVE.option_role_flg = num.option_role_flg
        if MOVE.role_flg[DATA.str_role_act_timer2] then
            MOVE.bairitu = 2
        elseif MOVE.role_flg[DATA.str_role_act_timer3] then
            MOVE.bairitu = 3
        elseif MOVE.role_flg[DATA.str_role_act_timer4] then
            MOVE.bairitu = 4
        elseif MOVE.role_flg[DATA.str_role_act_timer8] then
            MOVE.bairitu = 8
        else
            MOVE.bairitu = 1
        end
        OperatorShowFunc()
    elseif num.num == 6 then
        MOVE.role_flg = num.role_flg
        if MOVE.role_flg[DATA.str_role_act_timer2] then
            MOVE.bairitu = 2
        elseif MOVE.role_flg[DATA.str_role_act_timer3] then
            MOVE.bairitu = 3
        elseif MOVE.role_flg[DATA.str_role_act_timer4] then
            MOVE.bairitu = 4
        elseif MOVE.role_flg[DATA.str_role_act_timer8] then
            MOVE.bairitu = 8
        else
            MOVE.bairitu = 1
        end
        OperatorShowFunc()
    elseif num.num == 7 then
        MOVE.game_clock = 0
        for i = 1, DATA.player_max do
            MOVE.chose_data[i] = 0
        end

        --初期化
        for i3 = 1, DATA.player_max do
            ASSET.SetText("役職行動" .. tostring(i3), "")
        end
        HouseShowFunc(true)

        MOVE.player_role_input = {}
        ShowCard()
    elseif num.num == 8 then
        MOVE.role_input = num.role_input
        MOVE.player_role_input = num.player_role_input
        MOVE.day = 1
        MOVE.game_noon_flg = true
        MOVE.game_before_flg = true
        for i = 1, DATA.player_max do
            MOVE.player_state[i] = true
        end
        LiveAndDie()
        VoteShowFunc()
        HouseShowFunc(true)
        ShowCard()
        MOVE.game_clock = 0.001
    elseif num.num == 9 then
        if (MOVE.game_clock < DATA.game_start_timer / MOVE.bairitu) then
            if operater_si.IsMine then
                MOVE.chose_data[num.player_house] = num.chose
                vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(10), ASSET.GetInstanceId())
            end
        end

        if operater_si.IsMine and (DayClock(true) or (not MOVE.game_before_flg)) then
            MOVE.chose_data[num.player_house] = num.chose
            vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(10), ASSET.GetInstanceId())
        end
    elseif num.num == 10 then
        MOVE.chose_data = num.chose_data
        VoteShowFunc()
    elseif num.num == 11 then
        MOVE.game_noon_flg = true
        MOVE.game_before_flg = num.game_before_flg
        for i = 1, DATA.player_max do
            MOVE.chose_data[i] = 0
        end
        MOVE.day = num.day
        MOVE.player_state = num.player_state
        LiveAndDie()
        MOVE.game_clock = DATA.game_start_timer
    elseif num.num == 12 then
        VoteShowFunc()
        for i = 1, DATA.player_max do
            MOVE.chose_data[i] = 0
        end
    elseif num.num == 13 then
        MOVE.game_clock = -1
        MOVE.game_noon_flg = false
        LiveAndDie()
        MOVE.game_vote_flg = false
        MOVE.game_before_flg = false
        for i = 1, DATA.player_max do
            MOVE.chose_data[i] = 0
        end
    end
end
vci.message.On(ASHU_MESS .. "SYNC", SyncMess)
