{
  description = "Shaurya's Nix Environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    neovim.url = "github:neovim/neovim?dir=contrib";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    spacebar.url = "github:cmacrae/spacebar";
    mk-darwin-system = {
      url = "github:vic/mk-darwin-system/main";
    };
  };

  outputs = { self, nixpkgs, emacs-overlay, spacebar, neovim, ... }@inputs: 
    let
      flake-utils = mk-darwin-system.inputs.flake-utils;
      hostName = "shaunsingh-laptop";
      systems = [ "aarch64-darwin" ];

    in flake-utils.lib.eachSystem systems (system:
      mk-darwin-system.mkDarwinSystem {
        inherit hostName system;
        nixosModules = [
          ./modules/emacs.nix
          ./modules/homebrew.nix
          ./modules/git.nix
          ./modules/pam.nix
          ({ pkgs, ... }: {
            system.stateVersion = 4;

            system.keyboard = {
              enableKeyMapping = true;
              remapCapsLockToEscape = true;
            };

            system.defaults = {
              screencapture = {
                  location = "/tmp";
              };
              dock = {
                autohide = true;
                showhidden = true;
                mru-spaces = false;
              };
              finder = {
                AppleShowAllExtensions = true;
                QuitMenuItem = true;
                FXEnableExtensionChangeWarning = true;
              };
              NSGlobalDomain = {
                AppleInterfaceStyle = "Dark";
                AppleKeyboardUIMode = 3;
                ApplePressAndHoldEnabled = false;
                AppleFontSmoothing = 1;
                _HIHideMenuBar = true;
                InitialKeyRepeat = 10;
                KeyRepeat = 1;
                "com.apple.mouse.tapBehavior" = 1;
                "com.apple.swipescrolldirection" = true;
              } 
            };

            security.pam.enableSudoTouchIdAuth = true;

            programs.fish.enable = true;
            environment.shells = with pkgs; [ fish ];
            users.users."${username}" = {
              inherit home;
              shell = pkgs.fish;
            };
            system.activationScripts.postActivation.text = ''
              # Set the default shell as fish for the user
              sudo chsh -s ${lib.getBin pkgs.fish}/bin/fish ${username}
            '';

            services.nix-daemon.enable = true;
            nix.package = pkgs.nixUnstable;

            services.spacebar.enable = true;
            programs.tmux.enable = true;
          
            programs.git = {
              enable = true;
              userName = "shaunsingh";
              userEmail = "shaunsingh0207@gmail.com";
            };
          
            nixpkgs = {
              overlays = [
                emacs-overlay.overlay
                neovim.overlay
                spacebar.overlay
              ];
              config.allowUnfree = true;
            };

            nix = {
              package = pkgs.nixUnstable;
              extraOptions = ''
                system = aarch64-darwin
                extra-platforms = aarch64-darwin x86_64-darwin
                experimental-features = nix-command flakes
                build-users-group = nixbld
              '';
            };

            users.users.shauryasingh.home = "/Users/shauryasingh";

            fonts = {
              enableFontDir = true;
              fonts = with pkgs; [
                overpass
                alegreya
              ];
            };

            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.shauryasingh.home.packages = with pkgs; [
                # Dotfiles Management
                yadm
              
                # Utils
                wget
                git-lfs
                ripgrep
                exa
                bat
                tree
                fd
            
                ## tmux
              
                # Mail
                ## offlineimap
                mu
                msmtp
                isync
              
                # Browsers
                ## firefox
                ## nyxt
                ## qutebrowser

                neovim
              
                # Emacs config deps (latex, aspell)
                (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))
                (pkgs.texlive.combine { inherit (pkgs.texlive) scheme-small dvipng dvisvgm l3packages xcolor soul adjustbox collectbox amsmath siunitx cancel mathalpha capt-of chemfig wrapfig mhchem fvextra latexmk; })
                sdcv
                gnuplot
              
                # Chat
                discocss
              ];
            };
          })
        ];

        flakeOutputs = { pkgs, ... }@outputs:
          outputs // (with pkgs; { packages = { inherit hello; }; });
     });
}
