{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      NPM_CONFIG_PREFIX = toString ./npm_config_prefix;
    in
    {
      devShells.x86_64-linux = {
        work = pkgs.mkShell {
          packages = with pkgs; [
            nodejs_23
            pnpm
            go_1_23
            awscli2
            protobuf
            protoc-gen-go
            protoc-gen-go-grpc
            protoc-gen-js
            sqlc
            dbmate
            docker
            mariadb
            zsh
          ];

          inherit NPM_CONFIG_PREFIX;

          buildInputs = [ pkgs.docker ];
          shellHook = ''
          export PATH="${NPM_CONFIG_PREFIX}/bin:$PATH"
          export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/docker.sock"
          alias vim="nvim"
          '';
        };

        zig = pkgs.mkShell {
          packages = with pkgs; [
            zig
          ];
        };
      };
    };
}
