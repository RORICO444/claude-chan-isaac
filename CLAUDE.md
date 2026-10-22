# Notes for Claude

Several people work on this repo: the owner and their friends in China, each possibly with their own Claude session. Read [docs/HANDOFF.md](docs/HANDOFF.md) before changing anything; it has the project state, file layout, conventions and the content rules.

## Working here

- Reply in the language the person writes in (usually Chinese, sometimes Japanese or English).
- **Never push to `main` directly.** Work on a branch named `<person>/<topic>` and open a pull request. Fetch `main` first; others may have pushed since.
- Keep each PR to one item, enemy or fix.
- Before committing, run `bash tools/check.sh`. It needs Lua 5.3+ (`apt-get install -y lua5.4`; if that fails, `texlua` from TeX Live also works and the script finds it). CI runs the same script on every PR.
- Adding an item, trinket, pill or enemy: follow the checklist in [CONTRIBUTING.md](CONTRIBUTING.md) (same as HANDOFF's "New item checklist"). Player-facing text needs English, Simplified Chinese and Japanese.
- Nothing here has been run in the real game yet. Don't claim something works in game unless someone tested it; say what the stubbed tests do and don't cover.
- When the project state changes (something tested in game, a system finished), update `docs/HANDOFF.md` in the same PR.

## Content rules (agreed with the owner)

- Enemies are abuse mechanisms (shared proxies, mass accounts, bots), never people or nationalities.
- No reference to Grok's July 2025 offensive content.
- No official company logos. Free and non-commercial. Credit ZipZipPipe (Claude-chan); DeepSeek-chan also needs 上善无形 and CC BY-NC-SA 4.0. Art is not MIT.
