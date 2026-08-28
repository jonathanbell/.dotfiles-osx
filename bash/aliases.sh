# Python.. _why_ are you so difficult to configure?
# (No `$@` here: aliases already pass through whatever follows them.)
alias python='/opt/homebrew/bin/python3'

# Colorize `grep`
alias grep='grep --color=auto'

# Edit the hosts file
alias hosts='sudo nano /etc/hosts'

# Change directories to handy OS X places
alias desk='cd ~/Desktop'
# The directory holding all the important stuff (see `JONATHAN_HOME` in env.sh)
alias d="cd \"${JONATHAN_HOME:-$HOME}\""
# Change directory to your dotfiles directory
alias dot='cd ~/.dotfiles'

# Quickly clear the terminal window
alias c='clear'
# Quickly reset the shell
alias r='reset'
# For when you make "that" typ-o...
alias cd..='cd ..'
alias ..='cd ..'

# Add a WTFP License to a directory/project
alias addwtfpl='wget -O LICENSE http://www.wtfpl.net/txt/copying/'

# Correct SSH permissions. `chmod -R 600` would strip the execute bit that
# directories need to stay traversable, so do files and directories separately.
alias correctsshpermissions='chmod 700 ~/.ssh && find ~/.ssh -type d -exec chmod 700 {} + && find ~/.ssh -type f -exec chmod 600 {} +'

# Git
alias gitdangerouslyreset='git checkout . && git branch | grep -v "master\|develop\|$(git rev-parse --abbrev-ref HEAD)" | xargs git branch -D && git branch && echo && echo "So tidy!" && echo'
# Pretty print Git's history
alias gitlog='git log --graph --oneline --all --decorate'

# Remove all Docker containers and images
alias dockerdangerouslyreset='docker stop $(docker ps -aq) && docker rm $(docker ps -aq) && docker rmi -f $(docker images -q)'

# Show a random quote
alias quote='echo $(gshuf -n 1 "$HOME/.dotfiles/bash/quotes.txt")'

# Claude - using two accounts on one computer
if [ "${IS_WORK_COMPUTER:-}" = true ]; then
	alias claude-personal="CLAUDE_CONFIG_DIR=~/.claude-personal claude"
fi
