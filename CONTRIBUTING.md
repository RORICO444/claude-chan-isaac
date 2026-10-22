# 一起做 Claude娘 MOD

> English: the project state and conventions are in [docs/HANDOFF.md](docs/HANDOFF.md). This guide covers the same rules in Chinese for our contributors.
> 日本語：プロジェクトの現状とルールは [docs/HANDOFF.md](docs/HANDOFF.md)（英語）にまとめてあります。

欢迎！这份说明写给想一起改这个 MOD 的朋友。不会写代码也完全可以参与，现在最缺的反而是**进游戏测试**和**画像素图**。

## 现在的进度

代码基本写完了（15 个道具、6 个饰品、2 种药丸、1 个角色、1 个敌人），在模拟环境里的测试都能通过，但**还没有在真正的游戏里跑过**，美术全是占位图。详细状态看 [docs/HANDOFF.md](docs/HANDOFF.md)。

## 能帮什么忙

| 想做的事 | 看哪里 |
|---|---|
| 进游戏测试，找 bug | [docs/TESTING.md](docs/TESTING.md)，约 15 分钟走一遍，发现问题就[开 Issue](../../issues/new/choose) |
| 画像素图 | [docs/ART_SPEC.md](docs/ART_SPEC.md)。角色设计来自 ZipZipPipe，先看 [resources/ART_LICENSE.md](resources/ART_LICENSE.md) |
| 调数值、说手感 | [docs/BALANCE.md](docs/BALANCE.md) |
| 出点子（新道具、新敌人、新梗） | [docs/IDEAS.md](docs/IDEAS.md)，或者直接开 Issue |
| 写代码 | 下面的「改代码的流程」和「加新道具的清单」 |

## 怎么加入

**常驻成员：成为协作者（推荐）。** 把你的 GitHub 用户名发给仓库主人，接受邀请邮件后就能直接建分支、推送。

**偶尔改一下：Fork。** 点仓库右上角的 Fork，在自己的副本里改，再提 Pull Request（PR）。

不熟悉 git 的话，用 [GitHub Desktop](https://desktop.github.com/) 就行，全是按钮，不用敲命令。

## 在游戏里跑起来

最省事的办法是**直接 clone 到游戏的 mods 文件夹**，以后拉一下更新就是最新版：

```bash
cd "C:/Program Files (x86)/Steam/steamapps/common/The Binding of Isaac Rebirth/mods"
git clone https://github.com/WaterLily5297/claude-chan-isaac.git
```

文件夹名必须是 `claude-chan-isaac`（和 `metadata.xml` 里的 `<directory>` 一致）。

然后：

1. 打开控制台：在 `文档/My Games/Binding of Isaac Repentance+/options.ini` 里把 `EnableDebugConsole` 改成 `1`。
2. 启动游戏，在 MOD 菜单里确认 **Claude-chan: Risk Control** 已开启。
3. 游戏里按 `~` 打开控制台。**红色文字就是报错，原样复制下来。**

常用命令：

| 命令 | 作用 |
|---|---|
| `giveitem Ban Hammer` | 获得道具（用英文名） |
| `giveitem t529 Overloaded` | 获得饰品（名字前加 `t`） |
| `stage 2` | 跳到第 2 层 |
| `debug 3` | 无敌，方便测试 |
| `luamod claude-chan-isaac` | 改完 Lua 后重新加载，不用重启游戏 |

## 改代码的流程

1. **先同步最新的 main。** 大家都在改，先拉一下能少很多冲突。
2. **开一个新分支**，名字写清楚是谁、做什么：
   ```bash
   git switch -c xiaoming/distillation-bot
   ```
3. **改，然后进游戏试。**
4. **跑一遍检查：**
   ```bash
   bash tools/check.sh
   ```
   它会检查空文件、Lua 语法、XML 格式、贴图路径，再跑 `tests/` 里的测试。需要 Lua 5.3+ 和 Python 3；Windows 上在 Git Bash 里运行。
5. **推送，开 PR。** 写清楚改了什么、怎么测的。GitHub 会自动再跑一遍同样的检查，出现绿色 ✓ 才合并。
6. **至少让另一个人看一眼再合并。** 不要直接推到 `main`。

PR 尽量小：一个道具一个 PR，比一次改十个文件好审得多。

## 加新道具的清单

照着做一遍，基本不会漏：

1. `scripts/items/` 里写脚本，一个道具一个文件
2. `scripts/constants.lua` 里加 ID
3. `content/items.xml` 里登记
4. `content/itempools.xml` 里放进道具池
5. `main.lua` 里 `include`（**顺序有影响**，见下）
6. `scripts/eid.lua` 里写描述：英文、简体中文、日文
7. 贴图：先在 `tools/make_placeholders.py` 里加占位图
8. `README.md` 三种语言都加一行
9. `CHANGELOG.md` 写一句，附上梗的出处
10. `docs/TESTING.md` 加一行测试步骤
11. `tests/smoke_test.lua` 加一个简单的测试

几个容易踩的坑：

- **要存档的数据放 `Risk.state`**，不要放 `player:GetData()`，后者存档读档后会丢。
- **回调顺序有影响。** `MC_ENTITY_TAKE_DMG` 遇到第一个返回值的回调就停下，所以「宪法」要在 `Risk:Init` 之前 include。
- **随机数用带种子的 RNG**：`RNG():SetSeed(startSeed + 偏移)`，这样同一个种子的局能复现。

## 玩家看得到的文字要有三种语言

道具描述（EID）、HUD、README 都要有**英文、简体中文、日文**。不会日文没关系，先写中英文，在 PR 里说一声，别人来补。

## 内容规则（重要）

这些是和仓库主人商量好的，请一定遵守：

- **敌人是滥用机制**（共享代理、批量账号、脚本机器人），**永远不是某类人或某个国家的人**。误封也是笑点的一部分。
- 不提 Grok 2025 年 7 月的冒犯性内容。Grok娘 Boss 的点子只用「更新被回滚」这个梗。
- 不使用 Anthropic、OpenAI 等任何公司的官方 logo。
- MOD 永远免费、非商用。
- 署名：Claude娘设计 ZipZipPipe；DeepSeek娘还需要署名 上善无形，并遵守 CC BY-NC-SA 4.0。
- 代码是 MIT，但**角色设计和角色美术不是 MIT**，详见 [resources/ART_LICENSE.md](resources/ART_LICENSE.md)。

## 用 AI 写代码

完全可以。仓库里的 `CLAUDE.md` 会让 Claude Code 自动读到这些规范。AI 写的代码也一样：要进游戏试，要过 `tools/check.sh`。

## 遇到问题

- 游戏里的 bug：[开 Issue](../../issues/new/choose)，选「Bug」，贴控制台红字原文。
- 不确定怎么做：直接在群里问，或者开个 Issue 讨论。
