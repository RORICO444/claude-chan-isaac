-- A manual appeal: pay three coins for a guaranteed twenty-point risk reduction.
local Constants = include("scripts.constants")
local Ticket = {}

function Ticket:Init(mod, Risk)
    mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, _, _, player, flags)
        -- Car Battery must not bill a second time for one activation.
        if UseFlag and flags and (flags & UseFlag.USE_CARBATTERY) ~= 0 then
            return { Discharge = false, ShowAnim = false }
        end
        if player:GetNumCoins() < 3 or Risk:Get() <= 0 then
            return { Discharge = false, ShowAnim = false }
        end
        player:AddCoins(-3)
        Risk:Add(-20)
        Risk.state.reviewApproved = true
        return { Discharge = true, ShowAnim = true }
    end, Constants.Item.SUPPORT_TICKET)
end

return Ticket
