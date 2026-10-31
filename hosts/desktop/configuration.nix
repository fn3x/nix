{
  pkgs,
  inputs,
  config,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
    ../../modules/graphics
    ../../modules/audio
    ../../modules/games
    inputs.odysseus.nixosModules.default
  ];

  nvidia.enable = true;
  pipewire.enable = true;
  steam.enable = true;

  networking.hostName = "desktop";
  networking.enableIPv6 = true;

  services.resolved.settings.Resolve.FallbackDNS = [
    "1.1.1.1"
    "8.8.8.8"
  ];

  networking.firewall = {
    allowedTCPPorts = [ 7000 ];
  };

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

  services.xserver.xkb = {
    layout = "us,ru";
    variant = "";
  };

  services.logmein-hamachi.enable = true;
  services.cpupower-gui.enable = false;

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

  users.users.fn3x.extraGroups = [
    "qemu-libvirtd"
    "kvm"
    "libvirtd"
    "docker"
  ];

  environment.systemPackages = with pkgs; [
    mangojuice
    cl
    kdePackages.kirigami
    kdePackages.kirigami-addons
    kdePackages.partitionmanager
    kdePackages.qtsvg
    inputs.winapps.packages.${system}.winapps
    inputs.winapps.packages.${system}.winapps-launcher
    devenv
    virtiofsd
    distrobox
    cliphist
    wl-clip-persist

    # Dolphin as the file manager outside Plasma
    kdePackages.dolphin
    kdePackages.dolphin-plugins
    kdePackages.ark # "Compress"/"Extract" context menu
    kdePackages.kio-extras
    kdePackages.kdegraphics-thumbnailers
    kdePackages.ffmpegthumbs
  ];

  programs.firefox.enable = true;
  programs.amnezia-vpn.enable = true;

  services.mullvad-vpn = {
    enable = false;
    package = pkgs.mullvad-vpn;
  };

  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "wooting-udev-rules";
      destination = "/etc/udev/rules.d/70-wooting.rules";
      text = builtins.readFile ../../devices/wooting-60he-v2/wooting.rules;
    })
  ];

  services.udev.extraRules = ''
    SUBSYSTEM=="input", ATTRS{idVendor}=="2dc8", ATTRS{idProduct}=="310b", MODE="0660", GROUP="input"
    KERNEL=="ntsync", SUBSYSTEM=="misc", TAG+="uaccess"

    # 2.4GHz/Dongle
    KERNEL=="hidraw*", ATTRS{idVendor}=="2dc8", MODE="0660", TAG+="uaccess"
    # Bluetooth
    KERNEL=="hidraw*", KERNELS=="*2DC8:*", MODE="0660", TAG+="uaccess"
  '';

  services.flatpak.enable = true;

  # Secrets are read from files outside the repo/store; see
  # /etc/odysseus/env (chmod 600) with ODYSSEUS_ADMIN_PASSWORD=... and SEARX_SECRET_KEY=...
  services.odysseus = {
    enable = false;
    environmentFile = "/etc/odysseus/env";
    extraEnvironmentVariables = {
      NVIDIA_VISIBLE_DEVICES = "all";
      NVIDIA_DRIVER_CAPABILITIES = "compute,utility";
      HF_HUB_DISABLE_XET = "1";
    };
    extraPythonPackages =
      ps: with ps; [
        hf-transfer
        rembg
        diffusers
      ];
    llamaCpp.enable = true;
    searxng = {
      enable = true;
      # substituted by searx from services.searx.environmentFile
      secretKey = "$SEARX_SECRET_KEY";
    };
  };

  services.searx.environmentFile = "/etc/odysseus/env";
  services.searx.settings.engines = [
    {
      name = "radio browser";
      disabled = true;
    }
  ];

  services.ollama = {
    enable = false;
    host = "0.0.0.0";
    package = pkgs.ollama-cuda;
  };

  networking.wireguard.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "26.05"; # Did you read the comment?

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${system}.hyprland;
    portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
  };

  programs.niri = {
    enable = true;
    # Nautilus would claim org.freedesktop.FileManager1 ("Show in folder")
    useNautilus = false;
  };
  services.dbus.packages = [ pkgs.kdePackages.dolphin ];

  programs.river-classic = {
    enable = false;
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
  virtualisation.spiceUSBRedirection.enable = true;

  boot.kernelModules = [
    "kvm-amd"
    "v4l2loopback"
    "snd-aloop"
    "ntsync"
  ];
  boot.extraModprobeConfig = ''
    options kvm_amd nested=1
    options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
  '';
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback.out ];
  systemd.tmpfiles.rules = [
    "d /var/log/libvirt 0755 root root -"
    "f /dev/shm/looking-glass 0660 fn3x qemu-libvirtd -"
  ];

  boot.kernelParams = [
    "threadirqs"
    "preempt=full"
    "amd_pstate=active"
    "usbcore.autosuspend=-1"
  ];

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];
  services.power-profiles-daemon.enable = false;
  powerManagement.cpuFreqGovernor = "performance";

  environment.etc."xdg/menus/applications.menu".source = "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
  environment.variables =
    let
      makePluginPath =
        format:
        (pkgs.lib.makeSearchPath format [
          "$HOME/.nix-profile/lib"
          "/run/current-system/sw/lib"
          "/etc/profiles/per-user/$USER/lib"
        ])
        + ":$HOME/.${format}";
    in
    {
      LV2_PATH = makePluginPath "lv2";
      VST3_PATH = makePluginPath "vst3";
      CLAP_PATH = makePluginPath "clap";
    };

  # lutris workaround
  nixpkgs.overlays = [
    (_: prev: {
      openldap = prev.openldap.overrideAttrs {
        doCheck = !prev.stdenv.hostPlatform.isi686;
      };
    })
  ];
}
