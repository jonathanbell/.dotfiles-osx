# Mac OS X .dotfiles

These are my installation and configuration files for the Mac OS X operating
system. Fork if you wish but keep in mind that a lot of these settings are
personalized to me (so you will most likely want to change them before using the
scripts). Review the code, and remove things you don't want or need. Do not
blindly use these settings.

Inspired by: <https://dotfiles.github.io/> and
<https://github.com/jayharris/dotfiles-windows>

## Setup a new Mac

1. Install and config the Mac OS
1. Sign in to your Apple ID
1. Open Launchpad and delete things like iMovie and Garbage Band by holding down on the icons until the wiggle
1. From the App Store install: [DaVinci Resolve](https://apps.apple.com/my/app/davinci-resolve/id571213070?mt=12)
1. [Install Dropbox](https://www.dropbox.com/install) manually
1. Use Bash as the default for Terminal: `chsh -s /bin/bash` (close and re-open Terminal)
1. Install command line tools: `xcode-select --install`
1. Clone this repo: `cd ~ && git clone
   https://github.com/jonathanbell/.dotfiles-osx.git .dotfiles` Notice that we
   ensure we clone this repo down as `.dotfiles`. This will ensure paths are
   correct in the installation scripts.
1. Clone any "company" dotfiles from GitHub to your home directory (example):
   `cd ~ && git clone https://github.com/jonathanbell/.dotfiles-<companyname>.git`
1. [Install the Dracula theme for Terminal](https://draculatheme.com/terminal/)
   (use the `bash/Dracula.terminal` file. Press `command + shift + .` in order
   to see hidden files)
     1. Now, configure your default Terminal profile

Now, run the `new-computer.sh` script. Have the full path to your SSH config
file handy (from DB).

```bash
cd ~/.dotfiles
chmod +x new-computer.sh
./new-computer.sh
```

This will:

1. Symlink the `.bash_profile` file to your home directory.
2. Instal a shwack of software on your machine that I like to use.
3. Configure your machine for web development use + photography use.

Close and re-open Bash after this script has run.

And now, finally:

1. Sign in to Chrome
1. Install these Adobe Creative Cloud apps manually:
    - Photoshop (+ Bridge)
    - Lightroom
1. Install [Topaz DeNoise](https://topazlabs.com/downloads/) manually
1. Install [SuuntoLink](https://www.suunto.com/Support/software-support/suuntolink/)
   manually

---

### Optional: Extra stuff to do

1. [Install Docker manually](https://docs.docker.com/docker-for-mac/install/)
1. Setup VS Code by [syncing your
   settings](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync)
   from the cloud
1.  Copy your Cloudinary config file from your secret hiding place to
    `~/.cloudinary`
    - You'll then be able to [upload images to
      Cloudinary](https://www.npmjs.com/package/cloudinary-cli#upload) with
      `cloudinary upload foo.png`
1.  Setup personal and professional AWS keys
