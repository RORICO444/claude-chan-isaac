-- "Hydra cluster": once the risk score is high enough, a killed enemy may
-- come straight back as a freshly registered account (tinted red).
-- Each enemy respawns at most once, and Ban Hammer kills never respawn.

local Constants = include("scripts.constants")

local Hydra = {}

local HYDRA_COLOR = Color(1, 0.5, 0.5, 1, 0, 0, 0)

function Hydra:Init(mod, Risk)
    local rng = RNG()

    mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
        rng:SetSeed(math.max(1, Game():GetSeeds():GetStartSeed()), 35)
    end)

    mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, function(_, entity)
        local npc = entity:ToNPC()
        -- CanShutDoors filters out fireplaces, shopkeepers and other non-enemy NPCs.
        if not npc or not npc.CanShutDoors or npc:IsBoss() or npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
            return
        end

        local risk = Risk:Get()
        local data = npc:GetData()
        if risk < Constants.HYDRA_MIN_RISK or data.ccHydra or data.ccBanned then
            return
        end

        -- 10% at risk 40, up to 50% at risk 100.
        local chance = (risk - Constants.HYDRA_MIN_RISK) / 150 + 0.1
        if rng:RandomFloat() >= chance then
            return
        end

        local clone = Isaac.Spawn(npc.Type, npc.Variant, npc.SubType, npc.Position, Vector.Zero, nil):ToNPC()
        if clone then
            clone:GetData().ccHydra = true
            clone.Color = HYDRA_COLOR
        end
    end)
end

return Hydra
