local root = arg[1]
function include(name) return dofile(root .. "/" .. name:gsub("%.", "/") .. ".lua") end
Isaac = {
    GetItemIdByName = (function() local ids, nxt = {}, 800 return function(n) ids[n] = ids[n] or nxt; nxt = nxt + 1; return ids[n] end end)(),
    GetTrinketIdByName = (function() local ids, nxt = {}, 190 return function(n) ids[n] = ids[n] or nxt; nxt = nxt + 1; return ids[n] end end)(),
    GetPlayerTypeByName = function() return 41 end,
    GetPillEffectByName = function(n) return n == "Cat-girl Mode" and 50 or 51 end,
}
local counts = {}
local function count(kind) return function(_, id, desc, name, lang) counts[kind] = (counts[kind] or 0) + 1; assert(type(desc) == "string" and type(name) == "string" and lang) end end
EID = { addCollectible = count("item"), addTrinket = count("trinket"), addPill = count("pill"), addCharacterInfo = count("character") }
include("scripts.eid"):Init()
for k, v in pairs(counts) do print(k, v) end
