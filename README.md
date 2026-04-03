# Claude Toolbox

A collection of CLI tools designed to work with [Claude Code](https://claude.com/claude-code).

Clone the repo, run `install.sh`, and all tools become available globally — across every project on your machine.

## How it works

The installer does two things:

1. **Symlinks** each script from `scripts/` into `~/.local/bin/` — making them callable from anywhere
2. **Injects** tool documentation into `~/.claude/CLAUDE.md` — so Claude Code knows when and how to use each tool, in any project

This means you can say *"extract frames from this video"* in any conversation, and Claude will automatically use the right script.

## Installation

```bash
git clone git@github.com:PrettyJuice/claude-toolbox.git
cd claude-toolbox
./install.sh
```

To update after a `git pull`, just re-run `./install.sh` — it's idempotent.

## Uninstall

```bash
./uninstall.sh
```

## Project structure

```
claude-toolbox/
├── scripts/                  # CLI scripts (the actual tools)
│   └── extract-frames.sh
├── statusline/               # Claude Code statusline script
│   └── statusline.sh
├── skills/                   # (optional) Claude Code skills
├── commands/                 # (optional) Claude Code slash commands
├── claude-instructions.md    # Tool docs injected into ~/.claude/CLAUDE.md
├── install.sh
├── uninstall.sh
└── README.md
```

The toolbox supports four types of extensions:

| Type | Directory | Installed to | Purpose |
|------|-----------|--------------|---------|
| **Scripts** | `scripts/` | `~/.local/bin/` | CLI tools that do the actual work (bash, python, etc.) |
| **Statusline** | `statusline/` | `~/.claude/statusline.sh` | Custom statusline showing rate limits with progress bars |
| **Skills** | `skills/` | `~/.claude/skills/` | Markdown files that teach Claude complex workflows — triggered automatically based on context |
| **Commands** | `commands/` | `~/.claude/commands/` | Slash commands (`/my-command`) — shortcuts you invoke manually in a conversation |

## Available tools

See [`claude-instructions.md`](claude-instructions.md) for the full list of tools and their documentation.

## Adding a new tool

### Adding a script

1. Create your script in `scripts/` and make it executable:

```bash
chmod +x scripts/my-script.sh
```

2. Document it in `claude-instructions.md` so Claude knows when and how to use it:

```markdown
### my-script — Short description

**When to use:** Describe the situations where Claude should use this tool.

**Command:**
\```bash
my-script.sh <arg1> <arg2>
\```

**Parameters:**
- `arg1` : description
- `arg2` : description
```

3. Run `./install.sh`

### Adding a skill

Create a markdown file in `skills/`. Skills are instructions that Claude picks up automatically based on context.

```markdown
# skills/video-analysis.md
Analyze video content by extracting frames with extract-frames.sh,
then describe each frame in detail...
```

Run `./install.sh` to symlink it into `~/.claude/skills/`.

### Adding a command

Create a markdown file in `commands/`. Commands are invoked manually with `/command-name` in a conversation.

```markdown
# commands/extract-frames.md
Extract frames from the video $ARGUMENTS using extract-frames.sh.
Use 5 fps by default if not specified.
```

Run `./install.sh` to symlink it into `~/.claude/commands/`.

## Statusline

If you only want the statusline without the rest of the toolbox:

```bash
git clone git@github.com:PrettyJuice/claude-toolbox.git
cd claude-toolbox/statusline
./install.sh    # install
./uninstall.sh  # uninstall
```

The statusline displays your Claude Code rate limits at a glance:

```
[Opus 4.6] 5h ████▓▓▓░░░ 42% ⏱ 1h29 │ 7d ██▓▓▓░░░░░ 23% ⏱ 2j23h
```

- **Green `█`** — quota consumed
- **Red `█`** — overconsumption (quota exceeds elapsed time — slow down!)
- **Gray `▓`** — elapsed time in the window beyond your consumption
- **Empty `░`** — time remaining before reset

Installed automatically by `install.sh` (symlink + `settings.json` config). Requires Python 3.

## Prerequisites

- [Claude Code](https://claude.com/claude-code)
- bash
- Python 3 (for the statusline)
- Per-script dependencies (e.g. `ffmpeg` for extract-frames)

## License

MIT
