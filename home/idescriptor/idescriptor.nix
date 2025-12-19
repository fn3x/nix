{ config
, lib
, pkgs
, ...
}:
{
  options = {
    idescriptor.enable = lib.mkEnableOption "enables idescriptor";
  };

  config = lib.mkIf config.idescriptor.enable {
    home.packages = [ 
      (pkgs.callPackage ./idescriptor-drv.nix {})
    ];
  };
}
