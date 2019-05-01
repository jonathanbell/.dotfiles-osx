# Edit hosts file
alias hosts='sudo nano /etc/hosts'

# Config Apache
alias configapache='sudo nano /etc/apache2/httpd.conf && restartapache'
alias restartapache='sudo apachectl restart'
alias testapache='apachectl configtest'
alias accesslog='sudo tail /private/var/log/apache2/access_log'
alias errorlog='sudo tail /private/var/log/apache2/error_log'
alias configvhosts='sudo nano /private/etc/apache2/extra/httpd-vhosts.conf'

# PHP
alias configphp='sudo nano /usr/local/etc/php/7.3/php.ini'

# MySQL
alias restartmysql='brew services restart mysql'

# Change directories to handy OS X places
alias desk='cd ~/Desktop'
# Dropbox directory. : )
alias d='cd ~/Dropbox'
# Sites folder
alias s='cd ~/Dropbox/Sites'
# Change directory to your dotfiles directory.
alias dot='cd ~/.dotfiles'

# Mount Buckups drive
alias mountbuckups='sudo mount -wt msdos /dev/disk2s1 /mnt/Buckups'
alias unmountbuckups='sudo diskutil unmount /dev/disk2s1'
alias mountbuckupsreadable='unmountbuckups && mountbuckups'

# Open your notes in code editor.
alias notes='cd ~/Dropbox/Notes && code .'

# Quickly clear the Terminal window
alias c='clear'

# For when you make that typ-o that you *will* make.
alias cd..='cd ..'
alias ..='cd ..'

# Add a WTFP Licence to a directory/project.
alias addwtfpl='wget -O LICENCE http://www.wtfpl.net/txt/copying/'

# Correct SSH permissions
alias correctsshpermissions="sudo chmod 700 ~/.ssh && sudo chmod -R 600 $(dirname $sshconfigpath)/*"

# Pretty print Git's history
alias gitlog='git log --graph --oneline --all --decorate'

# Work in progress commit
alias wip='git add . && git commit -am "WIP"'

# List all globally installed NPM packages
alias globalnpmpackages='npm list -g --depth 0'
