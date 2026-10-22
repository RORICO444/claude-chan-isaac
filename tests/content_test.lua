-- Boundary and lifecycle regressions independent of the large smoke scenario.
local root = arg[1]
function include(name) return dofile(root .. "/" .. name:gsub("%.", "/") .. ".lua") end
Isaac = {
    GetItemIdByName = function(n) return n == "Support Ticket" and 800 or 801 end,
    GetPlayerTypeByName = function(n) return n == "DeepSeek-chan" and 42 or 41 end,
    GetTrinketIdByName = function() return 190 end,
    GetPillEffectByName = function() return 50 end,
}
ModCallbacks = setmetatable({}, { __index = function(_, k) return k end })
CacheFlag = { CACHE_DAMAGE = 1, CACHE_FIREDELAY = 2, CACHE_TEARCOLOR = 4 }
EntityType = { ENTITY_PLAYER = 1 }
ActiveSlot = { SLOT_POCKET = 2 }
UseFlag = { USE_CARBATTERY = 32 }
function Color(...) return {...} end
local callbacks = {}
local mod = { AddCallback = function(_, id, fn) callbacks[id] = fn end }
local risk = { state = { risk = 50, silentMult = 1 } }
function risk:Get() return self.state.risk end
function risk:Add(n) self.state.risk = math.max(0, self.state.risk + n) end
local stage, stageType, seed, messages, draws = 1, 0, 123, {}, {}
function Game() return {
    GetLevel = function() return {
        GetStage = function() return stage end,
        GetStageType = function() return stageType end,
    } end,
    GetSeeds = function() return { GetStartSeed = function() return seed end } end,
    GetNumPlayers = function() return 2 end,
    GetHUD = function() return {
        IsVisible = function() return true end,
        ShowItemText = function(_, title) messages[#messages + 1] = title end,
    } end,
} end
local function player(kind)
    return { coins = 3, kind = kind, Damage = 10, MaxFireDelay = 9,
        GetNumCoins = function(p) return p.coins end,
        AddCoins = function(p, n) p.coins = p.coins + n end,
        GetPlayerType = function(p) return p.kind end,
        SetPocketActiveItem = function(p, id) p.pocket = id end,
        HasCollectible = function() return true end,
        AddCacheFlags = function() end, EvaluateItems = function() end }
end
local p, other = player(42), player(42)
function Isaac.GetPlayer(i) return i == 0 and p or other end
local function fire(id, ...) return callbacks[id](mod, ...) end

include("scripts.items.support_ticket"):Init(mod, risk)
local function use(flags) return fire("MC_USE_ITEM", 800, nil, p, flags or 0) end
assert(use().Discharge and p.coins == 0 and risk:Get() == 30)
assert(risk.state.reviewApproved)
assert(not use().Discharge and risk:Get() == 30)
p.coins = 3; risk.state.risk = 0
assert(not use().Discharge and p.coins == 3)
risk.state.risk = 10
assert(not use(32).Discharge and p.coins == 3 and risk:Get() == 10)
assert(use().Discharge and risk:Get() == 0 and p.coins == 0)

callbacks = {}
include("scripts.characters.deepseek_chan"):Init(mod, risk)
fire("MC_POST_GAME_STARTED", false)
assert(p.pocket == 800 and other.pocket == 800)
p.pocket = 900; fire("MC_POST_GAME_STARTED", true); assert(p.pocket == 900)
fire("MC_EVALUATE_CACHE", p, CacheFlag.CACHE_DAMAGE); assert(p.Damage == 8.5)
fire("MC_EVALUATE_CACHE", p, CacheFlag.CACHE_FIREDELAY); assert(p.MaxFireDelay == 7.5)
risk.state.risk = 30
fire("MC_POST_NEW_ROOM"); fire("MC_PRE_SPAWN_CLEAN_AWARD"); assert(risk:Get() == 28)
fire("MC_POST_NEW_ROOM"); fire("MC_ENTITY_TAKE_DMG")
fire("MC_PRE_SPAWN_CLEAN_AWARD"); assert(risk:Get() == 28)
p.kind, other.kind = 41, 41
fire("MC_POST_NEW_ROOM"); fire("MC_PRE_SPAWN_CLEAN_AWARD"); assert(risk:Get() == 28)

callbacks = {}
local seeded
function RNG() return {
    SetSeed = function(_, s) seeded = s end,
    RandomFloat = function() assert(seeded, "random draw before seeding"); return (seeded % 100) / 100 end,
} end
include("scripts.items.silent_update"):Init(mod, risk)
fire("MC_POST_NEW_LEVEL") -- The actual engine calls this BEFORE GAME_STARTED.
assert(seeded and risk.state.silentMult >= 0.8 and risk.state.silentMult <= 1.3)
stage = 3; fire("MC_POST_NEW_LEVEL"); local a = risk.state.silentMult
fire("MC_POST_NEW_LEVEL"); assert(a == risk.state.silentMult)
risk.state.silentMult = 1.234
fire("MC_POST_GAME_STARTED", true); assert(risk.state.silentMult == 1.234)

callbacks = {}; Options = { Language = "en" }
function Isaac.RenderText(text) draws[#draws + 1] = text end
function Isaac.GetScreenHeight() return 270 end
include("scripts.story"):Init(mod, risk)
risk.state = { risk = 20 }; stage = 1
fire("MC_POST_NEW_LEVEL"); assert(risk.state.storySeen == nil)
fire("MC_POST_GAME_STARTED", false); fire("MC_POST_RENDER")
assert(risk.state.storySeen == 1 and draws[1] == "1. The shared address")
for _ = 1, 210 do fire("MC_POST_UPDATE") end
local before = #draws; fire("MC_POST_RENDER"); assert(#draws == before)
fire("MC_PRE_GAME_EXIT"); fire("MC_POST_NEW_LEVEL")
fire("MC_POST_GAME_STARTED", true); fire("MC_POST_RENDER"); assert(#draws == before)
stage = 3; fire("MC_POST_NEW_LEVEL"); assert(risk.state.storySeen == 3)
stage = 5; fire("MC_POST_NEW_LEVEL"); assert(risk.state.storySeen == 7)
risk.state.reviewApproved = true; fire("MC_POST_NEW_ROOM")
assert(risk.state.storySeen == 15)
fire("MC_POST_RENDER"); assert(draws[#draws - 1] == "4. A human finally read it")
print("OK: Support Ticket boundaries, duplicate use, co-op, seed lifecycle and saved story chapters")

-- An appeal on floor one must not suppress both later floor chapters.
risk.state = { risk = 20 }; stage = 1; draws = {}
fire("MC_POST_GAME_STARTED", false)
risk.state.reviewApproved = true
fire("MC_POST_NEW_ROOM"); assert(risk.state.storySeen == 9)
stage = 3; fire("MC_POST_NEW_LEVEL"); fire("MC_POST_RENDER")
assert(risk.state.storySeen == 11)
assert(draws[#draws] == "DeepSeek: Restored? Good. You are still welcome.")
stage = 5; fire("MC_POST_NEW_LEVEL"); fire("MC_POST_RENDER")
assert(risk.state.storySeen == 15 and draws[#draws - 1] == "3. Beyond the queue")
local count = #draws
fire("MC_PRE_GAME_EXIT"); fire("MC_POST_GAME_STARTED", true); fire("MC_POST_RENDER")
assert(#draws == count, "completed chapters repeated after continue")
print("OK: early approval preserves later story progression and reviewed dialogue")
