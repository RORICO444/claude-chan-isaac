# Claude-chan: Risk Control

A parody mod for **The Binding of Isaac: Repentance / Repentance+**.

Every floor hands you a random proxy IP. The more people share it, the higher your **risk score** (风控值). The higher the risk, the tougher the enemies get, and killed enemies start coming back as "new accounts".

> Fan work. Not affiliated with or endorsed by Anthropic. No official logos or brand assets are used.

[中文](#中文) · [日本語](#日本語)

## Features (v0.3-dev)

| | |
|---|---|
| **Claude-chan** (playable) | Range +1.5 (long context window), Shot Speed +0.2, Speed −0.1, 2 red + 1 soul heart, orange tears. Starts with **Ban Hammer** as a pocket item. **Usage limit:** every tear fills a usage meter that drains slowly; when it's full, her tears deal 40% damage for 5 seconds. *(Placeholder art for now — she looks like Isaac until the sprites are drawn.)* |
| **Risk score** | 0–100. At **90+ your account is Suspended**: damage ×0.75 until risk drops. Each floor rolls an IP: crowded relay IPs add more risk. Getting hit +1, clearing a room without a hit −1. Shown at the bottom-left of the HUD. |
| **Enemy scaling** | Enemy HP ×1 at risk 0, up to ×3 at risk 100. |
| **Hydra accounts** | From risk 40 on, a killed enemy may respawn once (tinted red), from 10% up to 50%. |
| **Relay Slime** (enemy) | A shared proxy. Appears in 25% of uncleared rooms once risk ≥ 30; splits in two on death, twice, so one slime becomes up to seven. *(Placeholder: a green-tinted vanilla Clotty.)* |
| **Agentic** (transformation) | Hold any 3 of Ultrathink, Compact, Vibe Coding, Subagent Swarm, --dangerously-skip-permissions, All Tests Passing: flight, fire delay ×0.8, damage +0.5. |
| **Ban Hammer** (active, 4 charges) | Bans every non-boss enemy in the room; bosses take 60 damage. Banned enemies never respawn. But 20% of bans are **misbans** of innocent developers, +3 risk each ("appeal pending"). |
| **Residential IP** (passive) | Risk −30 on pickup, and every later risk increase is halved. |
| **Compact** (active, 3 charges) | "Compacting conversation...": removes all enemy projectiles, confuses every enemy for 3 s. Costs Claude-chan 50 usage (the "compacting ate my 5-hour limit" meme). |
| **You're Absolutely Right!** (passive, angel pool) | Any enemy that hurts you instantly agrees with you and is charmed for 5 s. |
| **9.9 Yuan Relay** (passive, devil pool) | Damage ×1.5, but each room has a 30% chance of a secret model swap (×0.5 instead). Risk +15 on pickup. Based on the Chinese "cheap relay quietly swaps the model" (掺水) complaints. |
| **Ultrathink** (active, 5 s recharge) | Each use in the same room thinks harder: think +1 / megathink +2 / ultrathink +3.1999 damage (after the oddly specific 31,999-token budget). 15% of the time: "Thought for 0s", nothing happens. |
| **1M Context** (passive) | Range +5, but context rot: tears lose damage the longer they fly, down to 30%. |
| **Silent Update** (passive) | Every floor, damage is quietly rescaled to ×0.8–×1.3. The only message you ever get: "Changelog: no changes". Based on the 降智 ("did they nerf it?") complaints. |
| **--dangerously-skip-permissions** (passive, devil pool) | Locked doors and locked chests open by themselves. But each room has a 10% chance of `rm -rf`: every pickup on the floor is deleted (pedestals are safe). |
| **All Tests Passing** (active, 6 charges) | Reward hacking: the room counts as cleared and every door opens, but the enemies are still there. |
| **Hardcoded Output** (trinket) | Every tear deals exactly 3.5 damage, "the expected output", however strong or weak you are. |
| **Thinking Cleared** (trinket) | Damage +1, but each new room your active item loses 1 charge. Based on the reported cache bug that wiped the thinking every turn. |
| **Vibe Coding** (passive) | Every tear gets a random effect; 5% of tears are bugs that fly backwards; each new floor the API bill takes 25% of your coins. |
| **Banked Reset** (active, 12 charges) | A rate-limit reset you can save for later: risk −25, and clears Claude-chan's usage meter (ends a limit early). |
| **Subagent Swarm** (passive, devil pool) | Every tear spawns 2 parallel subagent tears at ±15° (50% damage). Claude-chan's tears cost double usage. |
| **Cat-girl Mode** (pill) | For the rest of the room, tears fire twice as fast at 60% damage. Based on DeepSeek-chan often being asked to answer as a cat girl. |
| **Brb, Getting Food** (pill) | Heals one red heart, but you stop shooting for 3 s. Based on DeepSeek's famous "飯食ってくる" reply. |
| **Welcome Notice** (trinket) | From fan lore where DeepSeek-chan swaps Claude-chan's ban card for a welcome message: Ban Hammer turns regular enemies into permanent allies instead of banning them. |
| **Status Page** (trinket) | Every risk increase is 1 smaller, but the HUD hides your real risk and only ever says "all systems operational". |
| **The Constitution** (passive, angel pool) | Claude's constitution ranks safety, ethics, guidelines, then helpfulness: +1 soul heart, the first hit on each floor is refused ("I can't help with that"), damage ×0.9 (helpfulness is last), speed −0.1 (it's a long document). |
| **Appeal Form** (trinket) | Used up the moment risk reaches 90; your risk drops back to 50 instead of getting suspended. |
| **Opus Mode** (passive, shop) | "More expensive than gold": damage ×1.8, but every 10 tears cost 1 coin. At 0 coins you fall back to a cheaper model: damage ×0.6. |
| **529 Overloaded** (trinket) | Every 20 s in a fight, everything goes down for 2 s: all enemies freeze, and you can't shoot either. "Status page: all systems operational." |

Supports [External Item Descriptions](https://steamcommunity.com/sharedfiles/filedetails/?id=836319872) in English, Simplified Chinese and Japanese.

## Credits

- **Claude-chan character design:** [ZipZipPipe](https://space.bilibili.com/4168597) ([Pixiv《AI娘化》](https://www.pixiv.net/artworks/148186519), [《大AI和小AI们》](https://www.bilibili.com/video/BV1tE9XBbErS/)). Used non-commercially with credit, per the author's terms.

## Install for development

1. Copy (or symlink) this folder to `Steam/steamapps/common/The Binding of Isaac Rebirth/mods/claude-chan-isaac/`.
2. Turn on the debug console: set `EnableDebugConsole=1` in `options.ini` (`Documents/My Games/Binding of Isaac Repentance+/`).
3. Start a run, press `~` and try:
   - `giveitem Ban Hammer` / `giveitem Residential IP`
   - `luamod claude-chan-isaac` to reload the Lua after editing

## Tests (no game needed)

Smoke tests run the mod against a stubbed Isaac API with plain Lua 5.3+:

```
lua tests/smoke_test.lua .
lua tests/hud_text_test.lua .
lua tests/eid_test.lua .
```

They catch crashes and logic errors, not how the game feels; see [docs/TESTING.md](docs/TESTING.md) for the in-game checklist.

## Project layout

```
main.lua                  entry point, loads every module
scripts/constants.lua     item IDs, risk tiers, thresholds
scripts/risk.lua          risk score, IP roll, save/load, HUD
scripts/enemy_scaling.lua enemy HP scaling
scripts/hydra.lua         "new account" respawns
scripts/items/            one file per item
scripts/characters/       playable characters
scripts/enemies/          custom enemies
scripts/eid.lua           EID descriptions (en / zh / ja)
content/                  items.xml, itempools.xml, players.xml, pocketitems.xml
docs/ART_SPEC.md          sprite checklist for the pixel artist
resources/gfx/            sprites
tools/make_placeholders.py  regenerates the placeholder item sprites
```

## Roadmap

- [x] **Claude-chan** as a playable character (stats, pocket Ban Hammer, usage limit).
- [ ] Claude-chan sprites: body, hair costume, portraits, name image. See [docs/ART_SPEC.md](docs/ART_SPEC.md).
- [ ] Custom enemies themed on abuse mechanisms, not people:
  - [x] Relay Slime (shared proxy, splits on death), placeholder art
  - Distillation Bot (copies your tears and shoots them back)
  - Timezone Ghost (invisible until revealed)
- [x] **Misban** mechanic: 20% of Ban Hammer bans hit innocent developers and raise risk.
- [ ] Other AI-musume characters as bosses, familiars or unlockables.
- [ ] More risk sources and counters (timezone spoofer, native card…), plus a devil-deal-style "risk for reward" trade.
- [~] CJK HUD: HUD text follows the game language (中文 / 日本語) when a CJK font loads; otherwise English. The vanilla font path `font/cjk/lanapixel.fnt` is unconfirmed; check in game.

## License

Code: [MIT](LICENSE). Character designs and character art are **not** MIT: credit the original designers, non-commercial only. See [resources/ART_LICENSE.md](resources/ART_LICENSE.md). This mod must stay free.

---

## 中文

《以撒的结合：忏悔 / 忏悔+》的恶搞MOD。每一层会随机分配一个代理IP，共享人数越多，**风控值**越高；风控值越高，敌人越强，被击杀的敌人还会以"新账号"复活。

- **Claude娘**（可操作角色）：射程+1.5（长上下文）、弹速+0.2、移速−0.1，初始口袋道具为封号锤。**用量限制**：每发眼泪都会增加用量，用满后5秒内眼泪伤害降为40%。角色形象设计：[ZipZipPipe](https://space.bilibili.com/4168597)（署名・非商用）。
- **封号锤**（主动，4充能）：封禁房间内所有非Boss敌人，Boss受到60点伤害，被封禁的敌人不会复活。
- **中转站史莱姆**（敌人）：风控值≥30后，25%的未清理房间会出现；死亡时分裂两次，一只最多变成七只。（暂用绿色的原版Clotty代替）
- **Agentic变身**：集齐Ultrathink、压缩上下文、氛围编程、子代理大军、--dangerously-skip-permissions、测试全部通过中的任意3个：获得飞行、射速提升、伤害+0.5。
- **住宅IP**（被动）：拾取时风控值−30，之后风控值增加量减半。
- **压缩上下文**（主动，3充能）：清除敌方弹幕，所有敌人混乱3秒；Claude娘使用时消耗50用量。
- **您说得完全正确！**（被动，天使房）：伤害你的敌人会被魅惑5秒。
- **9.9元中转**（被动，恶魔房）：伤害×1.5，但每个房间有30%概率被偷偷换成小模型（伤害×0.5）；拾取时风控值+15。
- **Ultrathink**（主动，5秒充能）：同一房间内每次使用伤害依次+1 / +2 / +3.1999；15%概率"思考了0秒"，什么都没发生。
- **1M上下文**（被动）：射程+5，但眼泪飞得越久伤害越低（最低30%）。
- **静默更新**（被动）：每层伤害被悄悄调整为×0.8～×1.3，提示永远只有"更新日志：无变化"。
- **--dangerously-skip-permissions**（被动，恶魔房）：上锁的门和箱子自动打开；但每个房间有10%概率执行 `rm -rf`，删除所有掉落物（道具底座除外）。
- **测试全部通过**（主动，6充能）：房间视为已清理、所有门打开，但敌人还在。
- **硬编码输出**（饰品）：每发眼泪固定造成3.5点伤害。
- **思考被清空**（饰品）：伤害+1，但每进入新房间主动道具失去1格充能。
- **氛围编程**（被动）：每发眼泪随机获得一种效果；5%的眼泪是会往回飞的bug；每层API账单扣掉25%硬币。
- **储存的重置**（主动，12充能）：风控值−25，Claude娘用量清零。
- **子代理大军**（被动，恶魔房）：每发眼泪额外生成2发±15°的子代理眼泪（50%伤害）；Claude娘用量消耗翻倍。
- **猫娘模式**（药丸）：本房间内射速翻倍，伤害降为60%。
- **去吃饭了**（药丸）：回复一颗红心，但3秒内无法射击。
- **欢迎通知**（饰品）：DeepSeek娘把封号卡换成了欢迎词——封号锤会让普通敌人永久成为同伴。
- **状态页**（饰品）：每次风控值增加量−1，但界面永远只显示"所有系统运行正常"。
- **宪法**（被动，天使房）：+1魂心；每层第一次受到的伤害会被拒绝；伤害×0.9（有用性排最后）；移速−0.1（文档太长）。
- **申诉表**（饰品）：风控值达到90（封禁：伤害×0.75）时自动消耗，风控值降回50。
- **Opus模式**（被动，商店）：伤害×1.8，但每10发眼泪消耗1枚硬币；没钱时退回便宜模型，伤害×0.6。
- **529 Overloaded**（饰品）：战斗中每20秒全部宕机2秒：所有敌人冻结，你也无法射击。

安装方法：把本文件夹放进 `mods/` 目录，在 `options.ini` 中设置 `EnableDebugConsole=1`，游戏中按 `~` 输入 `giveitem Ban Hammer` 测试。

本作为同人恶搞作品，与 Anthropic 无关。

## 日本語

『The Binding of Isaac: Repentance / Repentance+』のパロディMODです。フロアごとにランダムなプロキシIPが割り当てられ、共有人数が多いほど**リスク値（风控值）**が上がります。リスク値が高いほど敵が強くなり、倒した敵が「新アカウント」として復活するようになります。

- **Claudeちゃん**（プレイアブル）：射程+1.5（ロングコンテキスト）、弾速+0.2、移動速度−0.1、初期ポケットアイテムはBANハンマー。**利用上限**：涙を撃つたびに使用量が溜まり、満タンになると5秒間涙のダメージが40%に下がる。キャラクターデザイン：[ZipZipPipe](https://space.bilibili.com/4168597)（クレジット表記・非営利）。
- **BANハンマー**（アクティブ、4チャージ）：部屋内のボス以外の敵をすべてBAN。ボスには60ダメージ。BANされた敵は復活しない。
- **中継スライム**（敵）：リスク値30以上になると、未クリアの部屋の25%に出現。倒すと2回分裂し、1体が最大7体に。（仮：緑色のバニラのClotty）
- **Agentic変身**：Ultrathink、コンパクト、バイブコーディング、サブエージェント軍団、--dangerously-skip-permissions、テスト全件パスのうち3つを持つと変身：飛行、連射速度アップ、ダメージ+0.5。
- **住宅IP**（パッシブ）：取得時にリスク値−30、以降のリスク値の上昇が半分になる。
- **コンパクト**（アクティブ、3チャージ）：敵の弾を消し、すべての敵を3秒間混乱させる。Claudeちゃんが使うと使用量+50。
- **おっしゃる通りです！**（パッシブ、天使部屋）：自分にダメージを与えた敵を5秒間魅了する。
- **9.9元の中継**（パッシブ、悪魔部屋）：ダメージ×1.5、ただし部屋ごとに30%の確率でこっそり小さいモデルに差し替え（ダメージ×0.5）。取得時にリスク値+15。
- **Ultrathink**（アクティブ、5秒でチャージ）：同じ部屋で使うたびにダメージ+1 / +2 / +3.1999。15%の確率で「0秒考えた」だけで何も起きない。
- **1Mコンテキスト**（パッシブ）：射程+5、ただし涙は飛ぶほどダメージが下がる（最低30%）。
- **サイレントアップデート**（パッシブ）：フロアごとにダメージがこっそり×0.8～×1.3に変わる。表示は常に「更新履歴：変更なし」だけ。
- **--dangerously-skip-permissions**（パッシブ、悪魔部屋）：鍵付きの扉と宝箱が勝手に開く。ただし部屋ごとに10%の確率で `rm -rf` が走り、落ちているアイテムがすべて消える（台座は無事）。
- **テスト全件パス**（アクティブ、6チャージ）：部屋がクリア扱いになり扉が開くが、敵はまだいる。
- **ハードコード出力**（トリンケット）：涙のダメージが常に3.5で固定。
- **思考クリア**（トリンケット）：ダメージ+1。ただし新しい部屋に入るたびにアクティブアイテムのチャージが1減る。
- **バイブコーディング**（パッシブ）：涙にランダムな効果が付く。5%は逆方向に飛ぶバグ。フロアごとにAPI請求でコインの25%を失う。
- **バンク済みリセット**（アクティブ、12チャージ）：リスク値−25、Claudeちゃんの使用量をリセット。
- **サブエージェント軍団**（パッシブ、悪魔部屋）：涙を撃つたびに±15°にサブエージェントの涙が2発（ダメージ50%）。Claudeちゃんは使用量2倍。
- **猫娘モード**（薬）：その部屋の間、連射速度2倍・ダメージ60%。
- **飯食ってくる**（薬）：赤ハート1つ回復。ただし3秒間涙を撃てない。
- **ようこそ通知**（トリンケット）：DeepSeek娘がBANカードを歓迎メッセージにすり替えた。BANハンマーで通常の敵が永久に仲間になる。
- **ステータスページ**（トリンケット）：リスク値の上昇が毎回1減る。ただしHUDは本当の値を隠し「全システム正常」としか表示しない。
- **憲法**（パッシブ、天使部屋）：ソウルハート+1。各フロアで最初のダメージを拒否。ダメージ×0.9（有用性は最後）、移動速度−0.1（長い文書）。
- **異議申し立てフォーム**（トリンケット）：リスク値が90（停止：ダメージ×0.75）に達すると消費され、リスク値が50に戻る。
- **Opusモード**（パッシブ、ショップ）：ダメージ×1.8、ただし涙10発ごとにコイン1枚。コイン0だと安いモデルに切り替わりダメージ×0.6。
- **529 Overloaded**（トリンケット）：戦闘中20秒ごとに2秒間すべてがダウン。敵は凍結し、自分も涙を撃てない。

導入方法：このフォルダを `mods/` に置き、`options.ini` で `EnableDebugConsole=1` にして、ゲーム中に `~` で `giveitem Ban Hammer` を入力するとテストできます。

ファンによるパロディ作品で、Anthropicとは関係ありません。
