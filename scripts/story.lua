-- Short, non-blocking fan-fiction chapters. Progress lives in the run save.
local HudText = include("scripts.hud_text")
local Story = {}

function Story:Init(mod, Risk)
    local active, timer, ready
    local function chapter()
        local stage = Game():GetLevel():GetStage()
        local key = Risk.state.reviewApproved and "story_review"
            or (stage >= 5 and "story_3" or stage >= 3 and "story_2" or "story_1")
        local bit = ({ story_1 = 1, story_2 = 2, story_3 = 4, story_review = 8 })[key]
        local seen = type(Risk.state.storySeen) == "number" and Risk.state.storySeen or 0
        if (seen & bit) == 0 then
            Risk.state.storySeen = seen | bit
            active, timer = key, 210
        end
    end
    mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
        active, timer, ready = nil, 0, true
        chapter()
    end)
    mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
        if ready then chapter() end
    end)
    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
        if ready and Risk.state.reviewApproved then chapter() end
    end)
    mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
        if timer and timer > 0 then timer = timer - 1 end
    end)
    mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
        if not ready or not active or timer <= 0 or not Game():GetHUD():IsVisible() then return end
        local y = Isaac.GetScreenHeight() - 78
        HudText:Draw(HudText:T(active .. "_title"), 100, y, 1, 0.8, 0.5, 0.9)
        HudText:Draw(HudText:T(active .. "_line"), 100, y + 12, 1, 1, 1, 0.9)
    end)
    mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, function()
        active, timer, ready = nil, 0, false
    end)
end

return Story
