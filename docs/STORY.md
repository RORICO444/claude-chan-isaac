# Story prototype: The Appeal Queue

This is original fan fiction inspired by account-ban complaints and AI personification memes. The dialogue does not claim to describe an actual company's support process. The owner supplied [BV1yUJZ6WEpg](https://www.bilibili.com/video/BV1yUJZ6WEpg/) as an inspiration reference; public retrieval was unavailable during this development pass. No video frames or downloads from it are bundled.

The dungeon is a shared relay address. Claude-chan is trying to find the person behind an automated ban; DeepSeek-chan replaces rejection notices with invitations. Both must still clear the same hostile rooms. The enemies represent unreliable infrastructure and abuse mechanisms.

## Implemented chapters

| Trigger | Chapter | Purpose |
|---|---|---|
| New run | The shared address | Introduces the shared-IP misunderstanding |
| First visit to stage 3 or 4 | A welcome notice | Introduces DeepSeek's welcoming response |
| First visit to stage 5 or later | Review pending | Connects the dungeon to the support queue |
| Enter a room after successfully using Support Ticket | A human finally read it | Resolves the appeal without ending the run |

The captions last seven simulation seconds, do not pause combat, and respect HUD visibility. Each chapter is shown once per run; its progress is saved in `Risk.state.storySeen`, a four-bit mask. Simultaneous triggers enter `Risk.state.storyPending` in order; queued captions are marked seen only when playback begins. Unseen queued captions survive save/continue, while an already-started caption does not repeat. English, Simplified Chinese and Japanese text uses the existing HUD renderer, with English fallback when its CJK font is unavailable. A route that skips a chapter does not replay it later automatically.

An early successful appeal does not suppress later floor chapters. Stages 3 and 5 use alternative dialogue when the review has already succeeded: DeepSeek welcomes the restored player, and the player keeps the response letter while others remain in the queue. These variants share their chapter's saved bit, so they cannot replay the same chapter after continue.

## Next collaboration slice

1. **Offline Cache**: a defensive passive which stores one room-clear reward and releases it after an outage. Design the pickup duplication exclusions before implementation.
2. **Gemini-chan**: a later character prototype with alternating planning/action rooms. Define one clear bonus and cost; do not add a boss or licensed sprite until its source is recorded.
3. **Queue Clerk**: a neutral encounter which offers a choice between paying coins for review or accepting temporary risk. Use normal room transitions and seeded choices.
4. Polish the newly added Claude and DeepSeek sprite sheets, portraits and character-menu art using `docs/ART_SPEC.md`; check every head direction, walking/hurt/death animation and item costume in game.

Future cutscenes should be optional and avoid replacing vanilla ending files or shared game resources.
