# Mac OS X .dotfiles

These are my installation and configuration files for the Mac OS X operating
system. Fork them if you wish but keep in mind that a lot of these settings are
personalized to me (so you will most likely want to change them before using the
scripts). Review the code, and remove things you don't want or need. Do not
blindly use these settings.

Inspired by: <https://dotfiles.github.io/> and
<https://github.com/jayharris/dotfiles-windows>

## Setup a new Mac

1. Install the base Mac OS
1. Sign in to your Apple ID
1. Open Launchpad and delete things like Garbage Band by holding down on the icons until they wiggle
1. [Install Dropbox](https://www.dropbox.com/install) manually
1. Use Bash as the default for Terminal: `chsh -s /bin/bash` (close and re-open Terminal)
1. Install command line tools: `xcode-select --install`
1. Clone this repo: `cd ~ && git clone
   https://github.com/jonathanbell/.dotfiles-osx.git .dotfiles` Notice that we
   ensure we clone this repo down as `.dotfiles`. This will ensure paths are
   correct in the installation scripts.
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
2. Install a **shwack** of software on your machine.
3. Configure your machine for development + photography use.

Close and re-open Bash after this script has run.

And now, finally:

1. Sign in to Chrome
1. Install [these](https://creativecloud.adobe.com/apps/all/desktop/pdp/photoshop) Adobe Creative Cloud apps manually:
    - Photoshop (+ Bridge)
    - Lightroom
1. Install [Topaz DeNoise](https://topazlabs.com/downloads/) manually
1. Change your Terminal font to Fantasque Sans Mono Nerd Font

---

### Optional: Extra stuff to do

1. Setup VS Code and sync your settings (by signing in via GitHub)
