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
├── commands/                 # (optional) Claude Code slash commands
├── claude-instructions.md    # Tool docs injected into ~/.claude/CLAUDE.md
├── install.sh
├── uninstall.sh
└── README.md
```

## Available tools

### extract-frames.sh

Extract JPG frames from a video using ffmpeg.

```bash
# Interactive mode
extract-frames.sh

# Direct mode
extract-frames.sh video.mp4 00:01:30 00:02:00 5
```

| Parameter | Description | Example |
|-----------|-------------|---------|
| `video` | Path to the video file | `video.mp4` |
| `start` | Start timestamp | `00:01:30` |
| `end` | End timestamp | `00:02:00` |
| `fps` | Frames per second to extract | `5` |

> Supports Windows paths under WSL (`C:\Users\...` is automatically converted to `/mnt/c/Users/...`).

## Adding a new tool

### 1. Create the script

Add your script to `scripts/`:

```bash
#!/usr/bin/env bash
set -euo pipefail
# your code here
```

Make it executable:

```bash
chmod +x scripts/my-script.sh
```

### 2. Document it for Claude

Add a section in `claude-instructions.md` following this template:

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

### 3. Install

```bash
./install.sh
```

### 4. (Optional) Add a slash command

To create a `/my-script` shortcut in Claude Code, add a `commands/my-script.md` file:

```markdown
Run my-script.sh with the following arguments: $ARGUMENTS
```

Then copy it to `~/.claude/commands/` or extend `install.sh` to handle it.

## Prerequisites

- [Claude Code](https://claude.com/claude-code)
- bash
- Per-script dependencies (e.g. `ffmpeg` for extract-frames)

## License

MIT
