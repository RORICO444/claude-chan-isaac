-- Run the HUD text module under three scenarios.
local root = arg[1]
function include(name) return dofile(root .. "/" .. name:gsub("%.", "/") .. ".lua") end
function KColor(...) return { ... } end
Isaac = { RenderText = function(s) print("  RenderText: " .. s) end }
local function run(language, fontLoads)
    Options = { Language = language }
    Font = function()
        return { Load = function() end, IsLoaded = function() return fontLoads end,
                 DrawStringUTF8 = function(_, s) print("  CJK font: " .. s) end }
    end
    local H = include("scripts.hud_text")
    print(language, "font loads:", fontLoads)
    H:Draw(H:T("risk", 42, 100, H:T("Suspicious")), 0, 0, 1, 1, 1, 1)
    H:Draw(H:T("usage", 63), 0, 0, 1, 1, 1, 1)
end
run("zh", true); run("ja", true); run("zh", false); run("en", true)
Options = nil
local H = include("scripts.hud_text"); print("no Options table"); H:Draw(H:T("operational"), 0, 0, 1, 1, 1, 1)
