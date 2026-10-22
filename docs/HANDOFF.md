# Handoff for Claude and contributors

Updated 2026-10-23 (Japan time), v0.4-dev. Read this before continuing. This is a Codex implementation handoff; no separate Claude session reviewed this change.

## Current work

- PR #1 (collaboration/CI) and PR #2 (RORICO444 item icons) were reviewed and merged, preserving contribution history. PR #2 originally targeted `setup/collaboration`; it was retargeted to `main` after #1 merged.
- Added `Support Ticket`: six-charge shop active, 3 coins for risk -20, no payment/charge if coins are insufficient or risk is zero; Car Battery cannot charge twice.
- Added playable `DeepSeek-chan`: 2 red + 1 soul heart, 3 coins, 1 key, pocket Support Ticket, damage x0.85, firing interval x0.85 and blue tears. A no-hit room reduces shared risk by two extra points once for the team.
- Added `scripts/story.lua`: four original localised chapters. `Risk.state.storySeen` is a saved bitmask; `reviewApproved` unlocks the last caption on the next room. Chapters do not pause the run or replace vanilla ending files.
- Added custom generated character atlases, portraits, names and selection animations for both characters. The owner correctly noted the original gameplay build still looked like Isaac; these new assets now replace its skin paths. **The new art has not yet been verified in the running game.** See `ART_GENERATION.md` and `ART_SPEC.md`.
- Fixed Silent Update's RNG lifecycle: `MC_POST_NEW_LEVEL` can fire before game start. Each floor now seeds before drawing; continue keeps its saved multiplier.
- Fixed early-review story progression: approving an appeal on floor one no longer suppresses stages 3 and 5. Both later chapters have approved-route dialogue in en/zh/ja and share the original saved chapter bits.
- Windows checks now reject the Python Store placeholder and force UTF-8. Asset checks validate PNG dimensions, exact item-icon regeneration, item pools, character paths and ANM2 frame bounds. Symmetry failures now return a failing exit status.

## Validation and limits

- `bash tools/check.sh`: passes using Lua 5.3 (`texlua`) and Python 3.10 on Windows. All four Lua tests pass, including new item boundaries, duplicate use, co-op risk, seeded floor lifecycle, saved story chapters and exact EID registration counts.
- All 21 PR #2 icons regenerate byte-for-byte; the new Support Ticket icon does too.
- Repentance+ **1.9.7.17** successfully loaded the installed gameplay build. The visible run was DeepSeek-chan with 3 coins, 1 key and pocket Support Ticket; risk HUD and the first story caption rendered. A later view showed 0 coins and 0 risk, consistent with a ticket activation.
- That view exposed a subtitle/EID overlap. Subtitles were moved above the lower HUD; the revised position still needs runtime verification.
- A pre-existing `stackable items v2` mod throws `resources/scripts/main.lua:154: table index is nil`; do not attribute that error to this mod. Do not modify or disable unrelated mods without checking with the owner.
- The owner stopped Computer Use with physical Escape. No further app input was sent after that stop. Final sprite-animation checks, save/continue in game, vanilla Repentance and local co-op remain unverified. Keep these limitations visible.
- On the next continuation, the previous test game was closed normally. All 100 reviewed application files, including both character sheets and selection assets, were installed in the existing mod folder and verified against the source with matching hashes. The runtime checkout is now connected to `codex/appeal-story`; notes and saves remain untouched.
- Restart is currently blocked by Steam's explicit Cloud sync-failed warning, which says proceeding can permanently lose progress. Computer Use is waiting for the owner's decision before accepting that warning. No new gameplay session was started. The game process was verified absent after closing the previous session. Do not bypass the warning through an alternative launcher.
- Tests used muted game settings. Close the game when finishing any future tests. Do not operate login dialogs or use credentials supplied in chat.

## Next exact steps

1. Fetch and confirm the feature branch and installed files still match. The art installation itself is complete; do not recopy or recreate a second mod folder. Back up the installed previous version before any further overwrite.
2. Resolve Steam Cloud sync or obtain the owner's explicit decision about its launch warning. Then launch muted, start a seeded test, and inspect both characters: all four head directions, shooting, walk, hurt, death, flying, stage/boss portraits and selection labels. Inspect custom-sheet cells carefully; generated art may need pixel alignment and back-head corrections. Test D4, transformation costumes and skin-colour effects before calling the art complete.
3. Test Support Ticket at risk 0, risk 10/50, 2/3 coins, Car Battery; confirm charge behaviour. Continue a saved run and check the story does not repeat. Check EID layout at the revised subtitle location.
4. Keep development via branches and PRs. Fetch before editing; preserve concurrent contributions. Do not publish a Workshop release yet.
5. The next designed content slice is in `STORY.md`: Offline Cache, Gemini-chan and the neutral Queue Clerk. Implement one small feature at a time with en/zh/ja text and a specific game test.

## Project conventions

`main.lua` loads modules onto one shared mod object. Constitution damage cancellation must register before risk damage bookkeeping. Persistent run state goes in `Risk.state`. Use seeded RNG, no network calls or telemetry in gameplay, and content XML rather than replacing vanilla resources.

Code/item icons are MIT; character design/art terms are separate in `resources/ART_LICENSE.md`. Design credits: ZipZipPipe, plus 上善无形 for DeepSeek. No official logos. Enemies are infrastructure and abuse mechanisms, not populations. Keep notes, credentials, personal images, saves, machine-specific paths and backups out of GitHub. Prior-version backups are local and verified; their paths are deliberately absent from this repository.

The owner supplied Bilibili video BV1yUJZ6WEpg as inspiration. Public page/API retrieval failed in this session, so no claim was made that its downloadable files or license had been inspected, and no video pixels were used.
