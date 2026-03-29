{
  config,
  lib,
  ...
}:
{
  options = {
    pipewire.enable = lib.mkEnableOption "Enables pipewire";
  };

  config = lib.mkIf config.pipewire.enable {
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
    };
  };
}
