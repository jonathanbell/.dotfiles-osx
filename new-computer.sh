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

rm -f ./bash/variables.sh

touch ./bash/variables.sh
echo "#!/usr/bin/env bash" >> ./bash/variables.sh
echo " " >> ./bash/variables.sh

if [ ! -z "$companyname" ]; then
  echo "export company=$companyname" >> ./bash/variables.sh
fi

echo "export sshconfigpath=$sshconfig" >> ./bash/variables.sh

source ~/dotfiles/bash/variables.sh
source ~/dotfiles/bash/functions.sh
source ~/dotfiles/bash/aliases.sh

cd ~

# Make a "personal" `bin` folder
if ! [ -d $HOME/bin ]; then
  mkdir $HOME/bin
  chmod -R +x $HOME/bin
fi

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
correctsshpermissions

# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Check that `brew` was installed.
command -v brew >/dev/null 2>&1 || {
  echo >&2 "This script requires that Homebrew is installed. Aborting...";
  exit 1;
}

# Install Chrome
brew cask install google-chrome

# Install VS Code
brew cask install visual-studio-code

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
  mcrypt
  composer
  phpunit
  # AWS
  awscli
  imagemagick
  discord
  gimp
  spotify
  visual-studio
  vlc
  # Git
  git
  gifsicle
  youtube-dl
  wget
  # ffmpeg
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
brew cask install font-inconsolata
brew cask install font-source-code-pro

# Install Sequel Pro
brew cask install sequel-pro

# Install Postman
brew cask install postman

brew cleanup

# Init Apache
chmod +x ~/.dotfiles/apache/init_apache.sh
~/.dotfiles/apache/init_apache.sh

# PECL
pecl install yaml

# Restart Apache
sudo apachectl restart

# Install MySQL
brew install mysql
brew services start mysql
brew services list | grep mysql
mysql -V
mysqladmin -u root password \"letmein\"

# Setup Git
echo 'Setting Git configuration variables...'
chmod +x ~/.dotfiles/git/gitconfig.sh
~/.dotfiles/git/gitconfig.sh

# Add company configurations (if there are any)
if [ -f "$HOME/.dotfiles-$company/new-computer-$company.sh" ]; then
  chmod +x $HOME/.dotfiles-$company/new-computer-$company.sh
  ~/.dotfiles-$company/new-computer-$company.sh
fi

# Let's see if Apache is working
open "https://localhost"
