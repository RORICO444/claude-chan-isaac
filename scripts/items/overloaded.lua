-- 529 Overloaded (trinket)
-- Every 20 seconds in an uncleared room, everything goes down: all enemies
-- freeze for 2 seconds, and so do your tears. Meanwhile the status page
-- insists all systems are operational.

local Constants = include("scripts.constants")

local Overloaded = {}

local INTERVAL = 600     -- 20 seconds
local OUTAGE_FRAMES = 60 -- 2 seconds

function Overloaded:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
        if Constants.Trinket.OVERLOADED <= 0 or Game():GetRoom():IsClear() then return end
        if Game():GetRoom():GetFrameCount() % INTERVAL ~= INTERVAL - 1 then return end

        local holder
        for i = 0, Game():GetNumPlayers() - 1 do
            local player = Isaac.GetPlayer(i)
            if player:HasTrinket(Constants.Trinket.OVERLOADED) then
                holder = player
                player.FireDelay = math.max(player.FireDelay, OUTAGE_FRAMES)
            end
        end
        if not holder then return end

        local ref = EntityRef(holder)
        for _, entity in ipairs(Isaac.GetRoomEntities()) do
            local npc = entity:ToNPC()
            if npc and npc:IsVulnerableEnemy() and not npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
                npc:AddFreeze(ref, OUTAGE_FRAMES)
            end
        end
        Game():GetHUD():ShowItemText("529 Overloaded", "Status page: all systems operational")
    end)
end

return Overloaded
