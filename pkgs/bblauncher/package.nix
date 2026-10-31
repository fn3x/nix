{
  pkgs,
  lib,
  ...
}:

pkgs.stdenv.mkDerivation {
  pname = "BB_Launcher";
  version = "0-unstable-2026-10-27";

  src = pkgs.fetchgit {
    url = "https://github.com/rainmakerv3/BB_Launcher.git";
    rev = "0fdce9f094d760d65cb1871b8ac27d4fcace0e81";
    fetchSubmodules = true;
    deepClone = true;
    hash = "sha256-BTLmttB+P3q6TL3pvd3GRdEjgsFho8OYOiadwfywwmE=";
  };

  nativeBuildInputs = with pkgs; [
    cmake
    pkg-config
    git
    qt6.wrapQtAppsHook
    llvmPackages.clang
  ];

  buildInputs = with pkgs; [
    qt6.qtbase
    qt6.qttools
    qt6.qtmultimedia
    qt6.qtwayland
    qt6.qtwebview
    zlib
    openssl
    libpng
  ];

  cmakeFlags = [
    "-DCMAKE_C_COMPILER=clang"
    "-DCMAKE_CXX_COMPILER=clang++"
  ];

  QT_QPA_PLATFORM = "wayland";

  meta = with pkgs.lib; {
    description = "Bloodborne launcher and mod manager for shadPS4";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
