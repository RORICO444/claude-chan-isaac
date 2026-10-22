# Handoff

State of the project as of 2026-10-22, for whoever picks it up next (you, a friend, or a new Claude session).

## What this is

**Claude-chan: Risk Control**: a free, non-commercial parody mod for *The Binding of Isaac: Repentance / Repentance+*. It satirises AI account bans and risk control (风控): every floor hands you a random proxy IP, crowded IPs raise your risk score, and higher risk makes the game harder. You play as **Claude-chan** (design by ZipZipPipe), armed with a Ban Hammer and a usage limit.

- Repo: https://github.com/WaterLily5297/claude-chan-isaac (public, `main`)
- Requested by a Chinese friend of the owner. Audience: Chinese and Japanese players, so everything player-facing is in English, Simplified Chinese and Japanese.

## Status in one line

**Built and checked as far as possible without the game; never run in the real game.**

| Check | Status |
|---|---|
| Lua syntax, XML validity | ✅ every file |
| Smoke tests against a stubbed API (`tests/`) | ✅ all pass |
| API calls against the community docs | ✅ all used calls exist with the right signatures (see `docs/TESTING.md`) |
| In-game test | ❌ not done |
| Balance | ❌ untested; see `docs/BALANCE.md` |
| Real art | ❌ all placeholder |

## What's built (v0.3-dev)

- **Systems:** risk score + random IP per floor, enemy HP scaling (×1 → ×3), hydra respawns (risk 40+), **Suspended** at 90+ (damage ×0.75), misbans on Ban Hammer, HUD in en/zh/ja with English fallback, save/continue.
- **Character:** Claude-chan: Range +1.5, Shot Speed +0.2, Speed −0.1, pocket Ban Hammer, usage-limit meter. Placeholder: vanilla Isaac sprites.
- **15 items:** Ban Hammer, Residential IP, Compact, You're Absolutely Right!, 9.9 Yuan Relay, Ultrathink, 1M Context, Silent Update, --dangerously-skip-permissions, All Tests Passing, Vibe Coding, Banked Reset, Subagent Swarm, The Constitution, Opus Mode.
- **6 trinkets:** 529 Overloaded, Hardcoded Output, Thinking Cleared, Welcome Notice, Status Page, Appeal Form.
- **2 pills:** Cat-girl Mode, Brb, Getting Food.
- **1 transformation:** Agentic (any 3 of the 6 Claude Code items).
- **1 enemy:** Relay Slime (placeholder: tinted vanilla Clotty), splits 1 → 7.
- **EID** descriptions for everything, in 3 languages.

Each item's meme source is in `CHANGELOG.md` and `README.md`.

## Next steps, in order

### Needs the owner

1. **In-game test**: `docs/TESTING.md`, ~15 min. Paste any red console text to Claude.
2. **Message ZipZipPipe** (character designer) for permission, and **mySh1_loRis**, who made the Bilibili animation 《克劳德的结合》 and may make a similar reskin mod. Possible collaborator. Drafts were sent to the owner as `claude-chan-isaac-zipzippipe_message.md`. They are **deliberately not in the repo**.
3. **Find a pixel artist** for Claude-chan's sprites (`docs/ART_SPEC.md`).

### For Claude (after the test)

1. Fix whatever the test breaks. Most likely: All Tests Passing (doors may re-close), Relay Slime, CJK font path (`font/cjk/lanapixel.fnt` is a guess).
2. Apply balance tweaks if the test agrees (`docs/BALANCE.md`): enemy HP cap ×3 → ×2, Subagent Swarm 50% → 40%, Claude-chan usage cost 4 → 3.
3. Then: real art swap-in, custom enemies (Distillation Bot, Timezone Ghost), the four AI-musume bosses (`docs/IDEAS.md`), Workshop upload (`docs/PUBLISHING.md`).

## Where things are

| Path | What |
|---|---|
| `main.lua` | Entry point; includes every module in order (**order matters**, see below) |
| `scripts/constants.lua` | Item / trinket / pill / player IDs, risk tiers |
| `scripts/risk.lua` | Risk score, IP roll, Suspended + Appeal, save/load (`Risk.state`), HUD |
| `scripts/items/`, `scripts/characters/`, `scripts/enemies/` | One file per thing |
| `scripts/eid.lua` | All EID descriptions |
| `scripts/hud_text.lua` | HUD strings in en/zh/ja + CJK font loading |
| `content/*.xml` | items, item pools, players, pills |
| `tools/make_placeholders.py` | Generates all placeholder sprites (16×16 art → 32×32 PNG, size-checked) |
| `tests/` | `lua tests/smoke_test.lua .` etc. |
| `docs/` | TESTING, BALANCE, PUBLISHING, ART_SPEC, IDEAS, GOALS, this file |
| `resources/ART_LICENSE.md` | Art is **not** MIT: ZipZipPipe credit + non-commercial |

## Conventions (follow these when adding things)

- **New item checklist:** script in `scripts/items/` → ID in `constants.lua` → `content/items.xml` → `itempools.xml` → `include` in `main.lua` → EID (3 languages) → sprite in `make_placeholders.py` → README (3 languages) → CHANGELOG → a row in TESTING.md → a stub case in `tests/smoke_test.lua`.
- Anything that must survive save/continue goes in **`Risk.state`** (it's what gets saved), not `player:GetData()`.
- **Callback order matters.** `MC_ENTITY_TAKE_DMG` stops at the first callback that returns a value, so The Constitution is included *before* `Risk:Init`.
- Seeded RNG per module (`RNG():SetSeed(startSeed + offset)`), so runs are reproducible.
- Before packaging, check that no `.lua`/`.xml`/`.md` file is empty. A script bug once silently wiped `risk.lua`, and `luac -p` passes on an empty file.

## Content rules (agreed with the owner)

- Enemies are **abuse mechanisms** (shared proxies, mass accounts, bots), **never people or nationalities**. Over-banning is part of the joke (misbans).
- Never reference Grok's July 2025 offensive content; the Grok-chan boss idea uses only the "update rolled back" angle.
- No official Anthropic / OpenAI / etc. logos. Stays free and non-commercial. Credit ZipZipPipe; DeepSeek-chan also needs 上善无形 and CC BY-NC-SA 4.0.

## Environment notes (Claude Code cloud sessions)

- `lua5.4` isn't preinstalled: `apt-get install -y lua5.4`.
- The Isaac wiki and most news sites are blocked from WebFetch. The API docs are readable from GitHub raw: `https://raw.githubusercontent.com/wofsauge/IsaacDocs/main/docs/<Class>.md`.
- `gh`'s token was invalid; GitHub access works through the session's repo attachment, not `gh`.
- The container is wiped between sessions: push to GitHub before ending.
