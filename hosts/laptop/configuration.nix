{ pkgs, inputs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
    ../../modules/graphics
    ../../modules/audio
  ];

  intel.enable = true;
  pipewire.enable = true;

  networking.hostName = "laptop";

  services.xserver.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.fwupd.enable = true;

  programs.ssh.startAgent = true;

  users.users.fn3x.extraGroups = [ "docker" ];

  environment.systemPackages = with pkgs; [
    zsh
    cl
    kdePackages.kirigami
    kdePackages.kirigami-addons
  ];

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    konsole
    oxygen
  ];

  # Security
  services.fail2ban.enable = true;
  services.openssh.enable = true;

  services.clipboard-sync.enable = true;

  networking.wireguard.enable = true;
  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ 51820 ];
    logReversePathDrops = true;

    extraCommands = ''
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
    '';
    extraStopCommands = ''
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
    '';
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "24.11"; # Did you read the comment?

  # programs.hyprland already adds xdg-desktop-portal-hyprland
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${system}.hyprland;
    portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024;
    }
  ];

  hardware.trackpoint.enable = true;
  hardware.trackpoint.emulateWheel = true;

  services.thermald.enable = true;
  services.power-profiles-daemon.enable = false;

  powerManagement.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      INTEL_GPU_MIN_FREQ_ON_AC = 500;
      INTEL_GPU_MIN_FREQ_ON_BAT = 500;
      INTEL_GPU_MAX_FREQ_ON_AC = 1100;
      INTEL_GPU_MAX_FREQ_ON_BAT = 800;
      INTEL_GPU_BOOST_FREQ_ON_AC = 1100;
      INTEL_GPU_BOOST_FREQ_ON_BAT = 800;
    };
  };

  services.fstrim.enable = true;
  services.fprintd.enable = true;
  services.illum.enable = true;
}
