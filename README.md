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
1. Setup trackpad and gestures (there isn't a public CLI API to change a lot of these settings)
1. Use Bash as the default for Terminal: `chsh -s /bin/bash` **(close and re-open Terminal)**
1. Go get your SSH keys from your secret hide-y place
1. Place your SSH keys and config into `~/.ssh`, then run: `sudo chmod 700 ~/.ssh && sudo chmod -R 600 ~/.ssh/*`
1. Download this repo/code and setup the `.dotfiles` directory:

```sh
rm -rf ~/.dotfiles && cd ~ && mkdir -p .dotfiles && curl -o dotfiles.zip https://github.com/jonathanbell/.dotfiles-osx/archive/refs/heads/main.zip -J -L && unzip dotfiles.zip && cd .dotfiles-osx-main && mv $(ls -A) ../.dotfiles/ && cd .. && rm -rf .dotfiles-osx-main && rm -rf dotfiles.zip
```

🎉 Now, run the `new-computer.sh` script:

```sh
cd ~/.dotfiles && chmod +x new-computer.sh && ./new-computer.sh
```

This will:

1. Symlink the `.bash_profile` file to your home directory.
2. Install a **shwack** of software on your machine.
3. Configure your machine for development + photography use.

Close and re-open Bash after this script has run.

### And now, finally

1. Sign in to Chrome
1. Make sure you are signed into iCloud
1. Install [Affinity](https://www.affinity.studio/get-affinity) manually
1. Install [Topaz DeNoise](https://topazlabs.com/downloads/) manually
1. Setup VS Code and sync your settings (by signing in via GitHub or Microsoft)
1. Install [Vivid](https://www.getvivid.app/) manually
