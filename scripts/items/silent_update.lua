-- Silent Update (passive)
-- Based on the "降智" (did they nerf it?) complaints: behaviour changes that
-- never showed up in the changelog. Every new floor quietly rescales your
-- damage to somewhere between x0.8 and x1.3, and the game only ever tells you
-- "Changelog: no changes".

local Constants = include("scripts.constants")

local SilentUpdate = {}

local MIN_MULT = 0.8
local MAX_MULT = 1.3

local function refresh(player)
    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    player:EvaluateItems()
end

function SilentUpdate:Init(mod, Risk)
    local function roll()
        -- NEW_LEVEL precedes GAME_STARTED; seed at the point of use, not later.
        -- A floor seed also makes save/continue independent of RNG draw history.
        local level = Game():GetLevel()
        local stageType = level.GetStageType and level:GetStageType() or 0
        local rng = RNG()
        rng:SetSeed(math.max(1, Game():GetSeeds():GetStartSeed()
            + level:GetStage() * 4040 + stageType * 97), 35)
        Risk.state.silentMult = MIN_MULT + rng:RandomFloat() * (MAX_MULT - MIN_MULT)
        for i = 0, Game():GetNumPlayers() - 1 do
            local player = Isaac.GetPlayer(i)
            if player:HasCollectible(Constants.Item.SILENT_UPDATE) then
                refresh(player)
                Game():GetHUD():ShowItemText("Changelog: no changes", "")
            end
        end
    end

    mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, continued)
        if not continued then roll() end
        for i = 0, Game():GetNumPlayers() - 1 do
            local player = Isaac.GetPlayer(i)
            if player:HasCollectible(Constants.Item.SILENT_UPDATE) then refresh(player) end
        end
    end)

    mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, roll)

    mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, flag)
        if flag == CacheFlag.CACHE_DAMAGE and player:HasCollectible(Constants.Item.SILENT_UPDATE) then
            player.Damage = player.Damage * (Risk.state.silentMult or 1)
        end
    end)
end

return SilentUpdate
