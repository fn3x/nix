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
      extraConfig.pipewire."99-virtualmic" = {
        "context.objects" = [
          {
            factory = "adapter";
            args = {
              "factory.name" = "support.null-audio-sink";
              "node.name" = "VirtualMic";
              "node.description" = "VirtualMic";
              "media.class" = "Audio/Sink";
              "audio.position" = "FL,FR";
            };
          }
        ];
      };
    };
  };
}
