-- Thinking Cleared (trinket)
-- Based on the reported cache bug that wiped the thinking every turn: Claude
-- kept working, but forgot why. Each new room, your active item loses one
-- charge, but you get +1 damage for that room: still working, no idea why.

local Constants = include("scripts.constants")

local ThinkingCleared = {}

local ROOM_DAMAGE = 1

function ThinkingCleared:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
        for i = 0, Game():GetNumPlayers() - 1 do
            local player = Isaac.GetPlayer(i)
            local data = player:GetData()
            local holds = player:HasTrinket(Constants.Trinket.THINKING_CLEARED)

            if holds then
                local charge = player:GetActiveCharge(ActiveSlot.SLOT_PRIMARY)
                if charge > 0 then
                    player:SetActiveCharge(charge - 1, ActiveSlot.SLOT_PRIMARY)
                end
            end

            if holds ~= (data.ccThinkingCleared == true) then
                data.ccThinkingCleared = holds
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                player:EvaluateItems()
            end
        end
    end)

    mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, flag)
        if flag == CacheFlag.CACHE_DAMAGE and player:GetData().ccThinkingCleared then
            player.Damage = player.Damage + ROOM_DAMAGE
        end
    end)
end

return ThinkingCleared
