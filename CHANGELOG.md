# Changelog

## v0.4-dev (2026-10-23)

- Reviewed and merged PR #1 (collaboration checks) and PR #2 (RORICO444's 21 item/trinket icons).
- Added Support Ticket: six charges, three coins for risk -20, with failed-use and Car Battery guards.
- Added playable DeepSeek-chan with blue tears, a firing-interval/damage tradeoff, pocket Support Ticket and team-wide no-hit risk recovery.
- Added The Appeal Queue: four original saved captions in en/zh/ja. Early approvals preserve later chapters with approved-route dialogue.
- Added generated Claude/DeepSeek character atlases, portraits, names and menu assets. Runtime fixes preserve faces with Reactions Port Pack, map DeepSeek clothing correctly and fit repaired Claude rear-head/body cutouts into engine cells.
- Moved story captions above the Loadout prompt and away from the upper EID text.
- Seed Silent Update before each floor roll, including pre-start NEW_LEVEL; continue preserves its stored multiplier.
- Fixed Windows Python detection and UTF-8 handling. Checks cover deterministic sprites, character assets, animation bounds, pools and gameplay boundaries.

Validation: required offline checks and initial Repentance+ 1.9.7.17 runtime checks passed, including both custom skins, corrected Claude rear hair, actual ticket use/refusal, an approved-route chapter, subtitle placement and continued runs. Tests were muted and the game was closed normally. Full animation/costume coverage, ordinary Repentance, co-op and a full run remain open; see HANDOFF.md. Character-art permissions and Workshop publication remain separate release requirements.

## v0.3-dev (unreleased, not yet tested in game)

New items, each based on a Claude / AI meme:

- **Compact** (active): the "compacting ate my 5-hour limit" complaints.
- **You're Absolutely Right!** (passive, angel): sycophancy.
- **9.9 Yuan Relay** (passive, devil): cheap relays secretly swapping the model (掺水).
- **Ultrathink** (active, timed): think / megathink / ultrathink and the 31,999-token budget.
- **1M Context** (passive): context rot.
- **Silent Update** (passive): 降智, behaviour changes missing from the changelog.
- **--dangerously-skip-permissions** (passive, devil): no prompts, occasional `rm -rf`.
- **All Tests Passing** (active): reward hacking by deleting assertions.
- **Vibe Coding** (passive): "Claude Code is vibe-coded" and the $1,986 vibe-coding bill video.
- **Banked Reset** (active): Anthropic's save-it-for-later rate-limit reset.
- **Subagent Swarm** (passive, devil): the sessions that spawned excessive parallel subagents.
- **Cat-girl Mode** / **Brb, Getting Food** (pills): DeepSeek-chan memes.
- **Welcome Notice** (trinket): fan lore where DeepSeek-chan swaps Claude-chan's ban card; Ban Hammer recruits instead of bans.
- **Status Page** (trinket): the status page that said everything was fine during outages.
- **The Constitution** (passive, angel): the priority order in Claude's 2026-01-21 constitution.
- **Opus Mode** (passive, shop): "more expensive than gold"; damage for coins.
- **529 Overloaded** (trinket): the July–August 2026 outages.
- **Hardcoded Output** (trinket): special-casing the expected output.
- **Thinking Cleared** (trinket): the cache bug that wiped thinking every turn.

New enemy: **Relay Slime** (placeholder on vanilla Clotty): splits twice on death, appears from risk 30.

EID: descriptions for the pills and for Claude-chan herself (en / zh / ja); language codes checked against EID's source.

New: **Suspended** state at risk 90+ (damage ×0.75), and the **Appeal Form** trinket that resets risk to 50 instead.

New: **Agentic** transformation (any 3 of the 6 Claude Code items): flight, tears up, +0.5 damage.

HUD: risk, IP and usage text now follow the game language (English / 简体中文 / 日本語), falling back to English if no CJK font loads.

Changed: **Ban Hammer** now misbans: 20% of bans hit innocent developers, +3 risk each.

Also: in-game test checklist (`docs/TESTING.md`), goals (`docs/GOALS.md`).

## v0.2

- Playable **Claude-chan** (design by ZipZipPipe): Range +1.5, Shot Speed +0.2, Speed −0.1, pocket Ban Hammer, usage limit mechanic. Placeholder art.
- Art license split from code license; art spec for the pixel artist.

## v0.1

- Risk score and random proxy IP per floor, enemy HP scaling, hydra respawns.
- **Ban Hammer** (active) and **Residential IP** (passive).
- EID descriptions in English, Chinese and Japanese.
