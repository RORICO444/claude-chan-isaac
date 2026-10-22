local Constants = {}

Constants.Item = {
    BAN_HAMMER = Isaac.GetItemIdByName("Ban Hammer"),
    RESIDENTIAL_IP = Isaac.GetItemIdByName("Residential IP"),
    COMPACT = Isaac.GetItemIdByName("Compact"),
    ABSOLUTELY_RIGHT = Isaac.GetItemIdByName("You're Absolutely Right!"),
    CHEAP_RELAY = Isaac.GetItemIdByName("9.9 Yuan Relay"),
    ULTRATHINK = Isaac.GetItemIdByName("Ultrathink"),
    MILLION_CONTEXT = Isaac.GetItemIdByName("1M Context"),
    SILENT_UPDATE = Isaac.GetItemIdByName("Silent Update"),
    SKIP_PERMISSIONS = Isaac.GetItemIdByName("--dangerously-skip-permissions"),
    TESTS_PASSING = Isaac.GetItemIdByName("All Tests Passing"),
    VIBE_CODING = Isaac.GetItemIdByName("Vibe Coding"),
    BANKED_RESET = Isaac.GetItemIdByName("Banked Reset"),
    SUBAGENT_SWARM = Isaac.GetItemIdByName("Subagent Swarm"),
    CONSTITUTION = Isaac.GetItemIdByName("The Constitution"),
    OPUS_MODE = Isaac.GetItemIdByName("Opus Mode"),
}

Constants.Trinket = {
    OVERLOADED = Isaac.GetTrinketIdByName("529 Overloaded"),
    HARDCODED_OUTPUT = Isaac.GetTrinketIdByName("Hardcoded Output"),
    THINKING_CLEARED = Isaac.GetTrinketIdByName("Thinking Cleared"),
    WELCOME_NOTICE = Isaac.GetTrinketIdByName("Welcome Notice"),
    STATUS_PAGE = Isaac.GetTrinketIdByName("Status Page"),
    APPEAL_FORM = Isaac.GetTrinketIdByName("Appeal Form"),
}

Constants.Pill = {
    CAT_GIRL = Isaac.GetPillEffectByName("Cat-girl Mode"),
    GETTING_FOOD = Isaac.GetPillEffectByName("Brb, Getting Food"),
}

Constants.Player = {
    CLAUDE_CHAN = Isaac.GetPlayerTypeByName("Claude-chan", false),
}

Constants.RISK_MAX = 100

-- Risk thresholds. The HUD label and colour change at each tier.
Constants.Tier = {
    { min = 0,  label = "Clean",      color = { 0.4, 1.0, 0.4 } },
    { min = 30, label = "Suspicious", color = { 1.0, 1.0, 0.4 } },
    { min = 60, label = "Flagged",    color = { 1.0, 0.6, 0.2 } },
    { min = 90, label = "Suspended",  color = { 1.0, 0.2, 0.2 } },
}

-- Risk score at which killed enemies may come back as "new accounts".
Constants.HYDRA_MIN_RISK = 40

return Constants
