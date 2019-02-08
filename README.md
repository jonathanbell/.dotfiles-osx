# Mac OS X .dotfiles

<!-- TOC depthFrom:2 orderedList:false -->

- [Setup a Mac with Mojave](#setup-a-mac-with-mojave)
  - [Optional: Extra stuff to do](#optional-extra-stuff-to-do)
    - [Cloudinary](#cloudinary)

<!-- /TOC -->

These are my installation and configuration files for the Mac OS X operating system. Fork if you wish but keep in mind that a lot of these settings are personalized to me (so you will most likely want to change them before using the scripts). Review the code, and remove things you don't want or need. Do not blindly use these settings.

Inspired by: <https://dotfiles.github.io/> and <https://github.com/jayharris/dotfiles-windows>

## Setup a Mac with Mojave

1. Install Mojave
2. [Install Veracrypt](https://www.veracrypt.fr/en/Downloads.html) manually
3. [Install Dropbox](https://www.dropbox.com/install) manually
4. [Install MovesLink](http://www.movescount.com/connect/download?type=moveslink) manually
5. Clone this repo: `cd ~ && git clone git@github.com:jonathanbell/.dotfiles-osx.git .dotfiles` Notice that we ensure we clone this repo down as `.dotfiles`. This will ensure paths are correct in the installation scripts.

Now, run the `new-computer.sh` script.

```bash
chmod +x new-computer.sh
./new-computer.sh
```

This will:

1. Symlink the `.bashrc` and `.bash_profile` files to your home directory.
2. Instal a shwack of software on your machine that I like to use.
3. Configure your machine for web development use.

---

### Optional: Extra stuff to do

1. Setup VS Code by [syncing your settings](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync) from the cloud.

#### Cloudinary

1.  Copy your Cloudinary config file from your secret hiding place to `~/.cloudinary`

You can now [upload images to Cloudinary](https://www.npmjs.com/package/cloudinary-cli#upload) with `cloudinary upload foo.png`
