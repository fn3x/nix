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
      # If using a stable channel you can use `url = "github:nix-community/nixvim/nixos-<version>"`
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-qtutils.url = "github:hyprwm/hyprland-qtutils";
    mcmojave-hyprcursor.url = "github:libadoxon/mcmojave-hyprcursor";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    impermanence.url = "github:nix-community/impermanence";
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    apple-fonts.url = "github:fn3x/apple-fonts.nix";
    clipboard-sync.url = "github:fn3x/clipboard-sync";
    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cachy-proton.url = "github:jackgrahn/cachy-proton-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixvim,
      impermanence,
      clipboard-sync,
      stylix,
      ...
    }@inputs:
    let
      inherit (self) outputs;
    in
    {
      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          system = "x86_64-linux";
          modules = [
            stylix.nixosModules.stylix
            ./hosts/desktop/configuration.nix
            impermanence.nixosModules.impermanence
            clipboard-sync.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit inputs outputs; };
              home-manager.sharedModules = [ nixvim.homeModules.nixvim ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = ".bak";
              home-manager.users.fn3x = import ./hosts/desktop/home.nix;
            }
          ];
        };
        laptop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          system = "x86_64-linux";
          modules = [
            ./hosts/laptop/configuration.nix
            impermanence.nixosModules.impermanence
            clipboard-sync.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit inputs outputs; };
              home-manager.sharedModules = [ nixvim.homeModules.nixvim ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = ".bak";
              home-manager.users.fn3x = import ./hosts/laptop/home.nix;
              home-manager.users.whoispiria = import ./hosts/laptop/home-piria.nix;
            }
            inputs.stylix.nixosModules.stylix
          ];
        };
      };

      homeConfigurations = {
        "fn3x@desktop" = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/desktop/home.nix ];
        };
        "fn3x@laptop" = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/laptop/home.nix ];
        };
        "whoispiria@laptop" = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/laptop/home-piria.nix ];
        };
      };
    };
}
