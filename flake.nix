{
  description = "fn3x config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ghostty = {
      url = "github:ghostty-org/ghostty";
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
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixvim,
      impermanence,
      ...
    }@inputs:
    let
      inherit (self) outputs;
    in
    {
      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/desktop/configuration.nix
            impermanence.nixosModules.impermanence
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit inputs outputs; };
              home-manager.sharedModules = [ nixvim.homeManagerModules.nixvim ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.fn3x = import ./hosts/desktop/home.nix;
            }
          ];
        };
      };

      homeConfigurations = {
        "fn3x@desktop" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/desktop/home.nix ];
        };
      };
    };
}
