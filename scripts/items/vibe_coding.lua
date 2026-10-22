-- Vibe Coding (passive)
-- Every tear gets a random effect (homing, piercing, spectral, poison or slow),
-- and 5% of tears are bugs that fly backwards. Each new floor the API bill
-- arrives and you lose a quarter of your coins.

local Constants = include("scripts.constants")

local VibeCoding = {}

local BUG_CHANCE = 0.05
local BILL_SHARE = 0.25

local EFFECTS = {
    TearFlags.TEAR_HOMING,
    TearFlags.TEAR_PIERCING,
    TearFlags.TEAR_SPECTRAL,
    TearFlags.TEAR_POISON,
    TearFlags.TEAR_SLOW,
}

function VibeCoding:Init(mod)
    local rng = RNG()

    mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
        rng:SetSeed(math.max(1, Game():GetSeeds():GetStartSeed() + 1986), 35)
    end)

    mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, tear)
        local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
        if not player or not player:HasCollectible(Constants.Item.VIBE_CODING) then
            return
        end

        if rng:RandomFloat() < BUG_CHANCE then
            tear.Velocity = tear.Velocity * -1
        else
            tear:AddTearFlags(EFFECTS[rng:RandomInt(#EFFECTS) + 1])
        end
    end)

    mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
        for i = 0, Game():GetNumPlayers() - 1 do
            local player = Isaac.GetPlayer(i)
            local bill = math.floor(player:GetNumCoins() * BILL_SHARE)
            if player:HasCollectible(Constants.Item.VIBE_CODING) and bill > 0 then
                player:AddCoins(-bill)
                Game():GetHUD():ShowItemText("API bill", string.format("-%d coins", bill))
            end
        end
    end)
end

return VibeCoding
