# Jonathan Bell's Dotfiles

A simple computer configuration Git repository used for new computer setup and usage.

## Repository Overview

This is a macOS dotfiles repository for development and photography workflow setup. The main entry point is `new-computer.sh` which automates the complete setup of a new Mac.

## Key Commands

### Setup and Installation

- `./new-computer.sh` - Main setup script that installs Homebrew, apps, and configures the system
- `chmod +x new-computer.sh` - Make setup script executable

### Common Development Tasks

- `listening <port>` - Check what's running on a specific port
- `gitdangerouslyreset` - Reset git repo to clean state (use with caution)
- `dockerdangerouslyreset` - Remove all Docker containers and images
- Many others, see the bash/functions.sh file

## Code Architecture

### Structure

- `bash/` - All bash configuration files
  - `.bash_profile` - Main shell configuration with PATH, prompt, and sourcing
  - `aliases.sh` - Command shortcuts and navigation helpers
  - `functions.sh` - 25+ utility functions for development, media processing, and backups
  - `quotes.txt` - Random quotes displayed on shell startup
- `git/` - Git configuration and completion scripts
- `new-computer.sh` - Main installation script that handles Homebrew, apps, and system config

### Installation Flow

1. Manual macOS setup and SSH key placement
2. One-line curl command downloads repo to `~/.dotfiles`
3. `./new-computer.sh` handles complete system configuration
4. Symlinks `.bash_profile` to home directory
5. Shell restart activates new configuration

### Homebrew Integration

The setup script installs and manages packages via Homebrew, including development tools (Node.js, Docker, Git), media tools (ImageMagick, FFmpeg), and GUI applications via Casks.

### Git Configuration

Uses Zed as editor/merge tool, configured for modern Git workflow with auto-rebase and current branch push defaults.

## GitHub and source control

When creating commits never mention Claude Code, Anthropic or any AI tools. Make the commit message sound natural, like a human wrote it.

When creating pull requests always create them in DRAFT mode so that a human can manually check them before submitting them for peer review.
