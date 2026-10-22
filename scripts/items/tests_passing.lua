-- All Tests Passing (active, 6 charges)
-- Reward hacking: instead of fixing the room, mark it as passed. The room
-- counts as cleared and every door opens, but the enemies are still there.

local Constants = include("scripts.constants")

local TestsPassing = {}

function TestsPassing:Init(mod)
    mod:AddCallback(ModCallbacks.MC_USE_ITEM, function()
        local room = Game():GetRoom()
        room:SetClear(true)
        for slot = 0, DoorSlot.NUM_DOOR_SLOTS - 1 do
            local door = room:GetDoor(slot)
            if door then
                door:Open()
            end
        end

        Game():GetHUD():ShowItemText("All tests passing", "(assertions removed)")
        return true
    end, Constants.Item.TESTS_PASSING)
end

return TestsPassing
