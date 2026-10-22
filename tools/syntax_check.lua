-- Compile (without running) every file given on the command line.
-- Used by tools/check.sh: lua tools/syntax_check.lua a.lua b.lua ...
local failed = 0
for i = 1, #arg do
    local ok, err = loadfile(arg[i])
    if not ok then
        print("  ✗ " .. err)
        failed = failed + 1
    end
end
if failed > 0 then os.exit(1) end
print("  ✓ " .. #arg .. " 个 .lua 文件")
