{
pkgs,
lib,
config,
inputs,
...
}:
{
  options = {
    steam.enable = lib.mkEnableOption "enables steam";
  };

  config = lib.mkIf config.steam.enable {
    environment.systemPackages = with pkgs; [
      protonup-qt
    ];
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      extest.enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
        inputs.cachy-proton.packages.${pkgs.stdenv.hostPlatform.system}.proton-cachyos-v3
        inputs.cachy-proton.packages.${pkgs.stdenv.hostPlatform.system}.proton-cachyos-v4
     ];
    };
    programs.gamemode.enable = true;
  };
}
