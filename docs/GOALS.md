# Goals and acceptance evidence

## Current development: v0.4, playable characters and The Appeal Queue

The owner wants new item and character ideas implemented with corresponding artwork, compatibility with the base game, new story content, GitHub collaboration and an accurate handoff. Development is incremental; a green offline check does not establish game compatibility.

| Requirement | Current evidence | Remaining work |
|---|---|---|
| Review contributions | PR #1 and #2 reviewed and merged | Preserve subsequent contributions through PRs |
| Add an item | Support Ticket implemented, registered, pooled, localised and regression-tested | Verify real-game charges, Car Battery and insufficient-coins cases |
| Add a character | DeepSeek-chan implemented; initial resources and pocket item observed in Repentance+ | Verify no-hit bonus in game, local co-op and a complete run |
| Corresponding art | Claude/DeepSeek atlases, portraits, names and selection assets installed | Verify every animation, back-head frames, costumes and UI in game; polish failures |
| Story | Four saved chapters and early-approval route variants in en/zh/ja | Verify final subtitles with EID and real-game save/continue |
| Base-game compatibility | Repentance+ 1.9.7.17 loaded the earlier gameplay build; Lua 5.3 and CI checks pass | Current art build, normal Repentance, local co-op, full-run and costume checks remain open |
| GitHub/local synchronisation | Feature work is in draft PR #3; installed files match reviewed source | Keep branch commits and installed assets matched after each update |
| Claude collaboration/handoff | `HANDOFF.md` records implementation, tests, gaps and next content ideas | No independent Claude review has occurred; next session should start from the handoff |

Steam Cloud currently blocks restarting the game with an explicit possible-progress-loss warning. Wait for sync recovery or the owner's decision before accepting it. Do not equate the stopped launch with a successful runtime test.

Always test muted and close owned game sessions afterward. Keep backups verified locally, notes and saves in place, and credentials, personal images and machine-specific data outside GitHub.

## Original first-playable milestone: still open

A friend should be able to install the mod, choose Claude-chan, and play a full run to Mom with its distinct risk/ban mechanics.

- [ ] Verify Claude-chan, risk HUD, Ban Hammer, Residential IP and hydra respawns together in the real game.
- [x] Create the GitHub repository and publish the prototype source.
- [ ] Record applicable permission/license evidence before distributing any character design assets requiring it. Contacting creators remains an owner task unless explicitly authorised.
- [ ] Validate the custom Claude body sheet, name and portraits in game; separate hair-costume polish remains open.
- [x] Implement the first custom enemy, Relay Slime; its art remains a placeholder.
- [ ] Complete a test run to Mom and evaluate usage-limit/risk balance.

The planned Workshop release remains separate and unready. Future item, character and encounter ideas are in `STORY.md` and `IDEAS.md`; do not call backlog ideas implemented.
