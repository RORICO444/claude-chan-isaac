-- The higher the risk score, the tougher every enemy gets.
-- HP scales linearly from x1 at risk 0 to x3 at risk 100.

local EnemyScaling = {}

function EnemyScaling:Init(mod, Risk)
    mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc)
        if not npc:IsVulnerableEnemy() or npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
            return
        end

        local mult = 1 + Risk:Get() / 50
        npc.MaxHitPoints = npc.MaxHitPoints * mult
        npc.HitPoints = npc.MaxHitPoints
    end)
end

return EnemyScaling
