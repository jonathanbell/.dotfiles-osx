# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

macOS dotfiles repository for development and photography workflow setup. The main entry point is `new-computer.sh` which automates the complete setup of a new Mac.

## Structure

- `bash/` - Shell configuration: `.bash_profile` (main config, PATH, prompt), `aliases.sh`, `functions.sh`, `env.sh` (gitignored), `env.sh.example` (template), `quotes.txt`
- `git/` - Git configuration (`gitconfig.sh`) and completion scripts
- `claude/` - Claude Code config files (commands, settings, statusline) symlinked to `~/.claude/`
- `zed/` - Zed editor config symlinked to `~/.config/zed/`
- `config/` - Misc config files (e.g. `.rsyncignore`)
- `new-computer.sh` - Main installation script

## Key Patterns

### Symlinks

Config files are stored here and symlinked to their expected locations via the `link()` function in `functions.sh` (which does `rm -f` then `ln -s`). The `new-computer.sh` script sets up all symlinks. When adding new config files, follow this pattern: store the file in this repo, add a `link` call in `new-computer.sh`.

### Homebrew

Packages are managed as arrays (`BREWPACKAGES`, `BREWCASKS`) in `new-computer.sh` and installed in loops. Add new packages to the appropriate array.

### Shell Configuration

`.bash_profile` sources `env.sh`, `aliases.sh`, and `functions.sh` in that order. `env.sh` is gitignored and holds machine-specific variables and secrets - copy `env.sh.example` to get started. The shell uses Bash 5 from Homebrew (not the macOS default).

## GitHub and Source Control

When creating commits make the commit message sound natural, like a human wrote it. Keep the commit body short and to the point.

When creating pull requests always create them in DRAFT mode so that a human can manually check them before submitting them for peer review.
