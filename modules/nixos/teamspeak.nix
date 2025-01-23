{
  pkgs,
  ...
}:

pkgs.stdenv.mkDerivation rec {
  pname = "teamspeak6-client";
  version = "6.0.0-beta2";

  src = pkgs.fetchurl {
    url = "https://files.teamspeak-services.com/pre_releases/client/${version}/teamspeak-client.tar.gz";
    sha256 = "de334fbf7b90d91ced475a785d034b520e4856bbd6fdd71db6a5dd88624a552b";
  };

  sourceRoot = ".";

  propagatedBuildInputs = [
    pkgs.alsa-lib
    pkgs.at-spi2-atk
    pkgs.atk
    pkgs.cairo
    pkgs.cups.lib
    pkgs.dbus
    pkgs.gcc-unwrapped.lib
    pkgs.gdk-pixbuf
    pkgs.glib
    pkgs.gtk3
    pkgs.libdrm
    pkgs.libnotify
    pkgs.libpulseaudio
    pkgs.libxkbcommon
    pkgs.libgbm
    pkgs.nss
    pkgs.xorg.libX11
    pkgs.xorg.libXScrnSaver
    pkgs.xorg.libXdamage
    pkgs.xorg.libXfixes
    pkgs.xorg.libxshmfence
    pkgs.xorg.libXtst
    pkgs.xorg.libXext
    pkgs.libglvnd
    pkgs.mesa
  ];

  nativeBuildInputs = [
    pkgs.autoPatchelfHook
    pkgs.copyDesktopItems
    pkgs.makeWrapper
  ];

  desktopItems = [
    (pkgs.makeDesktopItem {
      name = "TeamSpeak";
      exec = "TeamSpeak";
      icon = pname;
      desktopName = pname;
      comment = "TeamSpeak Voice Communication Client";
      categories = [
        "Audio"
        "AudioVideo"
        "Chat"
        "Network"
      ];
    })
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/${pname} $out/share/icons/hicolor/64x64/apps/

    cp -a * $out/share/${pname}
    cp logo-256.png $out/share/icons/hicolor/64x64/apps/${pname}.png

    makeWrapper $out/share/${pname}/TeamSpeak $out/bin/TeamSpeak \
      --prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath [ pkgs.udev pkgs.libglvnd pkgs.mesa ]}" \
      --set LIBGL_ALWAYS_SOFTWARE '0'

    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "TeamSpeak voice communication tool (beta version)";
    homepage = "https://teamspeak.com/";
    license = {
      fullName = "Teamspeak client license";
      url = "https://www.teamspeak.com/en/privacy-and-terms/";
      free = false;
    };
    maintainers = with maintainers; [ fn3x ];
    platforms = [ "x86_64-linux" ];
  };
}
