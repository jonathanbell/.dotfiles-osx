#!/usr/bin/env bash

set -euo pipefail

if [ -f "$HOME/.dotfiles/bash/env.sh" ]; then
	source "$HOME/.dotfiles/bash/env.sh"
fi
source ~/.dotfiles/bash/functions.sh

cd ~

# This script needs `sudo` in a few places, so get the prompt out of the way up
# front rather than surprising you half an hour in.
echo 'This script needs administrator access. Enter your password when prompted.'
sudo -v

# Display app switcher on both external and internal monitors
# https://gist.github.com/jthodge/c4ba15a78fb29671dfa072fe279355f0?permalink_comment_id=4378478#gistcomment-4378478
defaults write com.apple.Dock appswitcher-all-displays -bool true

# Disable hot corners
defaults write com.apple.dock wvous-tl-corner -int 0
defaults write com.apple.dock wvous-tr-corner -int 0
defaults write com.apple.dock wvous-bl-corner -int 0
defaults write com.apple.dock wvous-br-corner -int 0

sudo pmset -a displaysleep 5

# `killall` fails when the process isn't running, which is fine here
killall Dock || true

# Show all file extensions in Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show hidden files, and unhide the Library folder
defaults write com.apple.finder AppleShowAllFiles -bool true
chflags nohidden ~/Library

# Save screenshots as jpeg
defaults write com.apple.screencapture type jpg

# Don't play sounds for UI actions
defaults write com.apple.systemsound "com.apple.sound.uiaudio.enabled" -int 0

killall Finder || true

# Don't show the last login in Terminal
# https://osxdaily.com/2010/06/22/remove-the-last-login-message-from-the-terminal/
touch ~/.hushlogin

# Symlink .bash_profile
link "$HOME/.dotfiles/bash/.bash_profile" "$HOME/.bash_profile"

# Install Homebrew. Let the installer create and chown /opt/homebrew itself;
# pre-making it as root confuses it.
if ! command -v brew >/dev/null 2>&1; then
	echo 'Installing Homebrew...'
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	eval "$(/opt/homebrew/bin/brew shellenv)"
else
	brew update
fi

# Check that `brew` was installed
if ! command -v brew >/dev/null 2>&1; then
	# Homebrew is not installed correctly
	echo >&2 "This script requires that Homebrew is installed. Aborting..."
	exit 1
fi

# Ensure that we have a local bin directory to use
mkdir -p ~/.local/bin

# Add scripts and binaries to a PATH location
link "$HOME/.dotfiles/node/switch-node.sh" ~/.local/bin/switch-node.sh

# Reload Bash profile in order to keep XCode happy. It is written for an
# interactive Bash 5 shell and it sources ~/.bashrc, so a stray non-zero exit
# from either shouldn't take the whole setup down with it.
set +eu
source ~/.bash_profile
set -eu

# GOPATH
mkdir -p "$HOME/go"

# Use Rosetta (already-installed and Intel Macs both exit non-zero here)
softwareupdate --install-rosetta --agree-to-license || true

# Install Claude Code. Network fetch, so don't let a blip abort the run.
curl -fsSL https://claude.ai/install.sh | bash || echo >&2 'Skipping Claude Code (the install failed).'

# Standard `brew` packages
BREWPACKAGES=(
	node
	# Things like `shuf` and other utils.
	# These utilities won't override the BSD userland by default, they link all
	# their utilities with a `g` prefix. So `shuf` becomes `gshuf`, for example.
	coreutils
	shfmt
	# This repo is ~all Bash and runs under `set -euo pipefail`; lint it
	shellcheck
	go
	wget
	rsync
	ffmpeg
	# Updates the Bash version vs the antique one that comes with OS X
	bash
	# Add more GNU-like command line utilities to a Mac userland
	gnu-sed
	findutils
	gawk
	grep
	jq
	tree
	gh
	exiftool
	# The `python` alias in aliases.sh points at Homebrew's python3
	python
)

# Install standard `brew` packages. An already-installed package exits non-zero,
# which shouldn't stop the rest of the run.
for i in "${BREWPACKAGES[@]}"; do
	brew install "$i" || echo >&2 "Skipping $i (already installed, or the install failed)"
done

# NCU (NPM Check Updates )
# https://www.npmjs.com/package/npm-check-updates
npm install -g npm-check-updates || echo >&2 'Skipping npm-check-updates (the install failed).'

BREWCASKS=(
	vlc
	google-chrome
	charles
	slack
	maccy
	dbngin
	pearcleaner
	tableplus
	discord
	rectangle
	stellarium
	zoom
	whatsapp
	imageoptim
	kitty
	font-hack-nerd-font
	font-fantasque-sans-mono-nerd-font
	corretto
	visual-studio-code
	spotify
	figma
	postman
	font-jetbrains-mono
	claude
)

for i in "${BREWCASKS[@]}"; do
	brew install --cask "$i" || echo >&2 "Skipping $i (already installed, or the install failed)"
done

brew cleanup

# yt-dlp (used by the `download_video` function) ships a macOS release binary.
# https://github.com/yt-dlp/yt-dlp/wiki/Installation
echo 'Installing yt-dlp...'
if curl -fL https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_macos -o ~/.local/bin/yt-dlp; then
	chmod a+rx ~/.local/bin/yt-dlp
else
	echo >&2 'Skipping yt-dlp (the download failed). The `download_video` function needs it.'
fi

# Symlink Claude config files
mkdir -p "$HOME/.claude"
link "$HOME/.dotfiles/claude/commands" "$HOME/.claude/commands"
link "$HOME/.dotfiles/claude/statusline.sh" "$HOME/.claude/statusline.sh"
link "$HOME/.dotfiles/claude/settings.json" "$HOME/.claude/settings.json"
link "$HOME/.dotfiles/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

# Install AI skills. These are fetched from the network, so don't let one
# unreachable repo abort the whole setup.
npx --yes skills add --global blader/humanizer --skill humanizer --agent=claude-code || true
npx --yes skills add --global JuliusBrussee/caveman --skill caveman-commit --agent claude-code || true
npx --yes skills add --global JuliusBrussee/caveman --skill caveman --agent=claude-code || true
npx --yes skills add --global https://github.com/anthropics/skills --skill skill-creator --agent=claude-code || true
npx --yes skills list --global || true

# Install the Claude Code plugins that settings.json enables
claude plugin install --yes typescript-lsp@claude-plugins-official || true

# Symlink Kitty config files
mkdir -p "$HOME/.config/kitty"
link "$HOME/.dotfiles/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"

# Setup Git
echo 'Setting Git configuration variables...'
chmod +x ~/.dotfiles/git/gitconfig.sh
~/.dotfiles/git/gitconfig.sh

# Set Terminal to use the correct version of Bash
echo 'Changing your shell to Bash 5...'
# Only append if it isn't already listed, otherwise re-runs pile up duplicates
if ! grep -qxF '/opt/homebrew/bin/bash' /etc/shells; then
	echo /opt/homebrew/bin/bash | sudo tee -a /etc/shells
fi
chsh -s /opt/homebrew/bin/bash
echo 'Terminal will now use the latest version of Bash available via Homebrew. You should close Terminal and re-open it now.'
echo
echo 'All done!'
