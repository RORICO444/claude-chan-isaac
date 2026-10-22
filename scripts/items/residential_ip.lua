-- Residential IP (passive)
-- On pickup: risk -30. While held: every risk increase is halved
-- (handled in Risk:Add).

local Constants = include("scripts.constants")

local ResidentialIp = {}

local PICKUP_REDUCTION = 30

function ResidentialIp:Init(mod, Risk)
    mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
        if Risk.state.residentialApplied or not player:HasCollectible(Constants.Item.RESIDENTIAL_IP) then
            return
        end

        Risk.state.residentialApplied = true
        Risk:Add(-PICKUP_REDUCTION)
    end)
end

return ResidentialIp
