-- Tainted Claude-chan (裏Claudeちゃん) - "Weekly Limit" (周限额)
-- Character design by ZipZipPipe, used non-commercially with credit.
--
-- Based on the weekly-limit complaints on X (limits cut to a share of total
-- usage, "banked" resets). Instead of the normal 5-hour usage meter she has
-- a hard quota per floor: 220 tears. Past it, every tear deals 25% damage
-- until the next floor. In exchange: damage x1.25, Range +1.5, Shot Speed +0.2.
-- Pocket item: Banked Reset, which also refills the quota.

local Constants = include("scripts.constants")
local HudText = include("scripts.hud_text")

local TaintedClaude = {}

local WEEKLY_LIMIT = 220
local DAMAGE_MULT = 1.25
local OVER_LIMIT_DAMAGE = 0.25

local TEAR_COLOR = Color(0.85, 0.3, 0.2, 1, 0, 0, 0)
local OVER_LIMIT_COLOR = Color(0.4, 0.4, 0.4, 0.7, 0, 0, 0)

local function isTainted(player)
    return player and Constants.Player.CLAUDE_CHAN_B >= 0
        and player:GetPlayerType() == Constants.Player.CLAUDE_CHAN_B
end

function TaintedClaude:Init(mod, Risk)
    local ready = false
    local function used() return Risk.state.weeklyUsed or 0 end

    mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, isContinued)
        ready = true
        if isContinued or Constants.Item.BANKED_RESET <= 0 then return end
        for i = 0, Game():GetNumPlayers() - 1 do
            local player = Isaac.GetPlayer(i)
            if isTainted(player) then
                player:SetPocketActiveItem(Constants.Item.BANKED_RESET, ActiveSlot.SLOT_POCKET, false)
            end
        end
    end)
    mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, function() ready = false end)

    -- A new floor is a new week.
    mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
        if ready then Risk.state.weeklyUsed = 0 end
    end)

    mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, flag)
        if not isTainted(player) then return end
        if flag == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage * DAMAGE_MULT
        elseif flag == CacheFlag.CACHE_RANGE then
            player.TearRange = player.TearRange + 1.5 * 40
        elseif flag == CacheFlag.CACHE_SHOTSPEED then
            player.ShotSpeed = player.ShotSpeed + 0.2
        elseif flag == CacheFlag.CACHE_TEARCOLOR then
            player.TearColor = TEAR_COLOR
        end
    end)

    mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, tear)
        local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
        if not isTainted(player) then return end

        if used() >= WEEKLY_LIMIT then
            tear.CollisionDamage = tear.CollisionDamage * OVER_LIMIT_DAMAGE
            tear.Color = OVER_LIMIT_COLOR
            return
        end
        Risk.state.weeklyUsed = used() + 1
        if used() == WEEKLY_LIMIT then
            Game():GetHUD():ShowItemText("Weekly limit reached", "Resets next floor")
        end
    end)

    mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
        if not Game():GetHUD():IsVisible() then return end
        for i = 0, Game():GetNumPlayers() - 1 do
            if isTainted(Isaac.GetPlayer(i)) then
                local y = Isaac.GetScreenHeight() - 40 - i * 24
                local over = used() >= WEEKLY_LIMIT
                HudText:Draw(HudText:T("weekly", used(), WEEKLY_LIMIT), 50, y,
                    1, over and 0.3 or 0.55, over and 0.3 or 0.4, 1)
            end
        end
    end)
end

TaintedClaude.WEEKLY_LIMIT = WEEKLY_LIMIT

return TaintedClaude
