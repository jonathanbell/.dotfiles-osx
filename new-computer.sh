#!/usr/bin/env bash

source ~/.dotfiles/bash/functions.sh
source ~/.dotfiles/bash/aliases.sh

cd ~

# Make a "personal" `bin` folder
if ! [ -d $HOME/bin ]; then
  mkdir $HOME/bin
  chmod -R +x $HOME/bin
fi

# Display app switcher to display on both external and internal monitors
# https://gist.github.com/jthodge/c4ba15a78fb29671dfa072fe279355f0?permalink_comment_id=4378478#gistcomment-4378478
defaults write com.apple.Dock appswitcher-all-displays -bool true

# Disable hot corners
defaults write com.apple.dock wvous-tl-corner -int 0
defaults write com.apple.dock wvous-tr-corner -int 0
defaults write com.apple.dock wvous-bl-corner -int 0
defaults write com.apple.dock wvous-br-corner -int 0

killall Dock

# Show hidden folders
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Save screenshots as jpeg
defaults write com.apple.screencapture type jpg

# Don't play sounds for UI actions
defaults write com.apple.systemsound "com.apple.sound.uiaudio.enabled" -int 0

killall Finder

# Don't show the last login in Terminal
# https://osxdaily.com/2010/06/22/remove-the-last-login-message-from-the-terminal/
touch ~/.hushlogin

# Symlink .bash_profile
chmod +x $HOME/.dotfiles/bash/.bash_profile
link $HOME/.dotfiles/bash/.bash_profile $HOME/.bash_profile
chmod +x $HOME/.bash_profile

# Install Homebrew
which -s brew
if [[ $? != 0 ]]; then
  echo 'Installing Homebrew... (you will be prompted for your password)'
  sudo mkdir -p /opt/homebrew/bin
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  brew update
fi

# Check that `brew` was installed
which -s brew
if [[ $? != 0 ]]; then
  # Homebrew is not installed correctly
  echo >&2 "This script requires that Homebrew is installed. Aborting..."
  exit 1
fi

# Reload Bash profile in order to keep XCode happy
source ~/.bash_profile

# Use Rosetta
softwareupdate --install-rosetta --agree-to-license

# Standard `brew` packages
BREWPACKAGES=(
  node
  # Things like `shuf` and other utils.
  # These utilities won't override the BSD userland by default, they link all
  # their utilities with a `g` prefix. So `shuf` becomes `gshuf`, for example.
  coreutils
  imagemagick
  vlc
  deno
  go
  tmux
  wget
  ffmpeg
  libvo-aacenc
  # Updates the Bash version vs the antique one that comes with OS X.
  bash
  # Add more GNU-like command line utilities to a Mac userland.
  gnu-sed
  findutils
  gawk
  grep
  tree
  gh
)

# Install standard `brew` packages
for i in "${BREWPACKAGES[@]}"; do
  brew install "$i"
done

# NCU (NPM Check Updates )
# https://www.npmjs.com/package/npm-check-updates
npm install -g npm-check-updates

# Claude Code: https://docs.anthropic.com/en/docs/claude-code/setup
npm install -g @anthropic-ai/claude-code

BREWCASKS=(
  google-chrome
  charles
  slack
  maccy
  dbngin
  notion-calendar
  pearcleaner
  tableplus
  firefox
  notion
  discord
  rectangle
  stellarium
  zoom
  whatsapp
  imageoptim
  font-hack-nerd-font
  font-fantasque-sans-mono-nerd-font
  corretto
  visual-studio-code
  spotify
  workflowy
  figma
  postman
  font-jetbrains-mono
  intellij-idea-ce
  claude
)

for i in "${BREWCASKS[@]}"; do
  brew install --cask "$i"
done

brew cleanup

# Setup Git
echo 'Setting Git configuration variables...'
chmod +x ~/.dotfiles/git/gitconfig.sh
~/.dotfiles/git/gitconfig.sh

# Make the `.dotfiles` dir a Git repo
mkdir -p ~/tmp && cd ~/tmp && mkdir -p ~/.dotfiles/.git && git clone git@github.com:jonathanbell/.dotfiles-osx.git && cd .dotfiles-osx/.git && mv $(ls -A) ~/.dotfiles/.git/ && cd ~ && rm -rf ~/tmp

echo "Enter your password when prompted."

# Set Terminal to use a later version of Bash.
sudo echo "/usr/local/bin/bash" >>/etc/shells
echo 'Changing your shell to Bash 5...'
echo /opt/homebrew/bin/bash | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/bash
echo 'Terminal will now use the latest version of Bash available via Homebrew. You should close Terminal and re-open it now.'
echo
echo 'All done!'
