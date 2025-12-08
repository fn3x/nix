{
lib,
config,
pkgs,
...
}:
{
  options = {
    fish.enable = lib.mkEnableOption "enables fish";
  };

  config = lib.mkIf config.fish.enable {
    programs.fish = {
      enable = true;

      plugins = [
        {
          name = "tide";
          src = pkgs.fetchFromGitHub {
            owner = "IlanCosman";
            repo = "tide";
            rev = "fcda500d2c2996e25456fb46cd1a5532b3157b16";
            hash = "sha256-dzYEYC1bYP0rWpmz0fmBFwskxWYuKBMTssMELXXz5H0=";
          };
        }
      ];
    };
  };
}
