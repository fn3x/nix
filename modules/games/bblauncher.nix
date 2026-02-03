{
  pkgs,
  lib,
  ...
}:

pkgs.stdenv.mkDerivation rec {
  pname = "BB_Launcher";
  version = "unstable";

  src = pkgs.fetchgit {
    url = "https://github.com/rainmakerv3/BB_Launcher.git";
    rev = "refs/heads/master";
    fetchSubmodules = true;
    deepClone = true;
    sha256 = "sha256-rDoj05CSaB2f4d9A76oKBpUlJxB+X8msRQ03CkULkzo=";
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
