# Dotfiles

Managed via [Nix-Darwin](https://github.com/LnL7/nix-darwin), [Home-Manager](https://github.com/nix-community/home-manager),
and build using [Mk-Darwin-System](https://github.com/vic/mk-darwin-system//).

## Installation

**Warning:** If you want to give these dotfiles a try, you should first fork this repository, review the code, and remove things you don’t want or need. Don’t blindly use my settings unless you know what that entails.

## Install
### MacOS
Install XCode CLT (not required, but recommended)
```sh
xcode-select --install
```

Clone the repo
```sh
git clone --depth 1 https://github.com/shaunsingh/vimrc-dotfiles.git ~/vimrc-dotfiles && cd vimrc-dotfiles
```

Install nix (unstable), Enable flakes and nix-commands, and run the dotfiles
```zsh
λ cat /etc/nix/nix.conf
# WARNING: this file is generated from the nix.* options in
# your NixOS configuration, typically
# /etc/nixos/configuration.nix.  Do not edit it!

max-jobs = auto
cores = 0
sandbox = false

substituters = https://cache.nixos.org/
trusted-substituters =
trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=
require-sigs = true
trusted-users = root
allowed-users = *
system = aarch64-darwin
extra-platforms = aarch64-darwin x86_64-darwin
experimental-features = nix-command flakes
build-users-group = nixbld

λ nix run github:shaunsingh/vimrc-dotfiles --impure
```

Currently I don't know how to do symlinks with nix, so you will have to do them manually: 
```
ln -s ~/nix-darwin-dotfiles/configs/spacebar/ ~/.config/spacebar
ln -s ~/nix-darwin-dotfiles/configs/nvim/ ~/.config/nvim
ln -s ~/nix-darwin-dotfiles/configs/doom/ ~/.config/doom
```

### Emacs
**Personal Note:** this is my configuration for emacs-ng
```     
git clone --depth 1 https://github.com/emacs-ng/emacs-ng.git
cd emacs-ng
./autogen.sh
./configure CFLAGS="-Wl,-rpath,shared,--disable-new-dtags -g -O3 -mtune=native -march=native -fomit-frame-pointer" \
            --prefix=/usr/local/ \
            --with-json --with-modules --with-compress-install \
            --with-threads --with-included-regex --with-zlib --with-libsystemd \
            --with-rsvg --with-native-compilation --with-webrender --without-javascript \
            --without-sound --without-imagemagick --without-makeinfo --without-gpm --without-dbus \
            --without-pop --without-toolkit-scroll-bars --without-mailutils --without-gsettings \
            --with-all 
make -j$(($(nproc) * 2)) NATIVE_FULL_AOT=1
make install-strip
```

If you want to force recompile the literate configuration, you can run
```zsh
doom sync -u
```

If you want to update the doom configuration, you can run
```zsh
doom upgrade
```

If you modify your shell configuration, run `doom env` to regenerate env vars

#### Mu4e and Gmail
Email will have a few issues, since its hardcoded to my account and my machines path. Do the following steps to get email up and running for you

1. modify `~/.mbsyncrc` to include your email and password
2. replace instances of my name and email in `~/.doom.d/config.org`
3. replace the path to `msmtp` in `~/.doom.d/config.org` if you have an intel mac
4. Rerun the following commands, replace the example with your email:

```zsh
mu init --maildir=~/.mbsync --my-address=email@example.org
mu index
mbsync --all
```

Indexed mail will go under `~/.mbsync/`, you can either manually mbsync or use emacs to update mail

#### Org Mode
My org mode config includes two additional plugins, org-agenda and org-roam.
Both these plugins need a set directory. All org files can go under the created `~/org` dir. Roam files go under `~/org/roam`

## Additional Configurations
### Fonts
My config uses 3 fonts not installed by default. My nix config should
handle installing the proportional fonts. SFMono must be installed seperately

Required:
1. Fira SFMono Nerd Font (https://github.com/shaunsingh/SFMono-Nerd-Font-Ligaturized)

Required for emacs
1. Overpass
2. Alegreya

### Neovim
My neovim configuration is designed for programming and quick text editing. As such, it opens in under 10ms.

Upon starting Neovim, packer should automatically install and sync. In case this step fails, or you want to update plugins, you can run `:PackerSync`

The plugins will install. After restarting neovim, nvim-treesitter should install and configure parsers. Afterwards. run `:checkhealth` to check for possible issues.

If you modify the configuration files for certain plugins, you may have to run `:PackerSync` to apply changes

If you want to take advantage of the LSP, you can install language servers using the following command:

`:LspInstall (language)` e.g. `:LspInstall java` to install the java LSP (jdtls)

Similarly for treesitter, do 
`:TSInstall (language)` e.g. `:TSInstall java` to install the java treesitter parser

I also recommend installing [Neovide](https://github.com/Kethku/neovide) or [goneovim](https://github.com/akiyosi/goneovim) if you prefer a gui experience. 

## Feedback

Suggestions/improvements
[welcome](https://github.com/shaunsingh/vimrc-dotfiles/issues)!
