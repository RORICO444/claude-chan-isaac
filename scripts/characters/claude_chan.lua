-- Claude-chan (playable character)
-- Character design by ZipZipPipe (Bilibili / Pixiv), used non-commercially with credit.
--
-- Stats: long context window (Range +1.5), Shot Speed +0.2, Speed -0.1, orange tears.
-- Pocket item: Ban Hammer.
-- Usage limit: every tear fills a usage meter that drains slowly over time.
-- When it fills up she hits her usage limit: for 5 seconds her tears deal
-- 40% damage, then the meter resets.

local Constants = include("scripts.constants")
local HudText = include("scripts.hud_text")

local ClaudeChan = {}

local USAGE_MAX = 100
local USAGE_PER_TEAR = 4
local USAGE_DRAIN_INTERVAL = 6      -- frames per point drained (5 points/second)
local LIMIT_FRAMES = 150            -- 5 seconds
local LIMITED_DAMAGE_MULT = 0.4

local TEAR_COLOR = Color(1, 0.55, 0.25, 1, 0, 0, 0)
local LIMITED_TEAR_COLOR = Color(0.5, 0.5, 0.5, 0.7, 0, 0, 0)

local function isClaude(player)
    return player and Constants.Player.CLAUDE_CHAN >= 0
        and player:GetPlayerType() == Constants.Player.CLAUDE_CHAN
end

local function getUsage(player)
    local data = player:GetData()
    if not data.ccUsage then
        data.ccUsage = { value = 0, limited = 0 }
    end
    return data.ccUsage
end

function ClaudeChan:Init(mod)
    -- Give the Ban Hammer as a pocket active on a fresh run only, so continuing
    -- a run doesn't reset its charge.
    mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, isContinued)
        if isContinued or Constants.Item.BAN_HAMMER <= 0 then return end

        for i = 0, Game():GetNumPlayers() - 1 do
            local player = Isaac.GetPlayer(i)
            if isClaude(player) then
                player:SetPocketActiveItem(Constants.Item.BAN_HAMMER, ActiveSlot.SLOT_POCKET, false)
            end
        end
    end)

    mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, flag)
        if not isClaude(player) then return end

        if flag == CacheFlag.CACHE_RANGE then
            player.TearRange = player.TearRange + 1.5 * 40
        elseif flag == CacheFlag.CACHE_SHOTSPEED then
            player.ShotSpeed = player.ShotSpeed + 0.2
        elseif flag == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed - 0.1
        elseif flag == CacheFlag.CACHE_TEARCOLOR then
            player.TearColor = TEAR_COLOR
        end
    end)

    mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, tear)
        local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
        if not isClaude(player) then return end

        local usage = getUsage(player)
        if usage.limited > 0 then
            tear.CollisionDamage = tear.CollisionDamage * LIMITED_DAMAGE_MULT
            tear.Color = LIMITED_TEAR_COLOR
            return
        end

        usage.value = usage.value + USAGE_PER_TEAR
        if usage.value >= USAGE_MAX then
            usage.value = USAGE_MAX
            usage.limited = LIMIT_FRAMES
            Game():GetHUD():ShowItemText("Usage limit reached", "Your limit will reset soon")
        end
    end)

    mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
        if not isClaude(player) then return end

        local usage = getUsage(player)
        if usage.limited > 0 then
            usage.limited = usage.limited - 1
            if usage.limited == 0 then
                usage.value = 0
            end
        elseif usage.value > 0 and Game():GetFrameCount() % USAGE_DRAIN_INTERVAL == 0 then
            usage.value = usage.value - 1
        end
    end)

    mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
        if not Game():GetHUD():IsVisible() then return end

        for i = 0, Game():GetNumPlayers() - 1 do
            local player = Isaac.GetPlayer(i)
            if isClaude(player) then
                local usage = getUsage(player)
                local y = Isaac.GetScreenHeight() - 40 - i * 12
                if usage.limited > 0 then
                    HudText:Draw(HudText:T("limited", math.ceil(usage.limited / 30)), 50, y, 1, 0.3, 0.3, 1)
                else
                    HudText:Draw(HudText:T("usage", usage.value), 50, y, 1, 0.65, 0.3, 1)
                end
            end
        end
    end)
end

return ClaudeChan
