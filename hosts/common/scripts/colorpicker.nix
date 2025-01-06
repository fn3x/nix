{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.hyprpicker          # Dependency for the color picker
    pkgs.wl-clipboard        # For clipboard management
    pkgs.libnotify           # Provides notify-send
  ];

  shellHook = ''
    echo "Environment for Color Picker Script is ready!"
    echo "Run your script using ./script.sh"
  '';
}
