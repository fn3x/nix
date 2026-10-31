{
  pkgs,
}:

let
  version = "0.1.0";
in
pkgs.rustPlatform.buildRustPackage {
  pname = "usbtree";
  inherit version;

  src = pkgs.fetchFromGitHub {
    owner = "gnomeria";
    repo = "usbtree";
    rev = "v${version}";
    hash = "sha256-52Ppiv2bYLJR4/h0gyxfBtRnyCQkfNBmCNyr5hWe3uY=";
  };

  cargoHash = "sha256-ux1S/0pu7at3UyYiWLpCsrxtd/Hoqf8l9Egp4HIHogY=";

  doCheck = true;

  meta = {
    description = "Cross-platform terminal UI for inspecting the USB device tree";
    homepage = "https://github.com/gnomeria/usbtree";
    changelog = "https://github.com/gnomeria/usbtree/blob/v${version}/CHANGELOG.md";
    license = pkgs.lib.licenses.mit;
    mainProgram = "usbtree";
    platforms = pkgs.lib.platforms.linux;
  };
}
