-- Gameplay prototype with a custom generated sprite atlas; see docs/ART_GENERATION.md.
local Constants = include("scripts.constants")
local DeepSeek = {}

local function isDeepSeek(player)
    return Constants.Player.DEEPSEEK_CHAN >= 0
        and player:GetPlayerType() == Constants.Player.DEEPSEEK_CHAN
end

function DeepSeek:Init(mod, Risk)
    local roomHit = false
    mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, continued)
        roomHit = false
        if continued or Constants.Item.SUPPORT_TICKET <= 0 then return end
        for i = 0, Game():GetNumPlayers() - 1 do
            local player = Isaac.GetPlayer(i)
            if isDeepSeek(player) then
                player:SetPocketActiveItem(Constants.Item.SUPPORT_TICKET, ActiveSlot.SLOT_POCKET, false)
            end
        end
    end)
    mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, flag)
        if not isDeepSeek(player) then return end
        if flag == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage * 0.85
        elseif flag == CacheFlag.CACHE_FIREDELAY then
            player.MaxFireDelay = math.max(1, (player.MaxFireDelay + 1) * 0.85) - 1
        elseif flag == CacheFlag.CACHE_TEARCOLOR then
            player.TearColor = Color(0.35, 0.65, 1, 1, 0, 0, 0)
        end
    end)
    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function() roomHit = false end)
    mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function() roomHit = true end,
        EntityType.ENTITY_PLAYER)
    mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, function()
        if roomHit then return end
        for i = 0, Game():GetNumPlayers() - 1 do
            if isDeepSeek(Isaac.GetPlayer(i)) then
                Risk:Add(-2) -- Once for the shared meter, even with multiple DeepSeek players.
                return
            end
        end
    end)
end

return DeepSeek
