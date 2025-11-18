{
lib,
config,
pkgs,
inputs,
...
}:
{
  options = {
    river.enable = lib.mkEnableOption "enables river";
  };

  config = lib.mkIf config.river.enable {
    wayland.windowManager.river = {
      enable = true;
      xwayland.enable = true;
      systemd.enable = true;
      settings = {
        border-width = 1;
        declare-mode = [
          "locked"
          "normal"
          "passthrough"
        ];
        input = {
          pointer = {
            accel-profile = "flat";
            events = true;
            pointer-accel = 0;
            tap = false;
          };
        };
        map = {
          normal = {
            "Mod1 F" = "toggle-fullscreen";
            "Mod1 V" = "toggle-float";
            "Mod1 Space" = "${inputs.vicinae.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/vicinae toggle";

            "Mod1+Shift Q" = "close";
            "Mod1 1" = "set-focused-tags 1";
            "Mod1 2" = "set-focused-tags 2";
            "Mod1 3" = "set-focused-tags 3";
            "Mod1 4" = "set-focused-tags 4";
            "Mod1 5" = "set-focused-tags 5";
            "Mod1 6" = "set-focused-tags 6";
            "Mod1 7" = "set-focused-tags 7";
            "Mod1 8" = "set-focused-tags 8";
            "Mod1 9" = "set-focused-tags 9";
            "Mod1 0" = "set-focused-tags 0";

            "Mod1+Shift 1" = "set-view-tags 1";
            "Mod1+Shift 2" = "set-view-tags 2";
            "Mod1+Shift 3" = "set-view-tags 3";
            "Mod1+Shift 4" = "set-view-tags 4";
            "Mod1+Shift 5" = "set-view-tags 5";
            "Mod1+Shift 6" = "set-view-tags 6";
            "Mod1+Shift 7" = "set-view-tags 7";
            "Mod1+Shift 8" = "set-view-tags 8";
            "Mod1+Shift 9" = "set-view-tags 9";
            "Mod1+Shift 0" = "set-view-tags 0";
          };
        };
        set-repeat = "50 300";
        spawn = [
          "${pkgs.brave}/bin/brave"
          "${inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/ghostty"
        ];
      };
    };
  };
}
