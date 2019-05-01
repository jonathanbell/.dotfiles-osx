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
command -v brew >/dev/null 2>&1 || { echo >&2 "This script requires that Homebrew be installed. Aborting..."; exit 1; }

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
  php@7.3
  youtube-dl
  ffmpeg
  wget
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

# Start PHP at login
brew services start php

# About `sed`:
# https://askubuntu.com/questions/20414/find-and-replace-text-within-a-file-using-commands

# Enable PHP (from Homebrew) & Apache (pre-installed on Mac OS X):
sudo sed -i '.orig' "s/#LoadModule php7_module libexec\/apache2\/libphp7.so/LoadModule php7_module \/usr\/local\/opt\/php\/lib\/httpd\/modules\/libphp7.so/g" /etc/apache2/httpd.conf
# Mod ReWrite
sudo sed -i '' "s/#LoadModule rewrite_module libexec\/apache2\/mod_rewrite.so/LoadModule rewrite_module libexec\/apache2\/mod_rewrite.so/g" /etc/apache2/httpd.conf
sudo sed -i '' "s/#LoadModule include_module libexec\/apache2\/mod_include.so/LoadModule include_module libexec\/apache2\/mod_include.so/g" /etc/apache2/httpd.conf
# php.ini
sudo sed -i '' "s/#LoadModule include_module libexec\/apache2\/mod_include.so/LoadModule include_module libexec\/apache2\/mod_include.so/g" /etc/apache2/httpd.conf
# SSL
sudo sed -i '' "s/#LoadModule socache_shmcb_module libexec\/apache2\/mod_socache_shmcb.so/LoadModule socache_shmcb_module libexec\/apache2\/mod_socache_shmcb.so/g" /etc/apache2/httpd.conf
sudo sed -i '' "s/#LoadModule ssl_module libexec\/apache2\/mod_ssl.so/LoadModule ssl_module libexec\/apache2\/mod_ssl.so/g" /etc/apache2/httpd.conf
sudo sed -i '' "s/#Include \/private\/etc\/apache2\/extra\/httpd-ssl.conf/Include \/private\/etc\/apache2\/extra\/httpd-ssl.conf/g" /etc/apache2/httpd.conf
cd /private/etc/apache2
echo 'Configuring self-signed SSL certificate.......'
echo '***Enter localhost when asked for your Common Name.***'
sudo openssl req -new -x509 -days 365 -nodes -out server.crt -keyout server.key
cd -
# Ports
sudo sed -i '' "s/Listen 8080/#Listen 8080/g" /etc/apache2/httpd.conf
sudo sed -i '' "s/Listen 80/Listen 127.0.0.1:80/g" /etc/apache2/httpd.conf
sudo sed -i '' "s/DirectoryIndex index.html/DirectoryIndex index.html index.php/g" /etc/apache2/httpd.conf
sudo sed -i '' "s/#ServerName www.example.com:80/ServerName localhost:80/g" /etc/apache2/httpd.conf
# Vhosts
sudo sed -i '' "s/#Include \/private\/etc\/apache2\/extra\/httpd-vhosts.conf/Include \/private\/etc\/apache2\/extra\/httpd-vhosts.conf/g" /etc/apache2/httpd.conf
# Other Apache modules
sudo sed -i '' "s/#LoadModule authz_core_module libexec\/apache2\/mod_authz_core.so/LoadModule authz_core_module libexec\/apache2\/mod_authz_core.so/g" /etc/apache2/httpd.conf
sudo sed -i '' "s/#LoadModule authz_host_module libexec\/apache2\/mod_authz_host.so/LoadModule authz_host_module libexec\/apache2\/mod_authz_host.so/g" /etc/apache2/httpd.conf

# Make Sites directory
mkdir $HOME/Sites
touch $HOME/Sites/index.php
echo "<?php echo 'Welcome to your web root!<br>'; phpinfo(); ?>" >> $HOME/Sites/index.php
chmod -R 775 $HOME/Sites/

# Change webserver root directory
sudo sed -i '' "s/\/Library\/WebServer\/Documents/\/Users\/$(whoami)\/Sites/g" /etc/apache2/httpd.conf

# Allow .htaccess
sudo sed -i '' "s/AllowOverride None/AllowOverride All/g" /etc/apache2/httpd.conf

# Restart Apache
sudo apachectl restart

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
