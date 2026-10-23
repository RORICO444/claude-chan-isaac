-- Relay Slime (enemy, placeholder version)
-- A shared proxy: one IP, many users. When it dies it splits into two smaller
-- slimes, which split once more: one slime becomes up to seven.
--
-- Placeholder: built on the vanilla Clotty with a green tint until the real
-- sprite exists. Spawns in uncleared rooms once risk reaches 30 (25% per room).

local RelaySlime = {}

local MIN_RISK = 30
local SPAWN_CHANCE = 0.25
local MAX_GENERATION = 2
local SLIME_COLOR = Color(0.5, 1, 0.6, 1, 0, 0.1, 0)
local SCALES = { [0] = 1.2, [1] = 0.9, [2] = 0.65 }

local function spawnSlime(position, generation)
    local npc = Isaac.Spawn(EntityType.ENTITY_CLOTTY, 0, 0, position, Vector.Zero, nil):ToNPC()
    if not npc then return end

    local data = npc:GetData()
    data.ccRelaySlime = generation
    data.ccHydra = true -- never also respawns through the hydra mechanic
    npc.Color = SLIME_COLOR
    npc.Scale = SCALES[generation]
    npc.MaxHitPoints = npc.MaxHitPoints * (1 - generation * 0.3)
    npc.HitPoints = npc.MaxHitPoints
end

function RelaySlime:Init(mod, Risk)
    local rng = RNG()

    mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
        rng:SetSeed(math.max(1, Game():GetSeeds():GetStartSeed() + 8080), 35)
    end)

    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
        local room = Game():GetRoom()
        if room:IsClear() or Risk:Get() < MIN_RISK or rng:RandomFloat() >= SPAWN_CHANCE then
            return
        end
        spawnSlime(Isaac.GetFreeNearPosition(room:GetCenterPos(), 40), 0)
    end)

    mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, function(_, entity)
        local data = entity:GetData()
        local generation = data.ccRelaySlime
        -- A Ban Hammer ban is permanent: a banned relay doesn't split into new accounts.
        if generation == nil or generation >= MAX_GENERATION or data.ccBanned then
            return
        end
        for _ = 1, 2 do
            spawnSlime(Isaac.GetFreeNearPosition(entity.Position, 20), generation + 1)
        end
    end)
end

return RelaySlime
