alias python='/opt/homebrew/bin/python3 $@'

# Edit the hosts file
alias hosts='sudo nano /etc/hosts'

# Change directories to handy OS X places
alias desk='cd ~/Desktop'
# iCloud directory
alias d="cd \"$ICLOUD_HOME\""
# Change directory to your dotfiles directory
alias dot='cd ~/.dotfiles'

# Quickly clear the Terminal window
alias c='clear'
# For when you make "that" typ-o...
alias cd..='cd ..'
alias ..='cd ..'

# Add a WTFP License to a directory/project
alias addwtfpl='wget -O LICENSE http://www.wtfpl.net/txt/copying/'

# Correct SSH permissions
alias correctsshpermissions="sudo chmod 700 $HOME/.ssh && sudo chmod -R 600 $HOME/.ssh/*"

# Git
alias gitdangerouslyreset='git checkout . && git branch | grep -v "master\|develop\|$(git rev-parse --abbrev-ref HEAD)" | xargs git branch -D && git branch && echo && echo "So tidy!" && echo'
# Pretty print Git's history
alias gitlog='git log --graph --oneline --all --decorate'

# Remove all Docker containers and images
alias dockerdangerouslyreset='docker stop $(docker ps -aq) && docker rm $(docker ps -aq) && docker rmi -f $(docker images -q)'

# Show a random quote
alias quote='echo $(gshuf -n 1 "$HOME/.dotfiles/bash/quotes.txt")'
