alias python='/opt/homebrew/bin/python3 $@'
# use pip3 for pip command

# Edit the hosts file
alias hosts='sudo nano /etc/hosts'

# Change directories to handy OS X places
alias desk='cd ~/Desktop'
# Dropbox directory
alias d='cd ~/Dropbox'
# Change directory to your dotfiles directory
alias dot='cd ~/.dotfiles'

# Sync and backup.
alias backupbackups="rsync -rv --delete --exclude=.Spotlight* --exclude=.DS_Store exclude=._.DS_Store --exclude=.fseventsd* --exclude=.Trashes* --exclude=/tmp /Volumes/Everything/ /Volumes/PATRICE/"

# Quickly clear the Terminal window
alias c='clear'
# For when you make that typ-o...
alias cd..='cd ..'
alias ..='cd ..'

# Add a WTFP Licence to a directory/project
alias addwtfpl='wget -O LICENCE http://www.wtfpl.net/txt/copying/'

# Correct SSH permissions
alias correctsshpermissions="sudo chmod 700 $HOME/.ssh && sudo chmod -R 600 $HOME/.ssh/*"

# Git
alias gitdangerouslyreset='git checkout . && git branch | grep -v "master\|develop\|$(git rev-parse --abbrev-ref HEAD)" | xargs git branch -D && git branch && echo && echo "So tidy!" && echo'
# Pretty print Git's history
alias gitlog='git log --graph --oneline --all --decorate'

# List all globally installed NPM packages
alias globalnpmpackages='npm list -g --depth 0'

# Remove all Docker containers and images
alias dockerdangerouslyreset='docker stop $(docker ps -aq) && docker rm $(docker ps -aq) && docker rmi -f $(docker images -q)'

# Show a random quote
alias quote='echo $(gshuf -n 1 "$HOME/.dotfiles/bash/quotes.txt")'
