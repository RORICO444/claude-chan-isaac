-- Ultrathink (active, recharges over 5 seconds)
-- Each use in the same room thinks harder: think (+1 damage), megathink (+2),
-- ultrathink (+3.1999, after the oddly specific 31,999-token budget).
-- But nobody is quite sure it does anything: 15% of the time it doesn't.
-- The bonus lasts until you leave the room.

local Constants = include("scripts.constants")

local Ultrathink = {}

local LEVELS = {
    { name = "think", bonus = 1 },
    { name = "megathink", bonus = 2 },
    { name = "ultrathink", bonus = 3.1999 },
}
local NOTHING_CHANCE = 0.15

function Ultrathink:Init(mod)
    local rng = RNG()

    mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
        rng:SetSeed(math.max(1, Game():GetSeeds():GetStartSeed() + 31999), 35)
    end)

    mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, _, _, player)
        local data = player:GetData()
        if rng:RandomFloat() < NOTHING_CHANCE then
            Game():GetHUD():ShowItemText("Thought for 0s", "Did that even do anything?")
            return true
        end

        data.ccThink = math.min(#LEVELS, (data.ccThink or 0) + 1)
        local level = LEVELS[data.ccThink]
        Game():GetHUD():ShowItemText(level.name, string.format("Damage +%s this room", level.bonus))
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        player:EvaluateItems()
        return true
    end, Constants.Item.ULTRATHINK)

    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
        for i = 0, Game():GetNumPlayers() - 1 do
            local player = Isaac.GetPlayer(i)
            if player:GetData().ccThink then
                player:GetData().ccThink = nil
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                player:EvaluateItems()
            end
        end
    end)

    mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, flag)
        local level = player:GetData().ccThink
        if flag == CacheFlag.CACHE_DAMAGE and level then
            player.Damage = player.Damage + LEVELS[level].bonus
        end
    end)
end

return Ultrathink
