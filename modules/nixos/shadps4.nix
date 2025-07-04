{
  lib,
  pkgs,
}:

pkgs.stdenv.mkDerivation (finalAttrs: {
  pname = "shadps4";
  version = "0.7.0";

  src = pkgs.fetchFromGitHub {
    owner = "shadps4-emu";
    repo = "shadPS4";
    tag = "v.${finalAttrs.version}";
    hash = "sha256-g55Ob74Yhnnrsv9+fNA1+uTJ0H2nyH5UT4ITHnrGKDo=";
    fetchSubmodules = true;
  };

  buildInputs = [
    pkgs.alsa-lib
    pkgs.boost
    pkgs.cryptopp
    pkgs.glslang
    pkgs.ffmpeg
    pkgs.fmt
    pkgs.half
    pkgs.jack2
    pkgs.libdecor
    pkgs.libpulseaudio
    pkgs.libunwind
    pkgs.libusb1
    pkgs.xorg.libX11
    pkgs.xorg.libXext
    pkgs.magic-enum
    pkgs.libgbm
    pkgs.pipewire
    pkgs.pugixml
    pkgs.qt6.qtbase
    pkgs.qt6.qtdeclarative
    pkgs.qt6.qtmultimedia
    pkgs.qt6.qttools
    pkgs.qt6.qtwayland
    pkgs.rapidjson
    pkgs.renderdoc
    pkgs.robin-map
    pkgs.sdl3
    pkgs.sndio
    pkgs.stb
    pkgs.vulkan-headers
    pkgs.vulkan-loader
    pkgs.vulkan-memory-allocator
    pkgs.xxHash
    pkgs.zlib-ng
  ];

  nativeBuildInputs = [
    pkgs.cmake
    pkgs.pkg-config
    pkgs.qt6.wrapQtAppsHook
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_QT_GUI" true)
    (lib.cmakeBool "ENABLE_UPDATER" false)
  ];

  # Still in development, help with debugging
  cmakeBuildType = "RelWithDebugInfo";
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    install -D -t $out/bin shadps4
    install -Dm644 $src/.github/shadps4.png $out/share/icons/hicolor/512x512/apps/net.shadps4.shadPS4.png
    install -Dm644 -t $out/share/applications $src/dist/net.shadps4.shadPS4.desktop
    install -Dm644 -t $out/share/metainfo $src/dist/net.shadps4.shadPS4.metainfo.xml

    runHook postInstall
  '';

  runtimeDependencies = [
    pkgs.vulkan-loader
    pkgs.xorg.libXi
  ];

  passthru = {
    tests.openorbis-example = pkgs.nixosTests.shadps4;
    updateScript = pkgs.nix-update-script { };
  };

  meta = {
    description = "Early in development PS4 emulator";
    homepage = "https://github.com/shadps4-emu/shadPS4";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      fn3x
    ];
    mainProgram = "shadps4";
    platforms = lib.intersectLists lib.platforms.linux lib.platforms.x86_64;
  };
})
