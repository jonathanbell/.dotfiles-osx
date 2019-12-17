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
  exit
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

# Make a place to mount your personal drive
mkdir -p $HOME/mnt/Buckups

# Show hidden folders
defaults write com.apple.finder AppleShowAllFiles YES
killall Finder

# Symlink Bash files
for file in $HOME/.dotfiles/bash/.{bash_profile,bashrc}; do
  chmod +x $file
  link $file $HOME/$(basename $file)
  chmod +x $HOME/$(basename $file)
done;
unset file;

# Link SSH config file
link $sshconfigpath ~/.ssh/config
sudo chmod 700 ~/.ssh && sudo chmod -R 600 $(dirname $sshconfigpath)/*

# Install Homebrew
echo 'Installing Homebrew... (you will be prompted for your password)'
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Check that `brew` was installed.
command -v brew >/dev/null 2>&1 || {
  echo >&2 "This script requires that Homebrew is installed. Aborting...";
  exit 1;
}

# Reload Bash profile after XCode installs
source ~/.bash_profile

# Install Chrome
#brew cask install google-chrome

# Install Evernote
brew cask install evernote

# Install VS Code
brew cask install visual-studio-code

# Spotify
brew cask install spotify

# Install PHPStorm
brew cask install phpstorm

# Install Node 10
brew install node@10

# Cloudinary CLI
npm -g install cloudinary-cli

# Standard `brew` packages
BREWPACKAGES=(
  # `gshuf`, `shuf` and other utils
  coreutils
  composer
  php@7.4
  phpunit
  awscli
  imagemagick
  vlc
  gifsicle
  youtube-dl
  wget
  ffmpeg
  libvo-aacenc
)

# Install standard `brew` packages
for i in "${BREWPACKAGES[@]}"
do
  brew install "$i"
done

# Install some fonts
brew tap homebrew/cask-fonts
brew cask install font-source-code-pro

# Install Sequel Pro
brew cask install sequel-pro

# Telegram
brew cask install telegram

# Install Insomnia
brew cask install insomnia

brew cleanup

# PECL
pecl install yaml

# Install yarn
npm install -g yarn

# Setup Git
echo 'Setting Git configuration variables...'
chmod +x ~/.dotfiles/git/gitconfig.sh
~/.dotfiles/git/gitconfig.sh

# Add company configurations (if there are any)
if [ -f "$HOME/.dotfiles-$company/new-computer-$company.sh" ]; then
  chmod +x $HOME/.dotfiles-$company/new-computer-$company.sh
  ~/.dotfiles-$company/new-computer-$company.sh
fi
