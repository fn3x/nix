# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/graphics/default.nix
    ../../modules/nixos/audio/default.nix
  ];

  intel.enable = true;
  pipewire.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "laptop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Yerevan";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  services.xserver.enable = true;

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.fwupd.enable = true;

  programs.ssh = {
    startAgent = true;
  };

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  users.users = {
    whoispiria = {
      isNormalUser = true;
      description = "Mari";
      extraGroups = [
        "networkmanager"
        "wheel"
        "audio"
        "video"
      ];
      shell = pkgs.nushell;
      password = "1";
    };
    fn3x = {
      isNormalUser = true;
      description = "Art";
      extraGroups = [
        "docker"
        "networkmanager"
        "wheel"
        "audio"
        "video"
      ];
      shell = pkgs.nushell;
    };
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    kitty
    zsh
    vim
    wget
    gtk3
    gtk4
    bluez
    libnotify
    git
    font-awesome
    nwg-look
    nh
    pavucontrol
    wireguard-tools 
    mangohud
    gcc
    clang
    cl
    kdePackages.kirigami
    kdePackages.kirigami-addons
    fastfetch
  ];

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    konsole
    oxygen
  ];

  services.resolved.enable = true;

  # Security
  services.fail2ban.enable = true;
  services.openssh.enable = true;

  services.clipboard-sync.enable = true;

  programs.gnupg.agent = {                                                      
    enable = true;
  };

  networking.wireguard.enable = true;
  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ 51820 ];
    logReversePathDrops = true;

    # CHANGEME
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
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    # set the flake package
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  programs.river = {
    enable = true;
  };

  environment.pathsToLink = [ "/share/zsh" ];

  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = [ "fn3x" "whoispiria" ];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland ];
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.settings = {
    auto-optimise-store = true;
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };
  nix.optimise.automatic = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

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
      
      # Intel P-state performance settings
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
