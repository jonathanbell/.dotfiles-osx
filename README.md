# Mac OS X .dotfiles

<!-- TOC depthFrom:2 orderedList:false -->

- [Setup a Mac with Catalina](#setup-a-mac-with-catalina)
  - [Optional: Extra stuff to do](#optional-extra-stuff-to-do)

<!-- /TOC -->

These are my installation and configuration files for the Mac OS X operating system. Fork if you wish but keep in mind that a lot of these settings are personalized to me (so you will most likely want to change them before using the scripts). Review the code, and remove things you don't want or need. Do not blindly use these settings.

Inspired by: <https://dotfiles.github.io/> and <https://github.com/jayharris/dotfiles-windows>

## Setup a Mac with Catalina

1. Install Catalina
1. Sign in to your Apple ID
1. From the App Store install: Workflowy, Trello, Evertool
1. [Install Veracrypt](https://www.veracrypt.fr/en/Downloads.html) manually
1. [Install Dropbox](https://www.dropbox.com/install) manually
1. [Install MovesLink](http://moveslink.static.movescount.com/mac/download.htm?_ga=2.58506541.663209658.1576552893-189153876.1576552893) manually
1. Install Adobe Creative Cloud manually
    - Photoshop
    - Lightroom
1. Install Capture One manually
1. Change the shell back to good old bash: `chsh -s /bin/bash` (then quit and re-open Terminal)
1. Install command line tools: `xcode-select --install`
1. Clone this repo: `cd ~ && git clone https://github.com/jonathanbell/.dotfiles-osx.git .dotfiles` Notice that we ensure we clone this repo down as `.dotfiles`. This will ensure paths are correct in the installation scripts.
1. Clone any "company" dotfiles from GitHub to your home directory (example): `cd ~ && git clone https://github.com/jonathanbell/.dotfiles-companyname.git`
1. [Install the Dracula theme for Terminal](https://draculatheme.com/terminal/) (use `bash/Dracula.terminal` and press `command + shift + .` in order to see hidden files)

Now, run the `new-computer.sh` script. Have the full path to your SSH config file handy (from DB).

```bash
chmod +x new-computer.sh
./new-computer.sh
```

This will:

1. Symlink the `.bashrc` and `.bash_profile` files to your home directory.
2. Instal a shwack of software on your machine that I like to use.
3. Configure your machine for web development use.

Close and re-open Bash after this script has run. 

---

### Optional: Extra stuff to do

1. [Install Docker manually](https://docs.docker.com/docker-for-mac/install/)
1. Setup VS Code by [syncing your settings](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync) from the cloud.
1. Setup PHPStorm by [syncing your settings](https://github.com/jonathanbell/phpstorm-settings) from GitHub.
1.  Copy your Cloudinary config file from your secret hiding place to `~/.cloudinary`
    - You'll then be able to [upload images to Cloudinary](https://www.npmjs.com/package/cloudinary-cli#upload) with `cloudinary upload foo.png`
1.  Setup personal and professional AWS keys
1. Update URL to the GitHub SSH URI inside `.git/config`
