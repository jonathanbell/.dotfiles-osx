# Mac OS X .dotfiles

My installation and configuration files for the Mac OS X operating system. Fork if you wish but keep in mind that a lot of these settings are personalized to me (so you will most likely want to change them before using the scripts). Review the code, and remove things you don't want or need. Do not blindly use these settings.

Inspired by: <https://dotfiles.github.io/> and <https://github.com/jayharris/dotfiles-windows>

1. Install Dropbox
2. Install Veracrypt

## Setup a Mac with Mojave

1. Install Mojave
1. [Install Dropbox](https://www.dropbox.com/install) manually
1. [Install MovesLink](http://www.movescount.com/connect/download?type=moveslink) manually
1. Clone this repo: ``

```bash
chmod +x new-computer.sh
./new-computer.sh
```

This will:

1. Symlink the `.bashrc` and `.bash_profile` files to your home directory.
2. Instal a shwack of software on your machine that Jonathan Bell likes to use.
