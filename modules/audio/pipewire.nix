{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    pipewire.enable = lib.mkEnableOption "Enables pipewire";
  };

  config = lib.mkIf config.pipewire.enable {
    environment.systemPackages = with pkgs; [
      qpwgraph
      pipewire.jack
      neural-amp-modeler-lv2
      lsp-plugins
    ];

    # Enable sound with pipewire.
    services.pulseaudio.enable = false;

    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      wireplumber.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

      # Global low-latency defaults
      extraConfig.pipewire."92-low-latency" = {
        "context.properties" = {
          "default.clock.rate" = 48000;       # Fixed rate avoids resampling latency
          "default.clock.quantum" = 128;      # ~5ms latency at 48kHz
          "default.clock.min-quantum" = 32;   # Allows top-tier interfaces to achieve ~1.5ms
          "default.clock.max-quantum" = 512;
        };
      };

      wireplumber.extraConfig."99-disable-suspend" = {
        "monitor.alsa.rules" = [{
          matches = [
            { "node.name" = "~alsa_input.*"; }
            { "node.name" = "~alsa_output.*"; }
          ];
          actions = {
            update-props = {
              "session.suspend-timeout-seconds" = 0;
              # Optional: Tweak by trial-and-error if crackling occurs on specific USB interfaces.
              # Do not apply globally without testing, as it may break built-in audio.
              # "api.alsa.period-size" = 2;
              # "api.alsa.headroom" = 8192;
            };
          };
        }];
      };
    };
  };
}
