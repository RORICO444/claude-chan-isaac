# In-game test checklist

Everything so far has only been checked against a stubbed API. One pass through this list in the real game (about 15 minutes) tells us what actually works.

## Setup

1. Put the folder in `…/The Binding of Isaac Rebirth/mods/claude-chan-isaac/`.
2. `options.ini` → `EnableDebugConsole=1`.
3. Start the game, open the mods menu and check **Claude-chan: Risk Control** is enabled.
4. In a run, press `~`. **Any red text in the console is an error. Copy it exactly and send it to Claude.**

Useful console commands: `giveitem <name>` for items, `giveitem t<name>` for trinkets (e.g. `giveitem t529 Overloaded`), `stage 2` to change floor, `debug 3` for god mode, `luamod claude-chan-isaac` to reload after a fix.

## Checklist

| # | Test | Expected | OK? |
|---|---|---|---|
| 1 | Character select | Claude-chan is listed (looks like Isaac for now) | |
| 2 | Start as Claude-chan | Ban Hammer in the pocket slot; orange tears; IP + Risk + Usage on the bottom-left | |
| 3 | Shoot non-stop for ~20 s | "Usage limit reached", grey weak tears for 5 s, then meter resets | |
| 4 | `stage 2`, `stage 3` | New IP each floor, risk goes up | |
| 5 | Get hit / clear a room without a hit | Risk +1 / −1 | |
| 6 | Risk ≥ 40, kill enemies | Some come back red, only once each | |
| 6b | Risk ≥ 30 (`stage 4`+), enter new rooms | Sometimes a big green Clotty; killing it gives 2 smaller, then 2 smaller each again (7 total) | |
| 7 | Use Ban Hammer in a room with many enemies | Non-boss enemies die, "BANNED", none come back; sometimes "misban(s) - appeal pending" and risk goes up | |
| 8 | `giveitem Residential IP` | Risk −30 once | |
| 9 | `giveitem Compact`, use it | Enemy shots vanish, enemies confused; Claude-chan usage +50 | |
| 10 | `giveitem You're Absolutely Right!`, get hit | That enemy becomes friendly for 5 s | |
| 11 | `giveitem 9.9 Yuan Relay`, change rooms | Sometimes "Model quietly downgraded"; risk +15 once | |
| 12 | `giveitem Ultrathink`, use 3× in one room | think / megathink / ultrathink, damage goes up; resets next room | |
| 13 | `giveitem 1M Context` | Long range; far tears do less damage | |
| 14 | `giveitem t529 Overloaded`, fight | Every 20 s everything freezes for 2 s | |
| 15 | `giveitem Silent Update`, change floors | "Changelog: no changes", damage changes | |
| 16 | `giveitem --dangerously-skip-permissions` | Locked doors/chests open; sometimes "rm -rf" deletes pickups | |
| 17 | `giveitem All Tests Passing`, use with enemies alive | Doors open, enemies stay. **Do the doors stay open?** | |
| 18 | `giveitem tHardcoded Output` | Tears always deal 3.5 | |
| 18b | `giveitem tThinking Cleared`, change rooms | Damage +1; active item loses a charge per room | |
| 18c | `giveitem Vibe Coding`, shoot, `stage 2` with coins | Tears get mixed effects, a few fly backwards; coins −25% on new floor | |
| 18d | As Claude-chan, hit the usage limit, then `giveitem Banked Reset` and use it | Usage meter back to 0, risk −25 | |
| 18e | `giveitem Subagent Swarm`, shoot | 3 tears per shot in a fan; Claude-chan's meter fills about twice as fast | |
| 18f | Console `giveitem p<n>` is awkward for modded pills; instead find pills in a run, or check they appear in the pill pool | "Cat-girl Mode" doubles fire rate at lower damage for the room; "Brb, Getting Food" heals and pauses shooting | |
| 18g | `giveitem tWelcome Notice`, use Ban Hammer | "WELCOME!", regular enemies become allies and stay allies | |
| 18h | `giveitem tStatus Page` | HUD says "Risk: all systems operational"; risk still rises, a bit slower | |
| 18i | `giveitem The Constitution`, take 2 hits on one floor | +1 soul heart; first hit shows "I can't help with that" and does no damage or risk; second hit lands | |
| 18j | `giveitem Ultrathink`, `giveitem Compact`, `giveitem Vibe Coding` | "Agentic!" with a sound; you can fly over rocks and pits; tears faster | |
| 18k | Push risk to 90+ (many floors / misbans) | "Account suspended", damage drops; when risk falls below 90 damage returns | |
| 18l | Same, holding `giveitem tAppeal Form` | "Appeal approved", trinket gone, risk 50, no damage drop | |
| 18m | `giveitem Opus Mode` with a few coins, shoot | Big damage; coins tick down every 10 tears; at 0 coins "Out of credits" and weak damage; pick up a coin and damage comes back | |
| 19 | Save & quit, continue | Risk, IP and Silent Update value are kept | |
| 19b | Set the game language to 简体中文 (or 日本語), start a run | HUD shows 风控值 / リスク値 in that language. If it's still English, the CJK font path is wrong: tell Claude | |
| 20 | With EID installed | Item descriptions show (try Chinese/Japanese in EID settings) | |

Items most likely to need fixes: **#17** (doors may re-close while enemies are alive) and the placeholder Relay Slime (#6b).

### API checked against the community docs (wofsauge/IsaacDocs, 2026-10-22)

These calls exist with the signatures the mod uses, so they shouldn't crash: `GridEntityDoor:TryUnlock(player, force)`, `IsLocked()`, `Open()`; `EntityPickup:TryOpenChest(player)`; `Entity:AddCharmed(ref, -1)` (−1 = permanent, the ally follows you between rooms); `AddConfusion`, `AddFreeze`; `Room:SetClear`, `GetFrameCount`, `GetCenterPos`; `EntityPlayer:SetPocketActiveItem`, `GetActiveCharge`, `SetActiveCharge`, `AddSoulHearts`, `HasTrinket`; `EntityTear:AddTearFlags`; `MC_USE_PILL (effect, player, flags)`; `MC_USE_ITEM` returning `true` plays the use animation; `MC_ENTITY_TAKE_DMG` returning a value skips later callbacks (so The Constitution's refused hit adds no risk).

What the docs can't tell us is whether the gameplay *feels* right. That's what this checklist is for.

## v0.4 focused checks

- Start as DeepSeek-chan: 3 coins, 1 key, pocket Support Ticket; blue tears and the stated damage/fire-interval tradeoff. Test a clean room, a hit room and two DeepSeek players (shared risk bonus only once).
- `giveitem Support Ticket`: with 2 coins or risk 0, no coins/charge spent; with 3 coins and positive risk, spend 3 and lower risk by up to 20. Repeat with Car Battery.
- See story chapters at run start, stage 3, stage 5, and the next room after successful review. Save and continue: completed chapters stay completed. Hide the HUD: captions hide too.
- Inspect both custom character skins, four head directions, all movement/hurt/death poses, character select, stage/boss portraits and names. Check D4 and costume interactions. **New character art runtime checks are pending.**
- Subtitle position was moved above the lower HUD after observing EID overlap; confirm it with EID enabled.
- Repentance+ 1.9.7.17 gameplay startup was observed on 2026-10-23. This is not evidence of a full-run pass, normal Repentance compatibility or local co-op correctness.
