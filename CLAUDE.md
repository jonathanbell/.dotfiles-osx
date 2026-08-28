# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

macOS dotfiles repository for development and photography workflow setup. The main entry point is `new-computer.sh` which automates the complete setup of a new Mac.

## Structure

- `bash/` - Shell configuration: `.bash_profile` (main config, PATH, prompt), `aliases.sh`, `functions.sh`, `env.sh` (gitignored), `env.sh.example` (template), `quotes.txt`
- `git/` - Git configuration (`gitconfig.sh`) and completion scripts
- `claude/` - Claude Code config files (`CLAUDE.md`, commands, settings, statusline) symlinked to `~/.claude/`. Skills are deliberately **not** stored here: `new-computer.sh` installs them from their upstream repos with `npx skills add --global`.
- `kitty/` - Kitty terminal config, symlinked to `~/.config/kitty/`
- `node/` - Node version helper (`switch-node.sh`), symlinked onto `PATH` at `~/.local/bin/`
- `.cspell.json` - Spell-check dictionary for this repo
- `new-computer.sh` - Main installation script

Not everything the installer sets up lives in this repo: `new-computer.sh` also
downloads the `yt-dlp` release binary into `~/.local/bin` (the `download_video`
function needs it) and installs the Claude Code plugins that `settings.json`
enables.

## Key Patterns

### Symlinks

Config files are stored here and symlinked to their expected locations via the `link()` function in `functions.sh`. It clears the destination (symlink, file or directory) and then `ln -s`, returning non-zero if the link fails. The `new-computer.sh` script sets up all symlinks. When adding new config files, follow this pattern: store the file in this repo, add a `link` call in `new-computer.sh`.

### Homebrew

Packages are managed as arrays (`BREWPACKAGES`, `BREWCASKS`) in `new-computer.sh` and installed in loops. Add new packages to the appropriate array.

### Shell Configuration

`.bash_profile` sources `env.sh`, `aliases.sh`, and `functions.sh` in that order. `env.sh` is gitignored and holds machine-specific variables and secrets - copy `env.sh.example` to get started. The shell uses Bash 5 from Homebrew (not the macOS default).

`aliases.sh` and `functions.sh` are only sourced in interactive shells. Scripts that need one of the functions (`new-computer.sh` wants `link`) source `functions.sh` directly.

### Strict mode

`new-computer.sh` and `node/switch-node.sh` run under `set -euo pipefail`. Three consequences worth remembering when editing them:

- Read any variable that might be unset as `${VAR:-}`, since `env.sh` may not exist yet. This applies to anything `new-computer.sh` sources, so `env.sh` and `functions.sh` have to be `set -u` clean too.
- A command whose failure is expected (`killall` on a process that isn't running, `brew install` on an already-installed package) needs an explicit `|| true`.
- On a fresh Mac the whole script runs under the system Bash 3.2, because Homebrew's Bash 5 isn't installed until part way through. Anything Bash 4+ (`shopt -s globstar`, associative arrays) fails there, and under `set -e` a failure is fatal. `.bash_profile` guards its `shopt` line with `|| true` for exactly this reason, and `new-computer.sh` drops out of `set -eu` around the `source ~/.bash_profile` line, since that file (and the `~/.bashrc` it sources) is written for an interactive shell rather than for strict mode.

Never put `set -e` and friends inside a shell function in `functions.sh`. Functions share the interactive shell's options, so it would stay on for the rest of the session.

## GitHub and Source Control

When creating commits make the commit message sound natural, like a human wrote it. Keep the commit body short and to the point.

When creating pull requests always create them in DRAFT mode so that a human can manually check them before submitting them for peer review.
