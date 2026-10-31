{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    nvidia.enable = lib.mkEnableOption "Enables nvidia drivers";
  };

  config = lib.mkIf config.nvidia.enable {
    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          nvidia-vaapi-driver
        ];
      };

      nvidia = {
        modesetting.enable = true;

        # Saves VRAM to /tmp on suspend; enable if you see corruption after resume.
        powerManagement.enable = false;
        powerManagement.finegrained = false;

        # NVIDIA's open kernel module is the recommended one for Turing and newer
        # (RTX 3060 here) since driver 560.
        open = true;

        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };
    };

    environment.sessionVariables = {
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      __GL_VRR_ALLOWED = "0";
      LIBVA_DRIVER_NAME = "nvidia";
      NVD_BACKEND = "direct";
    };

    boot.kernelModules = [ "nvidia" "nvidia_drm" "nvidia_modeset" ];
  };
}
