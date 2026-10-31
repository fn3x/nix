{
  pkgs,
}:
let
  wxwidgets = pkgs.wxwidgets_3_2.override { withWebKit = false; };
in
pkgs.stdenv.mkDerivation (finalAttrs: {
  pname = "audacity";
  version = "4.0.0";

  src = pkgs.fetchurl {
    url = "https://github.com/audacity/audacity/releases/download/Audacity-${finalAttrs.version}/audacity-sources-${finalAttrs.version}.tar.xz";
    hash = "sha256-spB2+Z+l0vUi0AHbRyqJbbgfnv/v0VlIyUBXF1OFgFg=";
  };

  postPatch = pkgs.lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''
    substituteInPlace au3/libraries/au3-files/FileNames.cpp \
      --replace-fail /usr/include/linux/magic.h ${pkgs.linuxHeaders}/include/linux/magic.h
  '';

  nativeBuildInputs = with pkgs; [
    cmake
    git
    ninja
    pkg-config
    python3
    qt6.qttools
    qt6.wrapQtAppsHook
    wxwidgets
  ]
  ++ pkgs.lib.optionals stdenv.hostPlatform.isLinux [
    pkgs.linuxHeaders
    pkgs.wrapGAppsHook3
  ];

  buildInputs = with pkgs; [
    ffmpeg
    flac
    freetype
    harfbuzz
    lame
    libjack2
    libogg
    libopus
    libsndfile
    libvorbis
    mpg123
    opusfile
    portaudio
    pugixml
    qt6.qt5compat
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtnetworkauth
    qt6.qtshadertools
    qt6.qtsvg
    utf8cpp
    wavpack
    wxwidgets
    zlib
  ]
  ++ pkgs.lib.optionals stdenv.hostPlatform.isLinux [
    pkgs.alsa-lib
    pkgs.qt6.qtwayland
  ];

  cmakeFlags = [
    (pkgs.lib.cmakeFeature "AU4_BUILD_MODE" "release")
    (pkgs.lib.cmakeFeature "EXTDEPS_OVERRIDE_ALL" "SYSTEM")
    (pkgs.lib.cmakeBool "MUSE_COMPILE_USE_CCACHE" false)
    (pkgs.lib.cmakeBool "MUSE_ENABLE_UNIT_TESTS" finalAttrs.finalPackage.doCheck)
    (pkgs.lib.cmakeBool "MUSE_MODULE_DIAGNOSTICS_CRASHPAD_CLIENT" false)
  ];

  preConfigure = ''
    cmakeFlagsArray+=("-DEXTDEPS_CACHE=$PWD/offline-deps")
  '';

  qtWrapperArgs = [
    "--prefix"
    "${pkgs.lib.optionalString pkgs.stdenv.hostPlatform.isDarwin "DY"}LD_LIBRARY_PATH"
    ":"
    (pkgs.lib.makeLibraryPath [
      pkgs.ffmpeg
      pkgs.libjack2
    ])
  ];

  preFixup = pkgs.lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  dontWrapGApps = true;

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Sound editor with graphical UI";
    mainProgram = "audacity";
    homepage = "https://www.audacityteam.org";
    changelog = "https://github.com/audacity/audacity/releases/tag/Audacity-${finalAttrs.version}";
    license = pkgs.lib.licenses.AND [
      pkgs.lib.licenses.gpl2Plus
      pkgs.lib.licenses.gpl3Only
      pkgs.lib.licenses.cc-by-30
    ];
    maintainers = with pkgs.lib.maintainers; [
      veprbl
      wegank
    ];
    platforms = pkgs.lib.platforms.unix;
  };
})
