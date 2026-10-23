-- Manual Repentance/Repentance+ probe; run only by an explicit developer callback.
-- Console: lua Isaac.RunCallback("ClaudeChan:RunRuntimeProbe")
-- Use only an owned disposable DeepSeek stage-1 run.
-- It changes test coins/risk, adds Car Battery, changes floors and round-trips this
-- mod's own run save. It performs no OS, network or other-mod configuration calls.
local Probe = {}
function Probe:Run(owner, risk, storyStart)
assert(Game():GetLevel():GetStage() == 1, "Start a disposable stage-1 test run")
assert(Isaac.GetPlayer(0):GetPlayerType() == Isaac.GetPlayerTypeByName("DeepSeek-chan", false),
    "Use a disposable DeepSeek-chan test run")
assert(not owner.ccProbeRunning, "A runtime probe is already running")
owner.ccProbeRunning = true
local probe = RegisterMod("CC manual runtime probe", 1)
local player = Isaac.GetPlayer(0)
local started, useUntil, phase, captionAt = Game():GetFrameCount(), 0, 0, 0
local slot = ActiveSlot.SLOT_POCKET
local function log(message)
    print("CCQA " .. message)
    Isaac.DebugString("CCQA " .. message)
end
local function fixture(coins)
    player:AddCoins(coins - player:GetNumCoins())
    risk.state.risk = 50
    player:SetActiveCharge(6, slot)
    useUntil = Game():GetFrameCount() + 15
end
local function input(_, entity, hook, action)
    if entity and entity.Type == EntityType.ENTITY_PLAYER
        and action == ButtonAction.ACTION_PILLCARD and Game():GetFrameCount() <= useUntil then
        if hook == InputHook.GET_ACTION_VALUE then return 1 end
        return true
    end
end
local update, exiting
local function stop(message)
    probe:RemoveCallback(ModCallbacks.MC_INPUT_ACTION, input)
    probe:RemoveCallback(ModCallbacks.MC_POST_UPDATE, update)
    probe:RemoveCallback(ModCallbacks.MC_PRE_GAME_EXIT, exiting)
    owner.ccProbeRunning = false
    log(message)
end
local function tick()
    local frame = Game():GetFrameCount()
    if phase == 0 then
        fixture(2); phase = 1; started = frame
    elseif phase == 1 and frame >= started + 30 then
        assert(player:GetNumCoins() == 2 and risk:Get() == 50 and player:GetActiveCharge(slot) == 6,
            "Positive-risk insufficient funds spent coins/risk/charge")
        log("PASS insufficient funds: coins=2 risk=50 charge=6")
        if not player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
            player:AddCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY)
        end
        fixture(6); phase = 2; started = frame
    elseif phase == 2 and frame >= started + 30 then
        assert(player:GetNumCoins() == 3 and risk:Get() == 30 and player:GetActiveCharge(slot) == 0,
            "Car Battery did not produce exactly one payment/reduction/discharge")
        log("PASS Car Battery: coins=3 risk=30 charge=0")
        risk.state.storySeen, risk.state.storyPending, risk.state.reviewApproved = 1, {}, true
        storyStart(owner, true)
        Isaac.ExecuteCommand("stage 3")
        phase, captionAt = 3, frame
    elseif phase == 3 and frame >= captionAt + 15 then
        assert((risk.state.storySeen == 3 or risk.state.storySeen == 9)
            and #risk.state.storyPending == 1, "Same-frame room/floor captions were dropped")
        log("PASS simultaneous captions: seen=" .. risk.state.storySeen .. " pending=1")
        phase = 4
    elseif phase == 4 and frame >= captionAt + 90 then
        local before = risk.state.storySeen
        risk:Save(owner); risk:Load(owner)
        assert(risk.state.storySeen == before and #risk.state.storyPending == 1,
            "Engine JSON save/load lost pending caption")
        storyStart(owner, true)
        assert(risk.state.storySeen == 11 and #risk.state.storyPending == 0,
            "Continue did not resume the unseen pending caption")
        log("PASS queue save/load: seen=11 pending=0")
        phase = 5
    elseif phase == 5 and frame >= captionAt + 315 then
        assert(risk.state.storySeen == 11 and #risk.state.storyPending == 0)
        stop("PASS complete; temporary input callbacks removed")
    end
end
update = function()
    local ok, message = pcall(tick)
    if not ok then stop("FAIL " .. tostring(message)) end
end
exiting = function() stop("STOP run exited before probe completion") end
probe:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, exiting)
probe:AddCallback(ModCallbacks.MC_INPUT_ACTION, input)
probe:AddCallback(ModCallbacks.MC_POST_UPDATE, update)
log("START owned stage-1 DeepSeek probe")

end
return Probe
