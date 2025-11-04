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

    boot.initrd.kernelModules = [ "xe" ];
    boot.kernelParams = [ "i915.force_probe=a7a1" ];

    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-vaapi-driver
        intel-ocl
        intel-media-driver
        intel-compute-runtime
        vpl-gpu-rt
        libvdpau-va-gl
      ];
      extraPackages32 = with pkgs; [
        driversi686Linux.intel-vaapi-driver
        driversi686Linux.intel-media-driver
      ];
    };

    services.libinput.enable = true;
    services.xserver.videoDrivers = [ "intel" ];
  };
}
