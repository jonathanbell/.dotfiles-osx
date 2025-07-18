# Displays current Git branch, if there is one
parse-git-branch() {
  git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/  [\1] /'
}

# Add `~/bin` to your `$PATH`
export PATH="$HOME/bin:$PATH"

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

  # Autocorrect typos in path names when using `cd`
  shopt -s cdspell

  # Colorize 'grep'
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

  # Colors to differentiate various file types with `ls`
  export LS_COLORS="no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:"

  # Change the title of the Bash terminal to show the User@Hostname connection.
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

# Don't prompt for merge_msg in Git.
export GIT_MERGE_AUTOEDIT=no

# Add aliases
if [ -f "$HOME/.dotfiles/bash/aliases.sh" ]; then
  source "$HOME/.dotfiles/bash/aliases.sh"
fi

# Add functions
if [ -f "$HOME/.dotfiles/bash/functions.sh" ]; then
  source "$HOME/.dotfiles/bash/functions.sh"
fi

# Show a random quote at Bash startup. : )
if [[ $- == *i* ]] && [ -x "$(command -v gshuf)" ]; then # Only show the quote for interactive shells.
  gshuf -n 1 "$HOME/.dotfiles/bash/quotes.txt"
fi
