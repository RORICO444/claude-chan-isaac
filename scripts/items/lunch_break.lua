-- Lunch Break (active, 6 charges) - DeepSeek-chan's pocket item
-- DeepSeek's famous "飯食ってくる / 去吃饭了" ("brb, getting food") reply.
-- Heals one red heart and puts the whole room on break: every enemy is slowed
-- for 3 seconds, and so are you, in the sense that you stop shooting for 3 s.

local Constants = include("scripts.constants")

local LunchBreak = {}

local HEAL = 2                 -- half hearts
local BREAK_FRAMES = 90        -- 3 s
local SLOW = 0.5
local SLOW_COLOR = Color(0.8, 0.9, 1, 1, 0, 0, 0)

function LunchBreak:Init(mod)
    mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, _, _, player)
        player:AddHearts(HEAL)
        player.FireDelay = math.max(player.FireDelay, BREAK_FRAMES)

        local ref = EntityRef(player)
        for _, entity in ipairs(Isaac.GetRoomEntities()) do
            local npc = entity:ToNPC()
            if npc and npc:IsVulnerableEnemy() and not npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
                npc:AddSlowing(ref, BREAK_FRAMES, SLOW, SLOW_COLOR)
            end
        end

        Game():GetHUD():ShowItemText("Brb, getting food", "Everyone's on lunch break")
        return true
    end, Constants.Item.LUNCH_BREAK)
end

return LunchBreak
