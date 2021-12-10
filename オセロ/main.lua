--簡略化
local STATE = vci.state
local ASSET = vci.assets
local STADIO = vci.studio
local CHOSE_COL = Color.__new(0.2, 1, 0.2)
local DEF_COL = Color.__new(1, 1, 1)
local si = ASSET.GetTransform("SYNC_DATA")
local ASHU_MESS = "ASHU_REVERSE_MESS_"

local DATA = {
    str = {
        "board (",
        "koma (",
        "mini_koma (",
        "hako (",
        "moti_koma (",
        "初期化",
        "戻る",
        "CPU",
        "先手後手",
        "白黒",
        "ボタン集",
        "名前取得",
        "コメント対応"
    },
    str_max = {2, 65, 65, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1},
    str_board_num = 1,
    str_koma_num = 2,
    str_mini_koma_num = 3,
    str_hako_num = 4,
    str_moti_koma_num = 5,
    str_syokika_num = 6,
    str_modoru_num = 7,
    str_cpu_num = 8,
    str_sentegote_num = 9,
    str_sirokuro_num = 10,
    str_button_num = 11,
    str_name_num = 12,
    str_comment_num = 13,
    str_si = {},
    koma_black = 1,
    koma_wite = 2,
    board_size = 0.735
}

local MOVE = {
    --入室
    enter_flg = true,
    --反転時間
    reverse_time = 0,
    --cpu起動中(def:0)
    cpu_on = 0,
    --cpu起動モード(def:false)
    cpu_mode = true,
    --CPU先手(def:false)
    cpu_first = false,
    --CPU色(def:DATA.koma_wite)
    cpu_color = DATA.koma_wite,
    --現在手番
    now_turn = 0,
    --現在の駒の置かれ方履歴
    now_koma_put = {28, 29, 36, 37},
    --現在の駒色の置かれ方履歴
    now_koma_color = {DATA.koma_wite, DATA.koma_black, DATA.koma_black, DATA.koma_wite},
    --駒現在数
    now_koma_count = 4,
    --仮の置く場所保存
    kari_put_pos = 0,
    --参加者名
    join_name = "いません",
    --参加者色
    join_color = 0,
    --参加可能
    join_enable = true,
    --参加募集
    join_get = true
}

local SYNC = {
    --入室
    enter = -1,
    --同期
    sync = 0,
    --cpu起動
    cpu_on = 1,
    --cpu停止
    cpu_off = 2,
    --cpu同期
    cpu_sync = 3,
    --手駒1再起
    tegoma1 = 4,
    --手駒2再起
    tegoma2 = 5,
    --初期化
    syokika = 6,
    --戻る
    modoru = 7,
    --CPU
    cpu = 8,
    --先手後手
    sentegote = 9,
    --白黒
    sirokuro = 10,
    --切替同期
    change_sync = 11,
    --駒同期
    koma_sync = 12,
    --黒駒置く
    bk_koma_put = 13,
    --白駒置く
    w_koma_put = 14,
    --ボタン集める
    button = 15,
    --ボタン集める
    board = 16,
    --名前取得
    name = 17,
    --参加許可
    comment = 18
}

--サブアイテム関係
for i = 1, #DATA.str do
    DATA.str_si[i] = {}
    if i < DATA.str_syokika_num then
        for i2 = 1, DATA.str_max[i] do
            DATA.str_si[i][i2] = ASSET.GetTransform(DATA.str[i] .. tostring(i2) .. ")")
            --盤上駒隠す
            if i == DATA.str_koma_num or i == DATA.str_mini_koma_num or i == DATA.str_moti_koma_num then
                local tate = (i2 - 1) % 8
                local yoko = math.floor((i2 - 1) / 8)
                local tate_pos = DATA.board_size - DATA.board_size / (7 / 2) * tate
                local yoko_pos = -DATA.board_size + DATA.board_size / (7 / 2) * yoko
                DATA.str_si[i][i2].SetLocalPosition(Vector3.__new(yoko_pos, 0.02, tate_pos))
                DATA.str_si[i][i2].SetActive(false)
            end
        end
    else
        for i2 = 1, DATA.str_max[i] do
            DATA.str_si[i][i2] = ASSET.GetTransform(DATA.str[i])
        end
    end
end

--時間処理
local timer = 0
local timer_count = 1 / 10
function updateAll()
    if (os.clock() - timer) > timer_count then
        if MOVE.enter_flg then
            --初期化処理
            vci.message.EmitWithId(ASHU_MESS .. "SYNC", SYNC.enter, ASSET.GetInstanceId())
        end

        --反転処理後
        if si.IsMine and MOVE.reverse_time > 1 then
            --cpu停止起動中
            if MOVE.cpu_on == 0 then
                --cpuモード
                if MOVE.cpu_mode then
                    --初期状態のみ有効、cpu先手
                    if MOVE.cpu_first and (MOVE.now_turn == 0) and (MOVE.now_koma_count == 4) then
                        vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(SYNC.cpu_on), ASSET.GetInstanceId())
                    else
                        --手番きたときにcpu指定色ならばcpu手番
                        if MOVE.cpu_color == MOVE.now_turn then
                            vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(SYNC.cpu_on), ASSET.GetInstanceId())
                        end
                    end
                end
            end
        end

        timer = os.clock()
    end
end

function onUse(use)
    --入室同期後
    if not MOVE.enter_flg then
        --持ち駒関係
        if use == DATA.str_si[DATA.str_hako_num][DATA.koma_black].GetName() then
            vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(SYNC.tegoma1), ASSET.GetInstanceId())
        elseif use == DATA.str_si[DATA.str_hako_num][DATA.koma_wite].GetName() then
            vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(SYNC.tegoma2), ASSET.GetInstanceId())
        elseif use == DATA.str_si[DATA.str_syokika_num][1].GetName() then
            --初期化
            vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(SYNC.syokika), ASSET.GetInstanceId())
        elseif use == DATA.str_si[DATA.str_modoru_num][1].GetName() then
            --戻る
            vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(SYNC.modoru), ASSET.GetInstanceId())
        elseif use == DATA.str_si[DATA.str_cpu_num][1].GetName() then
            --CPU
            vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(SYNC.cpu), ASSET.GetInstanceId())
        elseif use == DATA.str_si[DATA.str_sentegote_num][1].GetName() then
            --先手後手
            vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(SYNC.sentegote), ASSET.GetInstanceId())
        elseif use == DATA.str_si[DATA.str_sirokuro_num][1].GetName() then
            --白黒
            vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(SYNC.sirokuro), ASSET.GetInstanceId())
        elseif use == DATA.str_si[DATA.str_moti_koma_num][DATA.koma_black].GetName() then
            --黒駒置く
            vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(SYNC.bk_koma_put), ASSET.GetInstanceId())
        elseif use == DATA.str_si[DATA.str_moti_koma_num][DATA.koma_wite].GetName() then
            --白駒置く
            vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(SYNC.w_koma_put), ASSET.GetInstanceId())
        elseif use == DATA.str_si[DATA.str_button_num][1].GetName() then
            --ボタン集
            vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(SYNC.button), ASSET.GetInstanceId())
        elseif use == DATA.str_si[DATA.str_board_num][1].GetName() then
            --ボタン集
            vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(SYNC.board), ASSET.GetInstanceId())
        elseif use == DATA.str_si[DATA.str_name_num][1].GetName() then
            --名前取得
            vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(SYNC.name), ASSET.GetInstanceId())
        elseif use == DATA.str_si[DATA.str_comment_num][1].GetName() then
            --コメント参加可能
            vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(SYNC.comment), ASSET.GetInstanceId())
        end
    end
end

--駒回転関係
vci.StartCoroutine(
    coroutine.create(
        function()
            local koma_clock = os.clock()
            while 1 do
                if not MOVE.enter_flg then
                    for i = 1, 64 do
                        local koma = DATA.str_si[DATA.str_koma_num][i]
                        local koma2 = DATA.str_si[DATA.str_mini_koma_num][i]
                        local tate = (i - 1) % 8
                        local yoko = math.floor((i - 1) / 8)
                        local tate_pos = DATA.board_size - DATA.board_size / (7 / 2) * tate
                        local yoko_pos = -DATA.board_size + DATA.board_size / (7 / 2) * yoko

                        koma.SetLocalPosition(Vector3.__new(yoko_pos, 0.02, tate_pos))
                        koma2.SetLocalPosition(Vector3.__new(yoko_pos, 0.02, tate_pos))
                    end
                    --今の盤面を引く
                    local put_enable = {}
                    for i = 1, 64 do
                        put_enable[i] = true
                        local koma = DATA.str_si[DATA.str_koma_num][i]
                        local koma2 = DATA.str_si[DATA.str_mini_koma_num][i]
                        koma.SetActive(false)
                        koma2.SetActive(false)
                    end
                    local black = 0
                    local white = 0
                    for i = #MOVE.now_koma_put - MOVE.now_koma_count + 1, #MOVE.now_koma_put do
                        put_enable[MOVE.now_koma_put[i]] = false
                        local koma = DATA.str_si[DATA.str_koma_num][MOVE.now_koma_put[i]]
                        local koma2 = DATA.str_si[DATA.str_mini_koma_num][MOVE.now_koma_put[i]]
                        koma.SetActive(true)
                        koma2.SetActive(true)
                        if MOVE.now_koma_color[i] == DATA.koma_black then
                            black = black + 1
                        elseif MOVE.now_koma_color[i] == DATA.koma_wite then
                            white = white + 1
                        end
                    end

                    local str = "黒:" .. tostring(black) .. "\n白:" .. tostring(white)
                    if (black + white) == 64 then
                        if black > white then
                            str = str .. "\n黒勝利\n"
                        elseif black < white then
                            str = str .. "\n白勝利\n"
                        else
                            str = str .. "\n引き分け\n"
                        end
                    else
                        if MOVE.now_turn == DATA.koma_black then
                            str = str .. "\n黒の手番\n"
                        elseif MOVE.now_turn == DATA.koma_wite then
                            str = str .. "\n白の手番\n"
                        else
                            str = str .. "\nどちらでも可\n"
                        end
                    end
                    if MOVE.join_enable then
                        if MOVE.join_get then
                            str = str .. "募集中:"
                        end
                        if MOVE.join_color == 0 then
                            str = str .. "未決定:"
                        elseif MOVE.join_color == DATA.koma_black then
                            str = str .. "黒:"
                        elseif MOVE.join_color == DATA.koma_wite then
                            str = str .. "白:"
                        end
                        str = str .. MOVE.join_name
                    end
                    ASSET.SetText("点数", str)
                    if MOVE.reverse_time <= 1 then
                        --仮駒配置記録初期化
                        MOVE.kari_put_pos = 0

                        --初期化時
                        if MOVE.now_koma_count == 4 then
                            for i2 = 1, #MOVE.now_koma_put do
                                local koma_pos = MOVE.now_koma_put[i2]
                                local koma = DATA.str_si[DATA.str_koma_num][koma_pos]
                                local koma2 = DATA.str_si[DATA.str_mini_koma_num][koma_pos]
                                if MOVE.now_koma_color[i2] == DATA.koma_wite then
                                    koma.SetLocalRotation(Quaternion.Euler(180, 0, 0))
                                    koma2.SetLocalRotation(Quaternion.Euler(180, 0, 0))
                                else
                                    koma.SetLocalRotation(Quaternion.Euler(0, 0, 0))
                                    koma2.SetLocalRotation(Quaternion.Euler(0, 0, 0))
                                end

                                local tate = (koma_pos - 1) % 8
                                local yoko = math.floor((koma_pos - 1) / 8)
                                local tate_pos = DATA.board_size - DATA.board_size / (7 / 2) * tate
                                local yoko_pos = -DATA.board_size + DATA.board_size / (7 / 2) * yoko

                                koma.SetLocalPosition(Vector3.__new(yoko_pos, 0.02, tate_pos))
                                koma2.SetLocalPosition(Vector3.__new(yoko_pos, 0.02, tate_pos))
                            end
                        else
                            --前の盤面と今の盤面比較用
                            local now_board = {}
                            local now_board_col = {}
                            for i = #MOVE.now_koma_put - MOVE.now_koma_count + 1, #MOVE.now_koma_put do
                                now_board[#now_board + 1] = MOVE.now_koma_put[i]
                                now_board_col[#now_board_col + 1] = MOVE.now_koma_color[i]
                            end
                            local before_board = {}
                            local before_board_col = {}
                            for i = #MOVE.now_koma_put - MOVE.now_koma_count * 2 + 2, #MOVE.now_koma_put -
                                MOVE.now_koma_count do
                                before_board[#before_board + 1] = MOVE.now_koma_put[i]
                                before_board_col[#before_board_col + 1] = MOVE.now_koma_color[i]
                            end

                            --反転処理等
                            for i2 = 1, #now_board do
                                local koma_pos = now_board[i2]
                                local koma = DATA.str_si[DATA.str_koma_num][koma_pos]
                                local koma2 = DATA.str_si[DATA.str_mini_koma_num][koma_pos]
                                if i2 ~= #now_board then
                                    local tate = (koma_pos - 1) % 8
                                    local yoko = math.floor((koma_pos - 1) / 8)
                                    local tate_pos = DATA.board_size - DATA.board_size / (7 / 2) * tate
                                    local yoko_pos = -DATA.board_size + DATA.board_size / (7 / 2) * yoko
                                    local pos_clock = MOVE.reverse_time * 2
                                    if pos_clock > 1 then
                                        pos_clock = -pos_clock + 2
                                    end
                                    --色変更有
                                    if now_board_col[i2] ~= before_board_col[i2] then
                                        if now_board_col[i2] == DATA.koma_wite then
                                            koma.SetLocalRotation(
                                                Quaternion.Lerp(
                                                    Quaternion.Euler(0, 0, 0),
                                                    Quaternion.Euler(180, 0, 0),
                                                    MOVE.reverse_time
                                                )
                                            )

                                            koma2.SetLocalRotation(
                                                Quaternion.Lerp(
                                                    Quaternion.Euler(0, 0, 0),
                                                    Quaternion.Euler(180, 0, 0),
                                                    MOVE.reverse_time
                                                )
                                            )
                                        else
                                            koma.SetLocalRotation(
                                                Quaternion.Lerp(
                                                    Quaternion.Euler(180, 0, 0),
                                                    Quaternion.Euler(0, 0, 0),
                                                    MOVE.reverse_time
                                                )
                                            )
                                            koma2.SetLocalRotation(
                                                Quaternion.Lerp(
                                                    Quaternion.Euler(180, 0, 0),
                                                    Quaternion.Euler(0, 0, 0),
                                                    MOVE.reverse_time
                                                )
                                            )
                                        end

                                        koma.SetLocalPosition(
                                            Vector3.Slerp(
                                                Vector3.__new(yoko_pos, 0.02, tate_pos),
                                                Vector3.__new(yoko_pos, 0.14, tate_pos),
                                                pos_clock
                                            )
                                        )

                                        koma2.SetLocalPosition(
                                            Vector3.Slerp(
                                                Vector3.__new(yoko_pos, 0.02, tate_pos),
                                                Vector3.__new(yoko_pos, 0.14, tate_pos),
                                                pos_clock
                                            )
                                        )
                                    else
                                        if now_board_col[i2] == DATA.koma_wite then
                                            koma.SetLocalRotation(Quaternion.Euler(180, 0, 0))

                                            koma2.SetLocalRotation(Quaternion.Euler(180, 0, 0))
                                        else
                                            koma.SetLocalRotation(Quaternion.Euler(0, 0, 0))
                                            koma2.SetLocalRotation(Quaternion.Euler(0, 0, 0))
                                        end
                                    end
                                else
                                    if now_board_col[i2] == DATA.koma_wite then
                                        koma.SetLocalRotation(Quaternion.Euler(180, 0, 0))

                                        koma2.SetLocalRotation(Quaternion.Euler(180, 0, 0))
                                    else
                                        koma.SetLocalRotation(Quaternion.Euler(0, 0, 0))
                                        koma2.SetLocalRotation(Quaternion.Euler(0, 0, 0))
                                    end
                                end
                            end
                        end

                        MOVE.reverse_time = MOVE.reverse_time + (os.clock() - koma_clock) * 1.55
                    else
                        --駒近傍探索
                        local board = DATA.str_si[DATA.str_board_num][1]
                        local board_pos = board.GetPosition()
                        local board_rot = board.GetRotation()
                        local dist = 0.3
                        local dist_num = 0
                        local dist_col = 0

                        for i = 1, #DATA.str_si[DATA.str_moti_koma_num] do
                            if MOVE.now_turn == 0 or MOVE.now_turn == i then
                                local koma = DATA.str_si[DATA.str_moti_koma_num][i]
                                local koma_pos = koma.GetPosition()
                                local est_pos = koma_pos - board_pos
                                est_pos = Quaternion.Inverse(board_rot) * est_pos / 0.6

                                for i2 = 1, 64 do
                                    if put_enable[i2] then
                                        local tate = (i2 - 1) % 8
                                        local yoko = math.floor((i2 - 1) / 8)
                                        local tate_pos = DATA.board_size - DATA.board_size / (7 / 2) * tate
                                        local yoko_pos = -DATA.board_size + DATA.board_size / (7 / 2) * yoko

                                        local est_dist =
                                            Vector3.Magnitude((est_pos - Vector3.__new(yoko_pos, 0.02, tate_pos)))
                                        if est_dist < dist then
                                            dist = est_dist
                                            dist_num = i2
                                            dist_col = i
                                        end
                                    end
                                end
                            end
                        end

                        dist_num = PutEnable(0, dist_num, dist_col)

                        --表示系
                        local koma = DATA.str_si[DATA.str_koma_num][65]
                        local koma2 = DATA.str_si[DATA.str_mini_koma_num][65]
                        koma.SetActive(false)
                        koma2.SetActive(false)
                        if dist_num ~= 0 then
                            koma.SetActive(true)
                            koma2.SetActive(true)
                            local tate = (dist_num - 1) % 8
                            local yoko = math.floor((dist_num - 1) / 8)
                            local tate_pos = DATA.board_size - DATA.board_size / (7 / 2) * tate
                            local yoko_pos = -DATA.board_size + DATA.board_size / (7 / 2) * yoko

                            if dist_col == DATA.koma_wite then
                                koma.SetLocalRotation(Quaternion.Euler(180, 0, 0))
                                koma2.SetLocalRotation(Quaternion.Euler(180, 0, 0))
                            else
                                koma.SetLocalRotation(Quaternion.Euler(0, 0, 0))
                                koma2.SetLocalRotation(Quaternion.Euler(0, 0, 0))
                            end

                            koma.SetLocalPosition(Vector3.__new(yoko_pos, 0.02, tate_pos))
                            koma2.SetLocalPosition(Vector3.__new(yoko_pos, 0.02, tate_pos))
                        end

                        MOVE.kari_put_pos = dist_num
                    end
                end

                koma_clock = os.clock()
                coroutine.yield()
            end
        end
    )
)

--CPU関係
vci.StartCoroutine(
    coroutine.create(
        function()
            while 1 do
                --CPU起動中
                if MOVE.cpu_on ~= 0 then
                    local CPU_clock = os.clock()
                    if MainCPU(CPU_clock) == 0 then
                        MOVE.cpu_on = 0
                        vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(SYNC.cpu_off), ASSET.GetInstanceId())
                    end
                    local clock = os.clock() - CPU_clock
                end

                coroutine.yield()
            end
        end
    )
)

--箱の上に駒
function TegomaUp(num)
    local tegoma = DATA.str_si[DATA.str_moti_koma_num][num]
    if tegoma.IsMine then
        tegoma._ALL_SetActive(true)
        local hako = DATA.str_si[DATA.str_hako_num][num]
        local hako_rot = hako.GetRotation()
        local hako_pos = hako.GetPosition()
        local hako_add = Vector3.__new(0, 0.13, 0)

        tegoma.SetPosition(hako_pos + hako_rot * hako_add)
        if num == DATA.koma_wite then
            hako_rot = hako_rot * Quaternion.Euler(0, 0, 180)
        end
        tegoma.SetRotation(hako_rot)
    end
end

--メイン部分
function MainCPU(CPU_clock)
    --cpu時間保持用
    local cpu_start = CPU_clock
    local cpu_clock = CPU_clock

    --反転対象駒色
    local rev_col = MOVE.cpu_color % 2 + 1
    --今の盤面計算
    local now_board = {}
    for i = 1, 64 do
        now_board[i] = 0
    end
    --今の盤面
    for i = #MOVE.now_koma_put - MOVE.now_koma_count + 1, #MOVE.now_koma_put do
        now_board[MOVE.now_koma_put[i]] = MOVE.now_koma_color[i]
    end

    --最大点数
    local MinScore = -100000
    local cpu_score_num = 0
    local MaxScore = 10000
    --設置可能場所
    local enable_pos = {}
    local datas = {}
    --64マス所分
    for i = 1, 64 do
        --置いてない場所である
        if now_board[i] == 0 then
            --置くことが可能である
            if i == PutEnable(0, i, MOVE.cpu_color) then
                enable_pos[#enable_pos + 1] = i
                datas[#datas + 1] = PutEnableData(now_board, i, MOVE.cpu_color)
            end
        end
    end
    --cpu停止処理
    if #enable_pos == 0 then
        MOVE.cpu_on = 0
        MOVE.now_turn = MOVE.cpu_color % 2 + 1
        vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(SYNC.cpu_off), ASSET.GetInstanceId())
        return -1
    end

    local sss = os.clock()
    local cpu_score = MinScore
    --深さ調整
    for max_root = 1, 64, 1 do
        --64マス中の置ける場所のみ所分
        for pos = 1, #enable_pos do
            --置いた場合の盤面記録
            --local board_inf = PutData(now_board, enable_pos[pos], MOVE.cpu_color)

            --各場所置いたときの最終的な最高スコア比較
            local ret =
                CPU_result(datas[pos], MOVE.cpu_color % 2 + 1, -MaxScore, -MinScore, max_root - 1, cpu_start, cpu_clock)

            --最大スコア更新
            if cpu_score < ret then
                cpu_score = ret
                cpu_score_num = enable_pos[pos]
            end
        end
        cpu_clock = CPU_yield(cpu_start, cpu_clock)
        --時間過ぎた
        if cpu_clock < 0 then
            print("ルート" .. max_root)
            break
        end
    end
    local ddd = os.clock() - sss
    --追加色取得
    local add = PutData(0, cpu_score_num, MOVE.cpu_color)
    for i = 1, #add.color do
        table.insert(MOVE.now_koma_color, add.color[i])
        table.insert(MOVE.now_koma_put, add.pos[i])
    end

    --駒増えている
    MOVE.now_koma_count = MOVE.now_koma_count + 1
    --今の盤面を引く
    local put_enable = {}
    for i = 1, 64 do
        put_enable[i] = true
    end
    for i = #MOVE.now_koma_put - MOVE.now_koma_count + 1, #MOVE.now_koma_put do
        put_enable[MOVE.now_koma_put[i]] = false
    end
    local enable_flg = 0
    for i = 1, 64 do
        if put_enable[i] then
            enable_flg = PutEnable(0, i, MOVE.cpu_color)
            if enable_flg > 0 then
                break
            end
        end
    end

    MOVE.now_turn = MOVE.cpu_color
    --置ける駒ある
    if enable_flg ~= 0 then
        MOVE.now_turn = MOVE.cpu_color % 2 + 1
    end

    MOVE.reverse_time = 0
    vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(SYNC.koma_sync), ASSET.GetInstanceId())
    return 0
end
function CPU_result(board_inf, color, a, b, max_root, cpu_start, cpu_clock)
    --スコア返す
    if max_root <= 0 then
        cpu_clock = CPU_yield(cpu_start, cpu_clock)
        return CPU_score(board_inf, cpu_start, cpu_clock)
    end

    --設置可能場所
    local enable_pos = 0
    --64マス所分
    for i = 1, 64 do
        --置いてない場所である
        if board_inf[i] == 0 then
            cpu_clock = CPU_yield(cpu_start, cpu_clock)
            --時間過ぎた
            if cpu_clock < 0 then
                break
            end
            --置くことが可能である
            local data = PutEnableData(board_inf, i, color)
            if 0 ~= data then
                enable_pos = 1

                --各場所置いたときの最終的な最高スコア比較
                local ret = -CPU_result(data, color % 2 + 1, -b, -a, max_root - 1, cpu_start, cpu_clock)
                if a < ret then
                    a = ret
                    if a >= b then
                        return a
                    end
                end
            end
        end
    end
    --置ける駒なし
    if enable_pos == 0 then
        return -CPU_result(board_inf, color % 2 + 1, -b, -a, max_root - 1, cpu_start, cpu_clock)
    end

    return a
end

function CPU_score(board_inf, cpu_start, cpu_clock)
    local score1 = 0
    local score2 = 0
    local score3 = 0
    local col1 = 0
    local col2 = 0
    --善き
    local data = {
        {1, 2, 3, 4, 5, 6, 7, 8},
        {1, 10, 19, 28, 37, 46, 55, 64},
        {1, 9, 17, 25, 33, 41, 49, 57},
        {8, 7, 6, 5, 4, 3, 2, 1},
        {8, 15, 22, 29, 36, 43, 50, 57},
        {8, 16, 24, 32, 40, 48, 56, 64},
        {57, 58, 59, 60, 61, 62, 63, 64},
        {57, 50, 43, 36, 29, 22, 15, 8},
        {57, 49, 41, 33, 25, 17, 9, 1},
        {64, 63, 62, 61, 60, 59, 58, 57},
        {64, 55, 46, 37, 28, 19, 10, 1},
        {64, 56, 48, 40, 32, 24, 16, 8}
    }

    local data_flg = {table.unpack(data)}
    local data_flg2 = {table.unpack(data)}
    for i = 1, 64 do
        cpu_clock = CPU_yield(cpu_start, cpu_clock)
        for i2 = 1, #data do
            for i3 = 1, #data[i2] do
                --指定位置
                if data[i2][i3] == i then
                    if board_inf[i] == MOVE.cpu_color then
                        data_flg[i2][i3] = true
                        col1 = col1 + 1
                    else
                        data_flg2[i2][i3] = true
                        col2 = col2 + 1
                    end
                end
            end
        end
    end
    cpu_clock = CPU_yield(cpu_start, cpu_clock)
    for i2 = 1, #data_flg do
        local flgs = {false, false, false, false, false, false, false, false}
        local flgs2 = {false, false, false, false, false, false, false, false}
        local count = 0
        local count2 = 0
        for i3 = 1, #data_flg[i2] do
            if data_flg[i2][i3] == true then
                if board_inf[data_flg[i2][i3]] == MOVE.cpu_color then
                    flgs[i3] = true
                    count = count + 1
                elseif board_inf[data_flg[i2][i3]] == (MOVE.cpu_color % 2 + 1) then
                    flgs2[i3] = true
                    count2 = count2 + 1
                end
            end
        end

        cpu_clock = CPU_yield(cpu_start, cpu_clock)
        for i3 = 1, #flgs do
            local flg = false
            if i3 == 1 and flgs[i3] then
                score1 = score1 + 200
            end
            --角取っている
            if i3 ~= 1 then
                --2コマ目あり
                if flgs[i3] and not flg then
                    flg = true
                elseif flg and not flgs[i3] then
                    --2コマ目以降空白がある
                    if i3 >= 3 then
                        if flgs[2] and flgs[3] then
                            score1 = score1 - 5
                        end
                        if flgs[2] then
                            score1 = score1 - 2
                        end
                    end
                elseif flg and flgs2[i3] then
                    --2コマ目以降相手色がある
                    score1 = score1 - 1
                    break
                else
                    --1,2コマ目が空いている
                    if i3 >= 3 and i3 <= 8 then
                        if flgs[i3] then
                            score1 = score1 + 1
                        end
                    end
                end
            end

            if i3 == 1 and flgs2[i3] then
                score2 = score2 + 200
            end

            local flg2 = false
            --角取っている
            if i3 ~= 1 then
                --2コマ目あり
                if flgs2[i3] and not flg2 then
                    flg2 = true
                elseif flg2 and not flgs2[i3] then
                    --2コマ目以降空白がある
                    if i3 >= 3 then
                        if flgs2[2] and flgs2[3] then
                            score2 = score2 - 5
                        end
                        if flgs2[2] then
                            score2 = score2 - 2
                        end
                    end
                elseif flg and flgs[i3] then
                    --2コマ目以降相手色がある
                    score2 = score2 - 1
                    break
                else
                    --1,2コマ目が空いている
                    if i3 >= 3 and i3 <= 8 then
                        if flgs2[i3] then
                            score2 = score2 + 1
                        end
                    end
                end
            end
        end
    end

    score3 = 12 * col1 / col2
    return 2 * (score1 - score2) + score3
end
--CPU中でのyield処理用
function CPU_yield(CPU_start, CPU_clock)
    if CPU_clock == -1 then
        return -1
    end

    if (os.clock() - CPU_start) > 3.5 then
        coroutine.yield()
        return -1
    end

    if (os.clock() - CPU_clock) >= 1 / 90 then
        coroutine.yield()
        return os.clock()
    end

    return CPU_clock
end

--置けるか判断
function PutEnable(board_inf, dist_num, dist_col)
    --計算除外
    if dist_num == 0 or dist_col == 0 then
        return 0
    end

    --反転対象駒色
    local rev_col = dist_col % 2 + 1
    --今の盤面計算
    local now_board = {}
    --ボードデータ記入
    if board_inf ~= 0 then
        now_board = {table.unpack(board_inf)}
    else
        for i = 1, 64 do
            now_board[i] = 0
        end
        for i = #MOVE.now_koma_put - MOVE.now_koma_count + 1, #MOVE.now_koma_put do
            now_board[MOVE.now_koma_put[i]] = MOVE.now_koma_color[i]
        end
    end

    --立用
    local est1 = (dist_num - 1) % 8 + 1
    --横用
    local est2 = math.floor((dist_num - 1) / 8) + 1
    --上
    local flg = false
    if est1 >= 3 then
        for i = 1, est1 - 1 do
            --反転対象あり
            if now_board[dist_num - i] == rev_col then
                flg = true
            elseif flg then
                --挟める自分の駒あり
                if now_board[dist_num - i] == dist_col then
                    return dist_num
                else
                    --駒なし
                    break
                end
            else
                --挟む駒なし
                break
            end
        end
    end
    --下
    flg = false
    if est1 <= 6 then
        for i = 1, 8 - est1 do
            --反転対象あり
            if now_board[dist_num + i] == rev_col then
                flg = true
            elseif flg then
                --挟める自分の駒あり
                if now_board[dist_num + i] == dist_col then
                    return dist_num
                else
                    --駒なし
                    break
                end
            else
                --挟む駒なし
                break
            end
        end
    end
    --右
    flg = false
    if est2 <= 6 then
        for i = 1, 8 - est2 do
            --反転対象あり
            if now_board[dist_num + i * 8] == rev_col then
                flg = true
            elseif flg then
                --挟める自分の駒あり
                if now_board[dist_num + i * 8] == dist_col then
                    return dist_num
                else
                    --駒なし
                    break
                end
            else
                --挟む駒なし
                break
            end
        end
    end
    --左
    flg = false
    if est2 >= 3 then
        for i = 1, est2 - 1 do
            --反転対象あり
            if now_board[dist_num - i * 8] == rev_col then
                flg = true
            elseif flg then
                --挟める自分の駒あり
                if now_board[dist_num - i * 8] == dist_col then
                    return dist_num
                else
                    --駒なし
                    break
                end
            else
                --挟む駒なし
                break
            end
        end
    end
    --右上
    flg = false
    if est1 >= 3 and est2 <= 6 then
        for i = 1, 7 do
            local est_add = dist_num + i * (8 - 1)
            if est_add >= 1 and est_add <= 64 and (est1 - i) >= 1 and (est2 + i) <= 8 then
                --反転対象あり
                if now_board[est_add] == rev_col then
                    flg = true
                elseif flg then
                    --挟める自分の駒あり
                    if now_board[est_add] == dist_col then
                        return dist_num
                    else
                        --駒なし
                        break
                    end
                else
                    --挟む駒なし
                    break
                end
            else
                --挟む駒なし
                break
            end
        end
    end
    --右下
    flg = false
    if est1 <= 6 and est2 <= 6 then
        for i = 1, 7 do
            local est_add = dist_num + i * (8 + 1)
            if est_add >= 1 and est_add <= 64 and (est1 + i) <= 8 and (est2 + i) <= 8 then
                --反転対象あり
                if now_board[est_add] == rev_col then
                    flg = true
                elseif flg then
                    --挟める自分の駒あり
                    if now_board[est_add] == dist_col then
                        return dist_num
                    else
                        --駒なし
                        break
                    end
                else
                    --挟む駒なし
                    break
                end
            else
                --挟む駒なし
                break
            end
        end
    end
    --左上
    flg = false
    if est1 >= 3 and est2 >= 3 then
        for i = 1, 7 do
            local est_add = dist_num + i * (-8 - 1)
            if est_add >= 1 and est_add <= 64 and (est1 - i) >= 1 and (est2 - i) >= 1 then
                --反転対象あり
                if now_board[est_add] == rev_col then
                    flg = true
                elseif flg then
                    --挟める自分の駒あり
                    if now_board[est_add] == dist_col then
                        return dist_num
                    else
                        --駒なし
                        break
                    end
                else
                    --挟む駒なし
                    break
                end
            else
                --挟む駒なし
                break
            end
        end
    end
    --左下
    flg = false
    if est1 <= 6 and est2 >= 3 then
        for i = 1, 7 do
            local est_add = dist_num + i * (-8 + 1)
            if est_add >= 1 and est_add <= 64 and (est1 + i) <= 8 and (est2 - i) >= 1 then
                --反転対象あり
                if now_board[est_add] == rev_col then
                    flg = true
                elseif flg then
                    --挟める自分の駒あり
                    if now_board[est_add] == dist_col then
                        return dist_num
                    else
                        --駒なし
                        break
                    end
                else
                    --挟む駒なし
                    break
                end
            else
                --挟む駒なし
                break
            end
        end
    end

    return 0
end

--置けるか判断
function PutData(board_inf, dist_num, dist_col)
    --計算除外
    if dist_num == 0 or dist_col == 0 then
        return 0
    end

    --反転対象駒色
    local rev_col = dist_col % 2 + 1

    --今の盤面計算64マス
    local now_board = {}
    local ret_board = {}
    --今の盤面保存用
    local now_board_pos = 0
    local now_board_col = 0
    --ボードデータ記入
    if board_inf ~= 0 then
        now_board = {table.unpack(board_inf)}
        ret_board = {table.unpack(board_inf)}
    else
        for i = 1, 64 do
            now_board[i] = 0
            ret_board[i] = 0
        end
        now_board_pos = {}
        now_board_col = {}

        for i = #MOVE.now_koma_put - MOVE.now_koma_count + 1, #MOVE.now_koma_put do
            now_board[MOVE.now_koma_put[i]] = MOVE.now_koma_color[i]
            ret_board[MOVE.now_koma_put[i]] = MOVE.now_koma_color[i]
            table.insert(now_board_pos, MOVE.now_koma_put[i])
            table.insert(now_board_col, MOVE.now_koma_color[i])
            -- now_board_pos[#now_board_pos + 1] = MOVE.now_koma_put[i]
            --now_board_col[#now_board_col + 1] = MOVE.now_koma_color[i]
        end
    end

    local est1 = (dist_num - 1) % 8 + 1
    local est2 = math.floor((dist_num - 1) / 8) + 1
    --上
    local flg = false
    if est1 >= 3 then
        for i = 1, est1 - 1 do
            --反転対象あり
            if now_board[dist_num - i] == rev_col then
                flg = true
            elseif flg then
                --挟める自分の駒あり
                if now_board[dist_num - i] == dist_col then
                    --裏返す
                    for i2 = 1, i - 1 do
                        ret_board[dist_num - i2] = dist_col
                    end
                    break
                else
                    --駒なし
                    break
                end
            else
                --挟む駒なし
                break
            end
        end
    end
    --下
    flg = false
    if est1 <= 6 then
        for i = 1, 8 - est1 do
            --反転対象あり
            if now_board[dist_num + i] == rev_col then
                flg = true
            elseif flg then
                --挟める自分の駒あり
                if now_board[dist_num + i] == dist_col then
                    --裏返す
                    for i2 = 1, i - 1 do
                        ret_board[dist_num + i2] = dist_col
                    end
                    break
                else
                    --駒なし
                    break
                end
            else
                --挟む駒なし
                break
            end
        end
    end
    --右
    flg = false
    if est2 <= 6 then
        for i = 1, 8 - est2 do
            --反転対象あり
            if now_board[dist_num + i * 8] == rev_col then
                flg = true
            elseif flg then
                --挟める自分の駒あり
                if now_board[dist_num + i * 8] == dist_col then
                    --裏返す
                    for i2 = 1, i - 1 do
                        ret_board[dist_num + i2 * 8] = dist_col
                    end
                    break
                else
                    --駒なし
                    break
                end
            else
                --挟む駒なし
                break
            end
        end
    end
    --左
    flg = false
    if est2 >= 3 then
        for i = 1, est2 - 1 do
            --反転対象あり
            if now_board[dist_num - i * 8] == rev_col then
                flg = true
            elseif flg then
                --挟める自分の駒あり
                if now_board[dist_num - i * 8] == dist_col then
                    --裏返す
                    for i2 = 1, i - 1 do
                        ret_board[dist_num - i2 * 8] = dist_col
                    end
                    break
                else
                    --駒なし
                    break
                end
            else
                --挟む駒なし
                break
            end
        end
    end
    --右上
    flg = false
    if est1 >= 3 and est2 <= 6 then
        for i = 1, 7 do
            local est_add = dist_num + i * (8 - 1)
            if est_add >= 1 and est_add <= 64 and (est1 - i) >= 1 and (est2 + i) <= 8 then
                --反転対象あり
                if now_board[est_add] == rev_col then
                    flg = true
                elseif flg then
                    --挟める自分の駒あり
                    if now_board[est_add] == dist_col then
                        --裏返す
                        for i2 = 1, i - 1 do
                            ret_board[dist_num + i2 * (8 - 1)] = dist_col
                        end
                        break
                    else
                        --駒なし
                        break
                    end
                else
                    --挟む駒なし
                    break
                end
            else
                --挟む駒なし
                break
            end
        end
    end
    --右下
    flg = false
    if est1 <= 6 and est2 <= 6 then
        for i = 1, 7 do
            local est_add = dist_num + i * (8 + 1)
            if est_add >= 1 and est_add <= 64 and (est1 + i) <= 8 and (est2 + i) <= 8 then
                --反転対象あり
                if now_board[est_add] == rev_col then
                    flg = true
                elseif flg then
                    --挟める自分の駒あり
                    if now_board[est_add] == dist_col then
                        --裏返す
                        for i2 = 1, i - 1 do
                            ret_board[dist_num + i2 * (8 + 1)] = dist_col
                        end
                        break
                    else
                        --駒なし
                        break
                    end
                else
                    --挟む駒なし
                    break
                end
            else
                --挟む駒なし
                break
            end
        end
    end
    --左上
    flg = false
    if est1 >= 3 and est2 >= 3 then
        for i = 1, 7 do
            local est_add = dist_num + i * (-8 - 1)
            if est_add >= 1 and est_add <= 64 and (est1 - i) >= 1 and (est2 - i) >= 1 then
                --反転対象あり
                if now_board[est_add] == rev_col then
                    flg = true
                elseif flg then
                    --挟める自分の駒あり
                    if now_board[est_add] == dist_col then
                        --裏返す
                        for i2 = 1, i - 1 do
                            ret_board[dist_num + i2 * (-8 - 1)] = dist_col
                        end
                        break
                    else
                        --駒なし
                        break
                    end
                else
                    --挟む駒なし
                    break
                end
            else
                --挟む駒なし
                break
            end
        end
    end
    --左下
    flg = false
    if est1 <= 6 and est2 >= 3 then
        for i = 1, 7 do
            local est_add = dist_num + i * (-8 + 1)
            if est_add >= 1 and est_add <= 64 and (est1 + i) <= 8 and (est2 - i) >= 1 then
                --反転対象あり
                if now_board[est_add] == rev_col then
                    flg = true
                elseif flg then
                    --挟める自分の駒あり
                    if now_board[est_add] == dist_col then
                        --裏返す
                        for i2 = 1, i - 1 do
                            ret_board[dist_num + i2 * (-8 + 1)] = dist_col
                        end
                        break
                    else
                        --駒なし
                        break
                    end
                else
                    --挟む駒なし
                    break
                end
            else
                --挟む駒なし
                break
            end
        end
    end

    if board_inf ~= 0 then
        ret_board[dist_num] = dist_col
        return ret_board
    else
        --色更新
        for i = 1, #now_board_col do
            now_board_col[i] = ret_board[now_board_pos[i]]
        end

        table.insert(now_board_col, dist_col)
        table.insert(now_board_pos, dist_num)
        --now_board_col[#now_board_col + 1] = dist_col
        -- now_board_pos[#now_board_pos + 1] = dist_num

        return {color = now_board_col, pos = now_board_pos}
    end
end

--置けるか判断
function PutEnableData(board_inf, dist_num, dist_col)
    local ret_flg = false
    --反転対象駒色
    local rev_col = dist_col % 2 + 1

    --今の盤面計算64マス
    local now_board = board_inf
    local ret_board = {}
    --ボードデータ記入
    ret_board = {table.unpack(board_inf)}

    local est1 = (dist_num - 1) % 8 + 1
    local est2 = math.floor((dist_num - 1) / 8) + 1
    --上
    local flg = false
    if est1 >= 3 then
        for i = 1, est1 - 1 do
            --反転対象あり
            if now_board[dist_num - i] == rev_col then
                flg = true
            elseif flg then
                --挟める自分の駒あり
                if now_board[dist_num - i] == dist_col then
                    --裏返す
                    for i2 = 1, i - 1 do
                        ret_board[dist_num - i2] = dist_col
                    end
                    ret_flg = true
                    break
                else
                    --駒なし
                    break
                end
            else
                --挟む駒なし
                break
            end
        end
    end
    --下
    flg = false
    if est1 <= 6 then
        for i = 1, 8 - est1 do
            --反転対象あり
            if now_board[dist_num + i] == rev_col then
                flg = true
            elseif flg then
                --挟める自分の駒あり
                if now_board[dist_num + i] == dist_col then
                    --裏返す
                    for i2 = 1, i - 1 do
                        ret_board[dist_num + i2] = dist_col
                    end
                    ret_flg = true
                    break
                else
                    --駒なし
                    break
                end
            else
                --挟む駒なし
                break
            end
        end
    end
    --右
    flg = false
    if est2 <= 6 then
        for i = 1, 8 - est2 do
            --反転対象あり
            if now_board[dist_num + i * 8] == rev_col then
                flg = true
            elseif flg then
                --挟める自分の駒あり
                if now_board[dist_num + i * 8] == dist_col then
                    --裏返す
                    for i2 = 1, i - 1 do
                        ret_board[dist_num + i2 * 8] = dist_col
                    end
                    ret_flg = true
                    break
                else
                    --駒なし
                    break
                end
            else
                --挟む駒なし
                break
            end
        end
    end
    --左
    flg = false
    if est2 >= 3 then
        for i = 1, est2 - 1 do
            --反転対象あり
            if now_board[dist_num - i * 8] == rev_col then
                flg = true
            elseif flg then
                --挟める自分の駒あり
                if now_board[dist_num - i * 8] == dist_col then
                    --裏返す
                    for i2 = 1, i - 1 do
                        ret_board[dist_num - i2 * 8] = dist_col
                    end
                    ret_flg = true
                    break
                else
                    --駒なし
                    break
                end
            else
                --挟む駒なし
                break
            end
        end
    end
    --右上
    flg = false
    if est1 >= 3 and est2 <= 6 then
        for i = 1, 7 do
            local est_add = dist_num + i * (8 - 1)
            if est_add >= 1 and est_add <= 64 and (est1 - i) >= 1 and (est2 + i) <= 8 then
                --反転対象あり
                if now_board[est_add] == rev_col then
                    flg = true
                elseif flg then
                    --挟める自分の駒あり
                    if now_board[est_add] == dist_col then
                        --裏返す
                        for i2 = 1, i - 1 do
                            ret_board[dist_num + i2 * (8 - 1)] = dist_col
                        end
                        ret_flg = true
                        break
                    else
                        --駒なし
                        break
                    end
                else
                    --挟む駒なし
                    break
                end
            else
                --挟む駒なし
                break
            end
        end
    end
    --右下
    flg = false
    if est1 <= 6 and est2 <= 6 then
        for i = 1, 7 do
            local est_add = dist_num + i * (8 + 1)
            if est_add >= 1 and est_add <= 64 and (est1 + i) <= 8 and (est2 + i) <= 8 then
                --反転対象あり
                if now_board[est_add] == rev_col then
                    flg = true
                elseif flg then
                    --挟める自分の駒あり
                    if now_board[est_add] == dist_col then
                        --裏返す
                        for i2 = 1, i - 1 do
                            ret_board[dist_num + i2 * (8 + 1)] = dist_col
                        end
                        ret_flg = true
                        break
                    else
                        --駒なし
                        break
                    end
                else
                    --挟む駒なし
                    break
                end
            else
                --挟む駒なし
                break
            end
        end
    end
    --左上
    flg = false
    if est1 >= 3 and est2 >= 3 then
        for i = 1, 7 do
            local est_add = dist_num + i * (-8 - 1)
            if est_add >= 1 and est_add <= 64 and (est1 - i) >= 1 and (est2 - i) >= 1 then
                --反転対象あり
                if now_board[est_add] == rev_col then
                    flg = true
                elseif flg then
                    --挟める自分の駒あり
                    if now_board[est_add] == dist_col then
                        --裏返す
                        for i2 = 1, i - 1 do
                            ret_board[dist_num + i2 * (-8 - 1)] = dist_col
                        end
                        ret_flg = true
                        break
                    else
                        --駒なし
                        break
                    end
                else
                    --挟む駒なし
                    break
                end
            else
                --挟む駒なし
                break
            end
        end
    end
    --左下
    flg = false
    if est1 <= 6 and est2 >= 3 then
        for i = 1, 7 do
            local est_add = dist_num + i * (-8 + 1)
            if est_add >= 1 and est_add <= 64 and (est1 + i) <= 8 and (est2 - i) >= 1 then
                --反転対象あり
                if now_board[est_add] == rev_col then
                    flg = true
                elseif flg then
                    --挟める自分の駒あり
                    if now_board[est_add] == dist_col then
                        --裏返す
                        for i2 = 1, i - 1 do
                            ret_board[dist_num + i2 * (-8 + 1)] = dist_col
                        end
                        ret_flg = true
                        break
                    else
                        --駒なし
                        break
                    end
                else
                    --挟む駒なし
                    break
                end
            else
                --挟む駒なし
                break
            end
        end
    end

    if ret_flg then
        ret_board[dist_num] = dist_col
        return ret_board
    else
        return 0
    end
end

function Sync(num)
    if num == SYNC.sync then
        --入室時
        return {
            num = num,
            cpu_on = MOVE.cpu_on,
            now_turn = MOVE.now_turn,
            reverse_time = MOVE.reverse_time,
            now_koma_put = MOVE.now_koma_put,
            now_koma_color = MOVE.now_koma_color,
            now_koma_count = MOVE.now_koma_count,
            cpu_mode = MOVE.cpu_mode,
            cpu_first = MOVE.cpu_first,
            cpu_color = MOVE.cpu_color,
            join_enable = MOVE.join_enable,
            join_get = MOVE.join_get
        }
    elseif num == SYNC.cpu_on then
        --cpu起動
        return {
            num = num,
            cpu_on = MOVE.cpu_color
        }
    elseif num == SYNC.cpu_off then
        --cpu停止
        return {
            num = num,
            now_turn = MOVE.now_turn
        }
    elseif num == SYNC.cpu_sync then
        --cpu起動
        return {
            num = num,
            reverse_time = MOVE.reverse_time,
            now_turn = MOVE.now_turn,
            now_koma_put = MOVE.now_koma_put,
            now_koma_color = MOVE.now_koma_color,
            now_koma_count = MOVE.now_koma_count
        }
    elseif num == SYNC.tegoma1 then
        --黒手駒
        return {
            num = num
        }
    elseif num == SYNC.tegoma2 then
        --白手駒
        return {
            num = num
        }
    elseif num == SYNC.syokika then
        --初期化
        return {
            num = num
        }
    elseif num == SYNC.modoru then
        --戻る
        return {
            num = num
        }
    elseif num == SYNC.cpu then
        --CPU
        return {
            num = num
        }
    elseif num == SYNC.sentegote then
        --先手後手
        return {
            num = num
        }
    elseif num == SYNC.sirokuro then
        --白黒
        return {
            num = num
        }
    elseif num == SYNC.change_sync then
        --切替同期
        return {
            num = num,
            cpu_mode = MOVE.cpu_mode,
            cpu_first = MOVE.cpu_first,
            cpu_color = MOVE.cpu_color,
            join_enable = MOVE.join_enable,
            join_get = MOVE.join_get
        }
    elseif num == SYNC.koma_sync then
        --駒同期
        return {
            num = num,
            now_koma_count = MOVE.now_koma_count,
            now_koma_put = MOVE.now_koma_put,
            now_koma_color = MOVE.now_koma_color,
            now_turn = MOVE.now_turn,
            reverse_time = MOVE.reverse_time
        }
    elseif num == SYNC.bk_koma_put then
        --黒駒置く
        return {
            num = num,
            put_pos = MOVE.kari_put_pos
        }
    elseif num == SYNC.w_koma_put then
        --白駒置く
        return {
            num = num,
            put_pos = MOVE.kari_put_pos
        }
    elseif num == SYNC.button then
        --ボタン集める
        return {
            num = num
        }
    elseif num == SYNC.board then
        --ボタン集める
        return {
            num = num
        }
    elseif num == SYNC.name then
        --ボタン集める
        return {
            num = num,
            join_get = MOVE.join_get,
            join_name = MOVE.join_name,
           join_color = MOVE.join_color
        }
    elseif num == SYNC.comment then
        --ボタン集める
        return {
            num = num,
            join_enable = MOVE.join_enable
        }
    end
end
function SyncMess(sender, name, num)
    if num == SYNC.enter then
        --入室時
        if si.IsMine then
            vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(SYNC.sync), ASSET.GetInstanceId())
        end
    elseif num.num == SYNC.sync then
        MOVE.reverse_time = num.reverse_time
        MOVE.now_turn = num.now_turn
        MOVE.now_koma_put = num.now_koma_put
        MOVE.now_koma_color = num.now_koma_color
        MOVE.now_koma_count = num.now_koma_count

        MOVE.cpu_mode = num.cpu_mode
        MOVE.cpu_first = num.cpu_first
        MOVE.cpu_color = num.cpu_color
        MOVE.join_get = num.join_get
        MOVE.join_enable = num.join_enable
        --cpu起動中
        MOVE.cpu_on = num.cpu_on

        if MOVE.cpu_mode then
            ASSET.material._ALL_SetColor(DATA.str_si[DATA.str_cpu_num][1].GetName(), CHOSE_COL)
        else
            ASSET.material._ALL_SetColor(DATA.str_si[DATA.str_cpu_num][1].GetName(), DEF_COL)
        end
        if MOVE.cpu_first then
            ASSET.material._ALL_SetColor(DATA.str_si[DATA.str_sentegote_num][1].GetName(), CHOSE_COL)
        else
            ASSET.material._ALL_SetColor(DATA.str_si[DATA.str_sentegote_num][1].GetName(), DEF_COL)
        end
        if MOVE.cpu_color == DATA.koma_black then
            ASSET.material._ALL_SetColor(DATA.str_si[DATA.str_sirokuro_num][1].GetName(), CHOSE_COL)
        else
            ASSET.material._ALL_SetColor(DATA.str_si[DATA.str_sirokuro_num][1].GetName(), DEF_COL)
        end
        if MOVE.join_get then
            ASSET.material._ALL_SetColor(DATA.str_si[DATA.str_name_num][1].GetName(), CHOSE_COL)
        else
            ASSET.material._ALL_SetColor(DATA.str_si[DATA.str_name_num][1].GetName(), DEF_COL)
        end
        if MOVE.join_enable then
            ASSET.material._ALL_SetColor(DATA.str_si[DATA.str_comment_num][1].GetName(), CHOSE_COL)
        else
            ASSET.material._ALL_SetColor(DATA.str_si[DATA.str_comment_num][1].GetName(), DEF_COL)
        end
        MOVE.enter_flg = false
    elseif num.num == SYNC.cpu_on then
        --cpu起動
        MOVE.cpu_on = num.cpu_on
    elseif num.num == SYNC.cpu_off then
        --cpu停止
        MOVE.now_turn = num.now_turn
        MOVE.cpu_on = 0
    elseif num.num == SYNC.cpu_sync then
        --cpu同期
        MOVE.reverse_time = num.reverse_time
        MOVE.now_turn = num.now_turn
        MOVE.now_koma_put = num.now_koma_put
        MOVE.now_koma_color = num.now_koma_color
        MOVE.now_koma_count = num.now_koma_count
    elseif num.num == SYNC.tegoma1 then
        --黒手駒
        TegomaUp(DATA.koma_black)
    elseif num.num == SYNC.tegoma2 then
        --白手駒
        TegomaUp(DATA.koma_wite)
    elseif num.num == SYNC.syokika then
        --初期化
        if si.IsMine and MOVE.cpu_on == 0 then
            MOVE.now_koma_put = {28, 29, 36, 37}
            MOVE.now_koma_color = {DATA.koma_wite, DATA.koma_black, DATA.koma_black, DATA.koma_wite}
            MOVE.now_turn = 0
            MOVE.now_koma_count = 4
            MOVE.reverse_time = 0

            vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(SYNC.koma_sync), ASSET.GetInstanceId())
        end
    elseif num.num == SYNC.koma_sync then
        --cpu同期
        MOVE.now_koma_count = num.now_koma_count
        MOVE.reverse_time = num.reverse_time
        MOVE.now_turn = num.now_turn
        MOVE.now_koma_put = num.now_koma_put
        MOVE.now_koma_color = num.now_koma_color
    elseif num.num == SYNC.modoru then
        --戻る
        if si.IsMine and MOVE.cpu_on == 0 then
            if MOVE.now_koma_count > 4 then
                --戻したときの手番
                MOVE.now_turn = MOVE.now_koma_color[#MOVE.now_koma_color]
                local koma_pos = MOVE.now_koma_put[#MOVE.now_koma_put]
                local koma = DATA.str_si[DATA.str_koma_num][koma_pos]
                local koma2 = DATA.str_si[DATA.str_mini_koma_num][koma_pos]
                for i = 1, MOVE.now_koma_count do
                    table.remove(MOVE.now_koma_put, #MOVE.now_koma_put)
                    table.remove(MOVE.now_koma_color, #MOVE.now_koma_color)
                end
                MOVE.reverse_time = 0
                MOVE.now_koma_count = MOVE.now_koma_count - 1
                if MOVE.now_koma_count == 4 then
                    MOVE.now_turn = 0
                end

                vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(SYNC.koma_sync), ASSET.GetInstanceId())
            end
        end
    elseif num.num == SYNC.cpu then
        --CPU
        if si.IsMine and MOVE.cpu_on == 0 then
            MOVE.cpu_mode = not MOVE.cpu_mode
            if MOVE.cpu_mode then
                ASSET.material._ALL_SetColor(DATA.str_si[DATA.str_cpu_num][1].GetName(), CHOSE_COL)
            else
                ASSET.material._ALL_SetColor(DATA.str_si[DATA.str_cpu_num][1].GetName(), DEF_COL)
            end
            vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(SYNC.change_sync), ASSET.GetInstanceId())
        end
    elseif num.num == SYNC.sentegote then
        --先手後手
        if si.IsMine and MOVE.cpu_on == 0 then
            MOVE.cpu_first = not MOVE.cpu_first
            if MOVE.cpu_first then
                ASSET.material._ALL_SetColor(DATA.str_si[DATA.str_sentegote_num][1].GetName(), CHOSE_COL)
            else
                ASSET.material._ALL_SetColor(DATA.str_si[DATA.str_sentegote_num][1].GetName(), DEF_COL)
            end
            vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(SYNC.change_sync), ASSET.GetInstanceId())
        end
    elseif num.num == SYNC.sirokuro then
        --白黒
        if si.IsMine and MOVE.cpu_on == 0 then
            MOVE.cpu_color = MOVE.cpu_color % 2 + 1
            if MOVE.cpu_color == DATA.koma_black then
                ASSET.material._ALL_SetColor(DATA.str_si[DATA.str_sirokuro_num][1].GetName(), CHOSE_COL)
            else
                ASSET.material._ALL_SetColor(DATA.str_si[DATA.str_sirokuro_num][1].GetName(), DEF_COL)
            end
            vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(SYNC.change_sync), ASSET.GetInstanceId())
        end
    elseif num.num == SYNC.change_sync then
        --切替同期
        MOVE.cpu_mode = num.cpu_mode
        MOVE.cpu_first = num.cpu_first
        MOVE.cpu_color = num.cpu_color
        MOVE.join_enable = num.join_enable
    elseif num.num == SYNC.bk_koma_put then
        --黒駒置く
        if si.IsMine and MOVE.cpu_on == 0 and MOVE.now_turn ~= DATA.koma_wite and num.put_pos ~= 0 then
            --追加色取得
            local add = PutData(0, num.put_pos, DATA.koma_black)
            for i = 1, #add.color do
                table.insert(MOVE.now_koma_color, add.color[i])
                table.insert(MOVE.now_koma_put, add.pos[i])
            end

            MOVE.now_koma_count = MOVE.now_koma_count + 1
            --今の盤面を引く
            local put_enable = {}
            for i = 1, 64 do
                put_enable[i] = true
            end
            for i = #MOVE.now_koma_put - MOVE.now_koma_count + 1, #MOVE.now_koma_put do
                put_enable[MOVE.now_koma_put[i]] = false
            end
            local enable_flg = 0
            for i = 1, 64 do
                if put_enable[i] then
                    enable_flg = PutEnable(0, i, DATA.koma_wite)
                    if enable_flg > 0 then
                        break
                    end
                end
            end
            --置ける駒ある
            if enable_flg ~= 0 then
                MOVE.now_turn = DATA.koma_wite
            else
                MOVE.now_turn = DATA.koma_black
            end
            MOVE.reverse_time = 0
            vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(SYNC.koma_sync), ASSET.GetInstanceId())
        end
    elseif num.num == SYNC.w_koma_put then
        --白駒置く
        if si.IsMine and MOVE.cpu_on == 0 and MOVE.turn_num ~= DATA.koma_black and num.put_pos ~= 0 then
            --追加色取得
            local add = PutData(0, num.put_pos, DATA.koma_wite)
            for i = 1, #add.color do
                table.insert(MOVE.now_koma_color, add.color[i])
                table.insert(MOVE.now_koma_put, add.pos[i])
            end

            MOVE.now_koma_count = MOVE.now_koma_count + 1
            --今の盤面を引く
            local put_enable = {}
            for i = 1, 64 do
                put_enable[i] = true
            end
            for i = #MOVE.now_koma_put - MOVE.now_koma_count + 1, #MOVE.now_koma_put do
                put_enable[MOVE.now_koma_put[i]] = false
            end
            local enable_flg = 0
            for i = 1, 64 do
                if put_enable[i] then
                    enable_flg = PutEnable(0, i, DATA.koma_wite)
                    if enable_flg > 0 then
                        break
                    end
                end
            end
            --置ける駒ある
            if enable_flg ~= 0 then
                MOVE.now_turn = DATA.koma_black
            else
                MOVE.now_turn = DATA.koma_wite
            end
            MOVE.reverse_time = 0
            vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(SYNC.koma_sync), ASSET.GetInstanceId())
        end
    elseif num.num == SYNC.button then
        local buttun_to = DATA.str_si[DATA.str_button_num][1]
        local buttun_to_pos = buttun_to.GetPosition()
        for i = DATA.str_syokika_num, DATA.str_comment_num do
            local buttun = DATA.str_si[i][1]
            if buttun.IsMine then
                local add_pos =
                    Vector3.__new(0.3 * math.sin(i / 8 * 2 * math.pi), 0, 0.3 * math.cos(i / 8 * 2 * math.pi))
                buttun.SetPosition(buttun_to_pos + add_pos)
            end
        end
    elseif num.num == SYNC.board then
        local boarf_to = DATA.str_si[DATA.str_board_num][1]
        local boarf_to_pos = boarf_to.GetPosition()
        local boarf_to_rot = boarf_to.GetRotation()
        for i = DATA.str_syokika_num, DATA.str_comment_num do
            local buttun = DATA.str_si[i][1]
            if buttun.IsMine then
                local add_pos = Vector3.__new(0.2 * (i - 9.5), 0, 0.8)
                buttun.SetPosition(boarf_to_pos + boarf_to_rot * add_pos)
                buttun.SetRotation(boarf_to_rot)
            end
        end
    elseif num.num == SYNC.name then
        --先手後手
        if si.IsMine and MOVE.cpu_on == 0 then
            MOVE.join_get = not MOVE.join_get
            MOVE.join_name = num.join_name
            MOVE.join_color = num.join_color
            if MOVE.join_get then
                ASSET.material._ALL_SetColor(DATA.str_si[DATA.str_name_num][1].GetName(), CHOSE_COL)
            else
                ASSET.material._ALL_SetColor(DATA.str_si[DATA.str_name_num][1].GetName(), DEF_COL)
            end
            vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(SYNC.change_sync), ASSET.GetInstanceId())
        end
    elseif num.num == SYNC.comment then
        --コメント対応
        if si.IsMine and MOVE.cpu_on == 0 then
            MOVE.join_enable = not MOVE.join_enable
            if MOVE.join_enable then
                ASSET.material._ALL_SetColor(DATA.str_si[DATA.str_comment_num][1].GetName(), CHOSE_COL)
            else
                ASSET.material._ALL_SetColor(DATA.str_si[DATA.str_comment_num][1].GetName(), DEF_COL)
            end
            vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(SYNC.change_sync), ASSET.GetInstanceId())
        end
    end
end
vci.message.On(ASHU_MESS .. "SYNC", SyncMess)

function onMessage(sender, name, message)
    if si.IsMine and MOVE.cpu_on == 0 then
        if MOVE.join_enable then
            if MOVE.join_get then
                if message == "参加/黒" then
                    MOVE.join_name = sender["name"]
                    MOVE.join_color = DATA.koma_black
                    vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(SYNC.name), ASSET.GetInstanceId())
                elseif message == "参加/白" then
                    MOVE.join_name = sender["name"]
                    MOVE.join_color = DATA.koma_wite
                    vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(SYNC.name), ASSET.GetInstanceId())
                end
            else
                --指定名可能手番
                if MOVE.join_name == sender["name"] and (MOVE.now_turn == 0 or MOVE.join_color == MOVE.now_turn) then
                    MOVE.join_color = DATA.koma_black
                    local point_data1 = -1
                    local point_data2 = -1
                    local data1 = {"1", "2", "3", "4", "5", "6", "7", "8"}
                    local data2 = {"a", "b", "c", "d", "e", "f", "g", "h"}
                    message = string.sub(message, 1, 2)
                    for i = 1, #data1 do
                        if string.find(message, data1[i]) then
                            point_data1 = i
                            break
                        end
                    end
                    for i = 1, #data1 do
                        if string.find(message, data2[i]) then
                            point_data2 = (i - 1) * 8
                            break
                        end
                    end
                    if point_data1 ~= -1 and point_data2 ~= -1 then
                        local put_point = point_data1 + point_data2

                        if put_point == PutEnable(0, put_point, MOVE.join_color) then
                            --駒置く
                            --追加色取得
                            local add = PutData(0, put_point, MOVE.join_color)
                            for i = 1, #add.color do
                                table.insert(MOVE.now_koma_color, add.color[i])
                                table.insert(MOVE.now_koma_put, add.pos[i])
                            end

                            MOVE.now_koma_count = MOVE.now_koma_count + 1
                            --今の盤面を引く
                            local put_enable = {}
                            for i = 1, 64 do
                                put_enable[i] = true
                            end
                            for i = #MOVE.now_koma_put - MOVE.now_koma_count + 1, #MOVE.now_koma_put do
                                put_enable[MOVE.now_koma_put[i]] = false
                            end
                            local enable_flg = 0
                            for i = 1, 64 do
                                if put_enable[i] then
                                    enable_flg = PutEnable(0, i, DATA.koma_wite)
                                    if enable_flg > 0 then
                                        break
                                    end
                                end
                            end
                            MOVE.now_turn = MOVE.join_color % 2 + 1
                            --置ける駒ある
                            if enable_flg == 0 then
                                MOVE.now_turn = MOVE.join_color
                            end
                            MOVE.reverse_time = 0
                            vci.message.EmitWithId(ASHU_MESS .. "SYNC", Sync(SYNC.koma_sync), ASSET.GetInstanceId())
                        end
                    end
                end
            end
        end
    end
end

vci.message.On("comment", onMessage)
