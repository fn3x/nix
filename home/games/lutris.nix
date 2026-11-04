{
pkgs,
lib,
config,
...
}:
{
  options = {
    lutris.enable = lib.mkEnableOption "enables lutris";
  };

  config = lib.mkIf config.lutris.enable {
    home.packages = with pkgs; [
    (lutris.override {
      extraPkgs = pkgs: with pkgs; [
        winetricks
        wineWow64Packages.staging
        cabextract
      ];
    })
    ];

    # lutris installers ignore system_winetricks and use the bundled (outdated) runtime copy
    home.file.".local/share/lutris/runtime/winetricks/winetricks" = {
      source = lib.getExe pkgs.winetricks;
      force = true;
    };
  };
}
