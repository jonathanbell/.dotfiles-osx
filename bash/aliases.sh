# Edit hosts file
alias hosts='sudo nano /etc/hosts'

# PHP
alias configphp='sudo nano /usr/local/etc/php/7.4/php.ini'
alias serve='open http://127.0.0.1:8080 && /usr/local/opt/php@7.2/bin/php -S 127.0.0.1:8080'

# Change directories to handy OS X places
alias desk='cd ~/Desktop'
# Dropbox directory.
alias d='cd ~/Dropbox'
# Change directory to your dotfiles directory.
alias dot='cd ~/.dotfiles'

# Sync and backup
#alias syncbackups="rsync -rv --delete --exclude=.Spotlight* --exclude=.DS_Store exclude=._.DS_Store --exclude=.fseventsd* --exclude=.Trashes* --exclude=/tmp /Volumes/Everything/ /Volumes/PATRICE/"

# Quickly clear the Terminal window
alias c='clear'

# For when you make that typ-o...
alias cd..='cd ..'
alias ..='cd ..'

# Add a WTFP Licence to a directory/project.
alias addwtfpl='wget -O LICENCE http://www.wtfpl.net/txt/copying/'

# Correct SSH permissions
alias correctsshpermissions="sudo chmod 700 ~/.ssh && sudo chmod -R 600 /Users/jbell/.ssh/*"

# Git
alias gitdangerouslyreset='git checkout . && git branch | grep -v "master\|develop\|$(git rev-parse --abbrev-ref HEAD)" | xargs git branch -D && git branch && echo && echo "So tidy!" && echo'
# Pretty print Git's history
alias gitlog='git log --graph --oneline --all --decorate'

# List all globally installed NPM packages
alias globalnpmpackages='npm list -g --depth 0'

# Remove all Docker containers and images
alias resetdocker='docker stop $(docker ps -aq) && docker rm $(docker ps -aq) && docker rmi -f $(docker images -q)'

# Change directory in preparation for making some hashtag goodness.
alias insta='cd $HOME/bin/hashtags'

# Run insecure Chrome
alias chromeinsecure="mkdir -p $HOME/Desktop/tmp && /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome -n --allow-running-insecure-content --user-data-dir=$HOME/Desktop/tmp"
