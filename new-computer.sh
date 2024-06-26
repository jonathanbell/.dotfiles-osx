#!/usr/bin/env bash

echo "Do you have any additional dotfiles that you'd like to add to this computer's configuration? Enter your company's name in all lowercase and hyphenated."
echo -n "Example: (my-company). Leave blank to skip. [ENTER]: "
read companyname

echo

echo "Enter the full path to your SSH config file."
echo -n "Example: (/Users/<your username>/path/to/.ssh/config). [ENTER]: "
read sshconfig

echo

if [ ! -f $sshconfig ] || [ -z "$sshconfig" ]; then
  echo "Cannot find the path to the ssh config path. Exiting..."
  exit 1;
fi

# Start setting up a new variables file
rm -f ./bash/variables.sh
touch ./bash/variables.sh
echo "#!/usr/bin/env bash" >> ./bash/variables.sh
echo " " >> ./bash/variables.sh

if [ ! -z "$companyname" ]; then
  echo "export company=$companyname" >> ./bash/variables.sh
fi

echo "export sshconfigpath=$sshconfig" >> ./bash/variables.sh

source ~/.dotfiles/bash/variables.sh
source ~/.dotfiles/bash/functions.sh
source ~/.dotfiles/bash/aliases.sh

cd ~

# Make a "personal" `bin` folder
if ! [ -d $HOME/bin ]; then
  mkdir $HOME/bin
  chmod -R +x $HOME/bin
fi

# Show hidden folders
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
killall Finder

# Display app switcher to display on both external and internal monitors
# https://gist.github.com/jthodge/c4ba15a78fb29671dfa072fe279355f0?permalink_comment_id=4378478#gistcomment-4378478
defaults write com.apple.Dock appswitcher-all-displays -bool true
killall Dock

# Don't show the last login in Terminal
# https://osxdaily.com/2010/06/22/remove-the-last-login-message-from-the-terminal/
touch ~/.hushlogin

# Save screenshots as jpeg
defaults write com.apple.screencapture type jpg

# Don't play sounds for UI actions
defaults write com.apple.systemsound "com.apple.sound.uiaudio.enabled" -int 0

# Symlink .bash_profile
chmod +x $HOME/.dotfiles/bash/.bash_profile
link $HOME/.dotfiles/bash/.bash_profile $HOME/.bash_profile
chmod +x $HOME/.bash_profile

# Link SSH config file
mkdir -p ~/.ssh
link $sshconfigpath ~/.ssh/config
sudo chmod 700 ~/.ssh && sudo chmod -R 600 $(dirname $sshconfigpath)/*

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
  echo >&2 "This script requires that Homebrew is installed. Aborting...";
  exit 1;
fi

# Reload Bash profile for XCode (installed manually)
source ~/.bash_profile

# Standard `brew` packages
BREWPACKAGES=(
  node
  # Things like `shuf` and other utils.
  # These utilities won't override the BSD userland by default, they link all
  # their utilities with a `g` prefix. So `shuf` becomes `gshuf`, for example.
  coreutils
  composer
  php
  python
  phpunit
  awscli
  imagemagick
  vlc
  gifsicle
  youtube-dl
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
)

# Install standard `brew` packages
for i in "${BREWPACKAGES[@]}"
do
  brew install "$i"
done

# Cloudinary CLI
npm install -g cloudinary-cli

# NCU (NPM Check Updates )
# https://www.npmjs.com/package/npm-check-updates
npm install -g npm-check-updates

brew tap homebrew/cask-fonts

BREWCASKS=(
  google-chrome
  veracrypt
  slack
  db-browser-for-sqlite
  firefox
  notion
  transmission
  discord
  expressvpn
  stellarium
  zoom
  docker
  meld
  font-hack-nerd-font
  font-fantasque-sans-mono-nerd-font
  corretto
  ngrok
  visual-studio-code
  spotify
  workflowy
  sequel-pro
  figma
  postman
  font-jetbrains-mono
)

for i in "${BREWCASKS[@]}"
do
  brew install --cask "$i"
done

brew cleanup

# Setup Git
echo 'Setting Git configuration variables...'
chmod +x ~/.dotfiles/git/gitconfig.sh
~/.dotfiles/git/gitconfig.sh

# Add company configurations (if there are any)
if [ -f "$HOME/.dotfiles-$company/new-computer-$company.sh" ]; then
  chmod +x $HOME/.dotfiles-$company/new-computer-$company.sh
  ~/.dotfiles-$company/new-computer-$company.sh
fi

# Set Terminal to use a later version of Bash.
sudo echo "/usr/local/bin/bash" >> /etc/shells
echo 'Changing your shell to Bash 5...'
echo /opt/homebrew/bin/bash | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/bash
echo 'Terminal will now use the latest version of Bash available via Homebrew. You should close Terminal and re-open it now.'
echo
echo 'All done!'
