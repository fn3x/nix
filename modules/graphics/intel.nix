{
  config,
  pkgs,
  lib,
  ...
}:
{
  options = {
    intel.enable = lib.mkEnableOption "Enables intel graphics drivers";
  };

  config = lib.mkIf config.intel.enable {
    hardware.cpu.intel.updateMicrocode = true;

    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-compute-runtime
        vpl-gpu-rt
      ];
      extraPackages32 = with pkgs; [
        driversi686Linux.intel-media-driver
      ];
    };

    environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";

    services.libinput.enable = true;
  };
}
