# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  pkgs,
  inputs,
  ...
}:
let
  pkgs-unstable = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in 
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/nvidia.nix
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    package = pkgs-unstable.mesa.drivers;
    package32 = pkgs-unstable.pkgsi686Linux.mesa.drivers;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "desktop"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

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

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,ru";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;

  security.polkit.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  programs.ssh = {
    startAgent = true;
  };

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    histSize = 10000;
    shellInit = ''
      # Start ssh-agent if not already running
      if ! pgrep -u "$USER" ssh-agent > /dev/null 2>&1; then
        eval "$(ssh-agent -s)"
      fi

      # Add keys to the agent if not already added
      if ! ssh-add -l &>/dev/null; then
        ssh-add ~/.ssh/id_github ~/.ssh/id_bitbucket 2>/dev/null || true
      fi
    '';
  };

  users.users.fn3x = {
    isNormalUser = true;
    description = "Art";
    extraGroups = [
      "docker"
      "networkmanager"
      "wheel"
      "audio"
      "video"
    ];
    shell = pkgs.zsh;
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    kitty
    zsh
    vim
    wget
    (pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    }))
    gtk3
    gtk4
    swaynotificationcenter
    hyprpicker
    bluez
    libnotify
    git
    font-awesome
    nwg-look
    nh
    pavucontrol
    wireplumber
    wireguard-tools 
    libva
    mangohud
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-vaapi 
  ];

  services.resolved.enable = true;

  # Security
  services.fail2ban.enable = true;
  services.openssh.enable = true;

  programs.gnupg.agent = {                                                      
    enable = true;
  };

  networking.wireguard.enable = true;
  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ 0 ]; # CHANGEME
    logReversePathDrops = true;

    # CHANGEME
    extraCommands = ''
     ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 26423 -j RETURN
     ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 26423 -j RETURN
    '';
    extraStopCommands = ''
     ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 26423 -j RETURN || true
     ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 26423 -j RETURN || true
    '';
  };
  networking.wg-quick.interfaces = {
    default = {
      address = [ "" ]; #CHANGEME
      privateKeyFile = ""; #CHANGEME
      listenPort = 0; #CHANGEME
      dns = [ "" ]; #CHANGEME
      peers = [
        {
          publicKey = ""; #CHANGEME
          allowedIPs = [ "" ]; #CHANGEME
          endpoint = ""; #CHANGEME
          persistentKeepalive = 10;
        }
      ];
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  # Enable the gnome-keyring secrets vault.
  # Will be exposed through DBus to programs willing to store secrets.
  services.gnome.gnome-keyring.enable = true;

  programs.uwsm = {
    enable = true;
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    # set the flake package
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  environment.pathsToLink = [ "/share/zsh" ];
  environment.persistence = {
    "/persist" = {
      directories = [
        "/etc/nixos"
        "/etc/NetworkManager/system-connections"
        "/var/lib/systemd"
        "/var/lib/nixos"
        "/var/log"
        "/srv"
      ];
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk ];
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
