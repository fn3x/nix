# Settings shared by every host.
{
  pkgs,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;

  nix = {
    channel.enable = false;
    optimise.automatic = true;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      max-jobs = 8;
      trusted-users = [
        "root"
        "fn3x"
      ];
      extra-substituters = [
        "https://hyprland.cachix.org"
        "https://devenv.cachix.org"
        "https://vicinae.cachix.org"
        "https://niri.cachix.org"
        "https://noctalia.cachix.org"
      ];
      extra-trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];
    };
  };

  # Replaces nix.gc: cleans system and user generations
  programs.nh = {
    enable = true;
    flake = "/home/fn3x/nixos";
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep-since 30d --keep 5";
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking = {
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
    networkmanager = {
      enable = true;
    };
  };


  services.resolved.enable = true;

  time.timeZone = "Asia/Yerevan";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.fn3x = {
    isNormalUser = true;
    description = "Art";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
    ];
    shell = pkgs.fish;
    ignoreShellProgramCheck = true;
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.usbmuxd.enable = true;
  services.printing.enable = true;

  programs.gnupg.agent.enable = true;

  programs.hyprland.withUWSM = true;

  fonts.packages = with pkgs; [
    font-awesome
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.code-new-roman
  ];

  environment.systemPackages = with pkgs; [
    kitty
    vim
    wget
    git
    libnotify
    nwg-look
    pavucontrol
    wireguard-tools
    mangohud
    gcc
    clang
    fastfetch
    wl-clipboard
  ];
}
