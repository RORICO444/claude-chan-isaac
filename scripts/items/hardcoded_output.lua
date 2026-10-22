-- Hardcoded Output (trinket)
-- Special-casing the test: every tear deals exactly 3.5 damage, the expected
-- output, no matter how strong or weak you actually are.

local Constants = include("scripts.constants")

local HardcodedOutput = {}

local EXPECTED_DAMAGE = 3.5

function HardcodedOutput:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, tear)
        local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
        if player and player:HasTrinket(Constants.Trinket.HARDCODED_OUTPUT) then
            tear.CollisionDamage = EXPECTED_DAMAGE
        end
    end)
end

return HardcodedOutput
