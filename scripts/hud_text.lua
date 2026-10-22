-- HUD text in the game's language (English / Simplified Chinese / Japanese).
--
-- The default RenderText font has no CJK glyphs, so Chinese and Japanese need
-- a CJK font. Repentance ships one for its own translations; the exact path is
-- unconfirmed, so we try candidates and fall back to English when none loads.

local HudText = {}

local FONT_CANDIDATES = {
    "font/cjk/lanapixel.fnt",
}

local STRINGS = {
    en = {
        story_1_title = "1. The shared address",
        story_1_line = "Claude: Same IP. Different people. One ban.",
        story_2_title = "2. A welcome notice",
        story_2_line = "DeepSeek: Let them in. Then ask what happened.",
        story_3_title = "3. Review pending",
        story_3_line = "The queue gets longer. Keep the ticket.",
        story_review_title = "4. A human finally read it",
        story_review_line = "Appeal accepted. The dungeon still needs clearing.",
        ip = "IP %s  (shared by %d)",
        risk = "Risk %d / %d  [%s]",
        operational = "Risk: all systems operational",
        usage = "Usage %d%%",
        limited = "Usage limit reached (%ds)",
        Clean = "Clean", Suspicious = "Suspicious", Flagged = "Flagged", Suspended = "Suspended",
    },
    zh = {
        story_1_title = "一、共享地址",
        story_1_line = "Claude：同一个IP，不同的人，同一封封号信。",
        story_2_title = "二、欢迎通知",
        story_2_line = "DeepSeek：先让她们进来，再问发生了什么。",
        story_3_title = "三、等待复核",
        story_3_line = "队伍越来越长。把工单留好。",
        story_review_title = "四、终于有人看了",
        story_review_line = "申诉通过。地牢还得自己打。",
        ip = "IP %s（%d人共享）",
        risk = "风控值 %d / %d  [%s]",
        operational = "风控值：所有系统运行正常",
        usage = "用量 %d%%",
        limited = "已达用量上限（%d秒）",
        Clean = "纯净", Suspicious = "可疑", Flagged = "高风险", Suspended = "已封禁",
    },
    ja = {
        story_1_title = "一、共有アドレス",
        story_1_line = "Claude：同じIP。違う人。同じBAN通知。",
        story_2_title = "二、ようこそ通知",
        story_2_line = "DeepSeek：まず迎えよう。事情はそのあと。",
        story_3_title = "三、審査待ち",
        story_3_line = "列は伸びるばかり。チケットは大切に。",
        story_review_title = "四、やっと人が読んだ",
        story_review_line = "異議は認められた。地下室の攻略は続く。",
        ip = "IP %s（%d人で共有）",
        risk = "リスク値 %d / %d  [%s]",
        operational = "リスク値：全システム正常",
        usage = "使用量 %d%%",
        limited = "利用上限に到達（%d秒）",
        Clean = "クリーン", Suspicious = "要注意", Flagged = "高リスク", Suspended = "停止中",
    },
}

local font
local lang

local function detectLanguage()
    local ok, value = pcall(function() return Options.Language end)
    if not ok or type(value) ~= "string" then return "en" end
    value = value:lower()
    if value:find("^zh") then return "zh" end
    if value:find("^ja") or value:find("^jp") then return "ja" end
    return "en"
end

local function init()
    if lang then return end
    lang = detectLanguage()
    if lang == "en" then return end

    for _, path in ipairs(FONT_CANDIDATES) do
        local f = Font()
        f:Load(path)
        if f:IsLoaded() then
            font = f
            return
        end
    end
    lang = "en" -- no CJK font available
end

-- Localised string for `key`, formatted with any extra arguments.
function HudText:T(key, ...)
    init()
    local s = STRINGS[lang][key] or STRINGS.en[key] or key
    if select("#", ...) > 0 then
        return string.format(s, ...)
    end
    return s
end

function HudText:Draw(text, x, y, r, g, b, a)
    init()
    if font then
        font:DrawStringUTF8(text, x, y - 2, KColor(r, g, b, a), 0, false)
    else
        Isaac.RenderText(text, x, y, r, g, b, a)
    end
end

return HudText
