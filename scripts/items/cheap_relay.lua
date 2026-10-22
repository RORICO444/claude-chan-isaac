-- 9.9 Yuan Relay (passive, devil pool)
-- A suspiciously cheap relay key. Damage x1.5, but in each room there is a
-- 30% chance you are quietly served a smaller model and deal x0.5 instead
-- ("掺水" / model swap). It is a shared relay, so picking it up adds 15 risk.

local Constants = include("scripts.constants")

local CheapRelay = {}

local BOOST_MULT = 1.5
local SWAPPED_MULT = 0.5
local SWAP_CHANCE = 0.3
local PICKUP_RISK = 15

function CheapRelay:Init(mod, Risk)
    local rng = RNG()

    mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
        rng:SetSeed(math.max(1, Game():GetSeeds():GetStartSeed() + 99), 35)
    end)

    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
        for i = 0, Game():GetNumPlayers() - 1 do
            local player = Isaac.GetPlayer(i)
            if player:HasCollectible(Constants.Item.CHEAP_RELAY) then
                local data = player:GetData()
                local swapped = rng:RandomFloat() < SWAP_CHANCE
                if swapped and not data.ccRelaySwapped then
                    Game():GetHUD():ShowItemText("Model quietly downgraded", "You get what you pay for")
                end
                data.ccRelaySwapped = swapped
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                player:EvaluateItems()
            end
        end
    end)

    mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
        if not Risk.state.relayApplied and player:HasCollectible(Constants.Item.CHEAP_RELAY) then
            Risk.state.relayApplied = true
            Risk:Add(PICKUP_RISK)
        end
    end)

    mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, flag)
        if flag == CacheFlag.CACHE_DAMAGE and player:HasCollectible(Constants.Item.CHEAP_RELAY) then
            local mult = player:GetData().ccRelaySwapped and SWAPPED_MULT or BOOST_MULT
            player.Damage = player.Damage * mult
        end
    end)
end

return CheapRelay
