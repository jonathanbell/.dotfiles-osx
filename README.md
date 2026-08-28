# macOS .dotfiles

These are my installation and configuration files for macOS. Fork them if you
wish but keep in mind that a lot of these settings are personalized to me (so
you will most likely want to change them before using the scripts). Review the
code, and remove things you don't want or need. Do not blindly use these
settings.

Inspired by: <https://dotfiles.github.io/> and
<https://github.com/jayharris/dotfiles-windows>

## Setup a new Mac

1. Install macOS
1. Sign in to your Apple ID
1. Setup trackpad and gestures (there isn't a public CLI API to change a lot of
   these settings)
1. Use Bash as the default for Terminal: `chsh -s /bin/bash` **(close and
   re-open Terminal)**. This is only the system Bash, needed to bootstrap.
   `new-computer.sh` switches over to Homebrew's Bash 5 at the end.
1. Go get your SSH keys from your secret hide-y place
1. Place your SSH keys and config into `~/.ssh`, then run:

   ```sh
   chmod 700 ~/.ssh && find ~/.ssh -type d -exec chmod 700 {} + && find ~/.ssh -type f -exec chmod 600 {} +
   ```

1. Clone the repo. Mind the directory name: the repo is called `.dotfiles-osx`
   but every script in here expects to find itself at `~/.dotfiles`.

   ```sh
   git clone git@github.com:jonathanbell/.dotfiles-osx.git ~/.dotfiles
   ```

1. Copy the environment template and fill in your secrets:

   ```sh
   cp ~/.dotfiles/bash/env.sh.example ~/.dotfiles/bash/env.sh
   ```

Now, run the `new-computer.sh` script:

```sh
cd ~/.dotfiles && chmod +x new-computer.sh && ./new-computer.sh
```

This will:

1. Symlink `.bash_profile` along with other configuration and scripts into place
1. Install a **shwack** of software on your machine
1. Configure your machine for development + photography use

Close and re-open Bash after this script has run.

### And now, finally

1. Sign in to Chrome
1. Make sure you are signed into iCloud
1. Set the Kitty theme with `kitten themes Dracula`. This generates the
   `current-theme.conf` that `kitty.conf` includes, which is not checked in.
1. Install [Affinity](https://www.affinity.studio/get-affinity) manually
1. Install [Topaz DeNoise](https://topazlabs.com/downloads/) manually
1. Setup VS Code and sync your settings (by signing in via GitHub or Microsoft)
1. Install [Vivid](https://www.getvivid.app/) manually
