# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  pkgs,
  inputs,
  config,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/graphics
    ../../modules/audio
    ../../modules/games
  ];

  nvidia.enable = true;
  pipewire.enable = true;
  steam.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  networking.hostName = "desktop"; # Define your hostname.
  networking.interfaces.eno1.useDHCP = true;

  # Enable networking
  networking.nameservers = ["1.1.1.1" "8.8.8.8"];
  networking.enableIPv6 = true;

  # Set your time zone.
  time.timeZone = "Asia/Yerevan";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.logmein-hamachi.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,ru";
    variant = "";
  };

  services.usbmuxd.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };

  users.users.fn3x = {
    isNormalUser = true;
    description = "Art";
    extraGroups = [
      "qemu-libvirtd"
      "kvm"
      "libvirtd"
      "docker"
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "disk"
    ];
    shell = pkgs.fish;
    ignoreShellProgramCheck = true;
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    kitty
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
    kdePackages.partitionmanager
    firefox
    inputs.winapps.packages.${pkgs.stdenv.hostPlatform.system}.winapps
    inputs.winapps.packages.${pkgs.stdenv.hostPlatform.system}.winapps-launcher
    OVMF
    devenv
    nv-codec-headers
    virtiofsd
    niri
    distrobox
    amnezia-vpn
  ];

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    konsole
    oxygen
  ];

  programs.amnezia-vpn.enable = true;

  services.resolved.enable = true;

  # Security
  services.fail2ban.enable = true;
  # services.openssh.enable = true;

  services.clipboard-sync.enable = true;

  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "wooting-udev-rules";
      destination = "/etc/udev/rules.d/70-wooting.rules";
      text = builtins.readFile ../../devices/wooting-60he-v2/wooting.rules;
    })
  ];

  programs.gnupg.agent = {                                                      
    enable = true;
  };

  networking.wireguard.enable = true;

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

  programs.niri = {
    enable = true;
  };

  programs.river-classic = {
    enable = true;
    xwayland.enable = true;
  };

  programs.virt-manager.enable = true;
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      swtpm.enable = true;
    };
  };
  virtualisation.podman.enable = true;
  boot.kernelModules = [ "kvm-amd" "v4l2loopback" "snd-aloop" ];
  boot.extraModprobeConfig = ''
    options kvm_amd nested=1
    options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
  '';
  boot.extraModulePackages = with config.boot.kernelPackages;
    [ v4l2loopback.out ];
  systemd.tmpfiles.rules = [
    "d /var/log/libvirt 0755 root root -"
    "f /dev/shm/looking-glass 0660 fn3x qemu-libvirtd -"
  ];
  virtualisation.spiceUSBRedirection.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-wlr ];
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.settings = {
    auto-optimise-store = true;
    substituters = [
      "https://hyprland.cachix.org"
      "https://devenv.cachix.org"
      "https://vicinae.cachix.org"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
    ];
    trusted-users = [ "root" "fn3x" ];
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  nix.settings = {
    max-jobs = 8;
  };
}
