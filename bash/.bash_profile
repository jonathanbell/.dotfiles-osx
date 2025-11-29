# Displays current Git branch, if there is one
parse-git-branch() {
	git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/  [\1] /'
}

# Add common bin locations
export PATH="$HOME/.local/bin:$PATH"

# Golang
export GOPATH=$HOME/go
export PATH="$GOPATH/bin:$PATH"

# Add Homebrew to path
if [ -d "/opt/homebrew/bin" ]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Add `code` to path
# https://code.visualstudio.com/docs/setup/mac
if [ -d '/Applications/Visual Studio Code.app' ]; then
	export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"
fi

# This stuff is only needed in interactive shells
if [[ $- == *i* ]]; then
	# Add git completion
	# https://medium.com/fusionqa/autocomplete-git-commands-and-branch-names-in-terminal-on-mac-os-x-4e0beac0388a
	. ~/.dotfiles/git/git-completion.bash

	# Case-insensitive globbing (used in pathname expansion)
	shopt -s nocaseglob

	# Append to the Bash history file, rather than overwriting it
	shopt -s histappend

	# Omit duplicates from bash history and commands that begin with a space
	export HISTCONTROL='erasedups:ignoreboth'

	# Save multi-line commands as one command
	shopt -s cmdhist

	# Huge history. Doesn't appear to slow things down, so why not?
	export HISTSIZE=50000
	export HISTFILESIZE=50000

	# Don't record some commands
	export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"

	# Auto-correct typo-s in path names when using `cd`
	shopt -s cdspell

	# Colorize `grep`
	alias grep='grep --color=auto'

	# Perform file completion in a case insensitive fashion
	bind 'set completion-ignore-case on'

	# Treat hyphens and underscores as equivalent
	bind 'set completion-map-case on'

	# Display matches for ambiguous patterns at first tab press
	bind 'set show-all-if-ambiguous on'

	# Immediately add a trailing slash when autocompleting symlinks to directories
	bind 'set mark-symlinked-directories on'

	# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
	[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(awk '/^Host/ && !/[?*]/ {for(i=2;i<=NF;i++) print $i}' ~/.ssh/config)" scp sftp ssh

	# Colorize git branch and current directory in the command prompt
	export PS1="\[$(tput bold)\]\[\033[31m\]→ \[\033[0m\]\[\033[105m\]\$(parse-git-branch)\[\033[0m\]\[$(tput bold)\]\[\033[36m\] \W\[\033[0m\] \[\033[2m\]$\[\033[0m\] "

	# Change the title of the Bash terminal to show the User@Hostname connection
	PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}\007"'
fi

# Hide the annoying Bash/Zsh deprecation warning
export BASH_SILENCE_DEPRECATION_WARNING=1

# Automatically trim long paths in the prompt (requires Bash 4.x)
PROMPT_DIRTRIM=2

# Prefer US English and use UTF-8
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

# Enable some Bash 4 features when possible:
shopt -s autocd globstar 2>/dev/null

# Make VS Code the default editor
export EDITOR='code'

# Don't prompt for merge_msg in Git
export GIT_MERGE_AUTOEDIT=no

# Add constants
if [ -f "$HOME/.dotfiles/bash/constants.sh" ]; then
	source "$HOME/.dotfiles/bash/constants.sh"
fi

# Add aliases
if [ -f "$HOME/.dotfiles/bash/aliases.sh" ]; then
	source "$HOME/.dotfiles/bash/aliases.sh"
fi

# Add functions
if [ -f "$HOME/.dotfiles/bash/functions.sh" ]; then
	source "$HOME/.dotfiles/bash/functions.sh"
fi

# Show a random quote at Bash startup. : )
if [[ $- == *i* ]] && [ -x "$(command -v gshuf)" ]; then # Only show the quote for interactive shells
	gshuf -n 1 "$HOME/.dotfiles/bash/quotes.txt"
fi
