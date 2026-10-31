{
  description = "fn3x config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    clipboard-sync = {
      url = "github:fn3x/clipboard-sync";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpwcenter = {
      url = "github:hyprwm/hyprpwcenter";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cachy-proton = {
      url = "github:jackgrahn/cachy-proton-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vicinae = {
      url = "github:vicinaehq/vicinae";
    };
    sneemok = {
      url = "git+https://codeberg.org/fn3x/sneemok.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix";
    };
    noctalia-qs = {
      url = "github:noctalia-dev/noctalia-qs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    shadps4 = {
      url = "git+https://codeberg.org/fn3x/shadps4.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    odysseus = {
      url = "github:pewdiepie-archdaemon/odysseus/pull/2568/head";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helium = {
      url = "github:schembriaiden/helium-browser-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xwaylandvideobridge = {
      url = "git+https://invent.kde.org/system/xwaylandvideobridge.git";
    };
    spotifast = {
      url = "github:crmne/spotifast";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      mkHost =
        {
          hostname,
          users,
          extraModules ? [ ],
          hmModules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/${hostname}/configuration.nix
            home-manager.nixosModules.home-manager
            {
              nixpkgs.overlays = [ self.overlays.default ];
              home-manager = {
                extraSpecialArgs = { inherit inputs outputs; };
                sharedModules = [ inputs.nixvim.homeModules.nixvim ] ++ hmModules;
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "bak";
                inherit users;
              };
            }
          ]
          ++ extraModules;
        };
    in
    {
      overlays.default = final: _prev: import ./pkgs { pkgs = final; };

      packages.${system} = import ./pkgs { inherit pkgs; };

      formatter.${system} = pkgs.nixfmt-tree;

      nixosConfigurations = {
        desktop = mkHost {
          hostname = "desktop";
          users.fn3x = import ./hosts/desktop/home.nix;
          extraModules = [
            { nixpkgs.overlays = [ inputs.niri.overlays.niri ]; }
          ];
          hmModules = [
            inputs.vicinae.homeManagerModules.default
            inputs.sneemok.homeManagerModules.default
            inputs.caelestia-shell.homeManagerModules.default
            inputs.dms.homeModules.dank-material-shell
            inputs.niri.homeModules.niri
            inputs.noctalia.homeModules.default
          ];
        };

        laptop = mkHost {
          hostname = "laptop";
          users.fn3x = import ./hosts/laptop/home.nix;
          extraModules = [ inputs.clipboard-sync.nixosModules.default ];
          hmModules = [
            inputs.vicinae.homeManagerModules.default
            inputs.sneemok.homeManagerModules.default
            inputs.caelestia-shell.homeManagerModules.default
            inputs.noctalia.homeModules.default
          ];
        };
      };
    };
}
