# claude-design-stack

一条命令装好**一套精选的 Claude Code 设计技能**——外加一张**决策表**,告诉你(和模型)什么活该用哪个。

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
![Skills](https://img.shields.io/badge/skills-8-orange)
![Shell](https://img.shields.io/badge/install-pure%20bash-555)

[English](./README.md)

---

Claude Code 现在的设计技能是真的好用了——[impeccable](https://github.com/pbakaus/impeccable)、[taste 套件](https://github.com/Leonxlnx/taste-skill)、[ui-ux-pro-max](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill)、Anthropic 的 `design:*`。但跟着来两个问题:

1. **你得一个个装**,每个在不同的仓、不同的目录结构。
2. **它们大面积重叠。**"重设计这个页面"一句话同时命中四个技能,模型选哪个全凭运气——或者你几个叠着用,它们互相打架。

`claude-design-stack` 把这两件事都解决了:**一条命令装好一套精选技能**,再附一张**路由表**——决策表会被拷到 `~/.claude/DESIGN-SKILLS.md` 并自动加载——让对的活交给对的技能,而不是抛硬币。

## 安装

```bash
git clone https://github.com/YunyueLi/claude-design-stack.git
cd claude-design-stack
./install.sh
```

然后**重启 Claude Code**。就这样——直接开口要设计,或者打 `/impeccable` 自己驱动。

```
./install.sh --no-claude-md        # 不动 ~/.claude/CLAUDE.md
./install.sh --no-ui-ux-pro-max    # 跳过那个大数据库技能
./uninstall.sh                     # 卸掉它装的一切
```

> **前置:** `git`。`ui-ux-pro-max` 的检索脚本还会用到 `python3`(可选)。
>
> **更想跟 Claude 说?** 不用 clone,直接装成插件:
> ```
> claude plugin marketplace add YunyueLi/claude-design-stack
> claude plugin install claude-design-stack@claude-design-stack
> ```
> 然后开口就行:*"把设计栈装上。"*(或者打 `/claude-design-stack`。)

## 这套里有什么

| 技能 | 干嘛的 | 怎么调 | 来源 |
|---|---|---|---|
| **impeccable** | 反 AI 味的前端设计;23 条命令(craft / audit / critique / polish / animate / harden…) | `/impeccable <命令>` | [pbakaus/impeccable](https://github.com/pbakaus/impeccable) · Apache-2.0 |
| **design-taste-frontend** | 反 slop 核心:brief → 不像模板的界面 | 自动 / 点名 | [Leonxlnx/taste-skill](https://github.com/Leonxlnx/taste-skill) · MIT |
| **high-end-visual-design** | 让 UI"看起来很贵" | 自动 / 点名 | ↑ |
| **redesign-existing-projects** | 不破坏功能地升级老站 | 自动 / 点名 | ↑ |
| **minimalist-ui** | 极简编辑风 | 自动 / 点名 | ↑ |
| **industrial-brutalist-ui** | 工业野兽派 | 自动 / 点名 | ↑ |
| **full-output-enforcement** | 强制完整、不截断的代码输出 | 自动 / 点名 | ↑ |
| **ui-ux-pro-max** | 可检索的设计库:161 配色、57 字体配对、99 条 UX 准则、25 种图表… | 自动 / 点名 | [nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) · MIT |

本仓**不二次分发**这些技能——`install.sh` 各自从它们的上游、按各自的许可证拉取。

## 路由表(这才是重点)

完整决策表在 [`DESIGN-SKILLS.md`](./DESIGN-SKILLS.md),安装时会拷到 `~/.claude/DESIGN-SKILLS.md`。尝个鲜:

| 你要做的事 | 用 |
|---|---|
| 做个不像 AI 模板的落地页 | `design-taste-frontend` 或 `/impeccable craft` |
| 把旧站升级成高级感 | `redesign-existing-projects` |
| 让 UI"看起来很贵"(字体 / 间距 / 阴影 / 动效) | `high-end-visual-design` |
| 从精选库里挑配色 / 字体配对 / 图表 | `ui-ux-pro-max` |
| 技术审计(无障碍 + 性能 + 响应,打分) | `/impeccable audit` |
| 设计评审 / 要批评 | `/impeccable critique` |
| 加动效 / 微交互 | `/impeccable animate` |
| 简化一个过载的界面 | `/impeccable distill` |
| 太单调 → 加冲击力 / 加色 | `/impeccable bolder`、`/impeccable colorize` |

它还写清了**调用机制**(只有 `impeccable` 能打斜杠,taste 系列靠模型自动调)和**重叠规则**(同一个微任务别把 taste 技能和 impeccable 叠着用)。

## 工作原理

- `install.sh` 把 8 个技能文件夹放进 `~/.claude/skills/`——Claude Code 本来就会扫这里。
- 把路由表拷到 `~/.claude/DESIGN-SKILLS.md`,并往 `~/.claude/CLAUDE.md` 加一行,让 Claude **在任何设计任务前先读路由表**(用 `--no-claude-md` 可跳过)。
- 没有后台进程,不上报任何东西。它做的就是你手动也能做的 `git clone` + `cp`。

## 可选附加(路由表里引用了,但单独装)

- **Anthropic `design:*` 套件**——`accessibility-review`、`design-critique`、`design-handoff`、`design-system`、`ux-copy`、`user-research`、`research-synthesis`。装上 design 插件就有;路由表已经知道什么时候该叫哪个。
- **MCP**——`pencil`(编辑 `.pen` 文件)、`visualize`(聊天里出 SVG/HTML 内联可视化)。连上对应 MCP 时可用。

## 致谢

这个项目做的是精选 + 路由。技能本身是各位作者的功劳——去给他们点星:
[pbakaus/impeccable](https://github.com/pbakaus/impeccable)、[Leonxlnx/taste-skill](https://github.com/Leonxlnx/taste-skill)、[nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill)。

## 许可证

[MIT](./LICENSE) © YunyueLi and contributors。打包的技能各自保留其许可证(见 [LICENSE](./LICENSE))。
