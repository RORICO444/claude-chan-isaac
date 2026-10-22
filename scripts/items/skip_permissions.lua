-- --dangerously-skip-permissions (passive)
-- No more permission prompts: entering a room unlocks its locked doors and
-- opens locked chests for free. But with nobody checking, each room has a
-- 10% chance of an "rm -rf": every pickup on the floor of that room is deleted
-- (item pedestals are spared).

local Constants = include("scripts.constants")

local SkipPermissions = {}

local RM_RF_CHANCE = 0.1

function SkipPermissions:Init(mod)
    local rng = RNG()

    mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
        rng:SetSeed(math.max(1, Game():GetSeeds():GetStartSeed() + 777), 35)
    end)

    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
        local holder
        for i = 0, Game():GetNumPlayers() - 1 do
            local player = Isaac.GetPlayer(i)
            if player:HasCollectible(Constants.Item.SKIP_PERMISSIONS) then
                holder = player
                break
            end
        end
        if not holder then return end

        local room = Game():GetRoom()
        for slot = 0, DoorSlot.NUM_DOOR_SLOTS - 1 do
            local door = room:GetDoor(slot)
            if door and door:IsLocked() then
                door:TryUnlock(holder, true)
            end
        end

        local rmrf = rng:RandomFloat() < RM_RF_CHANCE
        for _, entity in ipairs(Isaac.GetRoomEntities()) do
            local pickup = entity:ToPickup()
            if pickup and pickup.Variant ~= PickupVariant.PICKUP_COLLECTIBLE then
                if rmrf then
                    pickup:Remove()
                elseif pickup.Variant == PickupVariant.PICKUP_LOCKEDCHEST then
                    pickup:TryOpenChest(holder)
                end
            end
        end

        if rmrf then
            Game():GetHUD():ShowItemText("rm -rf ./*", "Nobody asked for permission")
        end
    end)
end

return SkipPermissions
