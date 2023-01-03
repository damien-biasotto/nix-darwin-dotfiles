{
  description = "Shaurya's Nix Environment";

  inputs = {
    # All packages should follow latest nixpkgs/nur
    unstable.url = "github:nixos/nixpkgs/master";
    nur.url = "github:nix-community/NUR";
    # Nix-Darwin
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "unstable";
    };
    # HM-manager for dotfile/user management
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unstable";
    };
    # Asahi linux
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "unstable";
    };
    sway-src = {
      url = "github:swaywm/sway";
      flake = false;
    };
    m1n1-src = {
      url = "github:AsahiLinux/m1n1";
      flake = false;
    };
    u-boot-src = {
      url = "github:AsahiLinux/u-boot";
      flake = false;
    };
    asahi-fwextract-src = {
      url = "github:AsahiLinux/asahi-installer";
      flake = false;
    };
    mesa-src = {
      url = "git+https://gitlab.freedesktop.org/asahi/mesa.git";
      flake = false;
    };
    # bar
    sketchybar-src = {
      url = "github:FelixKratz/SketchyBar";
      flake = false;
    };
    # Window Management
    yabai-src = {
      url = "github:FelixKratz/yabai";
      flake = false;
    };
    # SFMono w/ patches
    sf-mono-liga-src = {
      url = "github:shaunsingh/SFMono-Nerd-Font-Ligaturized";
      flake = false;
    };
    # Terminal emulator
    alacritty-src = {
      url = "github:fee1-dead/alacritty/ligatures_harfbuzz";
      flake = false;
    };
    # Themeing
    base16 = {
      url = "github:shaunsingh/base16.nix";
      inputs.nixpkgs.follows = "unstable";
    };
    # IBM-Carbon-Theme (see IBM-design: colors)
    base16-oxocarbon = {
      url = "github:nyoom-engineering/base16-oxocarbon";
      flake = false;
    };
    # Neovim Nightly
    neovim-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "unstable";
    };
    # Rust Nightly
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "unstable";
    };
    # Firefox for darwin
    firefox-overlay = {
      url = "github:bandithedoge/nixpkgs-firefox-darwin";
      inputs.nixpkgs.follows = "unstable";
    };
    # nyxt
    nyxt-src = {
      url = "github:atlas-engineer/nyxt";
      flake = false;
    };
    ndebug-src = {
      url = "github:atlas-engineer/ndebug";
      flake = false;
    };
    nsymbols-src = {
      url = "github:atlas-engineer/nsymbols";
      flake = false;
    };
    lisp-unit2-src = {
      url = "github:AccelerationNet/lisp-unit2";
      flake = false;
    };
    ospm-src = {
      url = "github:atlas-engineer/ospm";
      flake = false;
    };
  };
  outputs = { self, nixpkgs, darwin, home-manager, ... }@inputs: {
    nixosConfigurations.shaunsingh-laptop = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/mbp-m1-linux
        home-manager.nixosModule
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
              inherit (inputs)
                base16-oxocarbon;
            };
            users.shauryasingh = {
              imports = [
                inputs.base16.hmModule
                ./modules/home.nix
                ./modules/theme.nix
                ./modules/sway.nix
                ./modules/foot.nix
                # ./modules/nyxt.nix
              ];
            };
          };
        }
      ];
    };
    darwinConfigurations.shaunsingh-laptop = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/mbp-m1-darwin
        home-manager.darwinModule
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
              inherit (inputs)
                base16-oxocarbon;
            };
            users.shauryasingh = {
              imports = [
                inputs.base16.hmModule
                ./modules/home.nix
                ./modules/firefox.nix
                ./modules/theme.nix
                ./modules/alacritty.nix
                ./modules/discord.nix
              ];
            };
          };
        }
      ];
    };
  };
}
