{
  description = "Nix flake to manage odbc2parquet. A cross platform CLI for Flyte";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs,
    ...
  }: let
    systems = ["x86_64-linux" "x86_64-darwin" "aarch64-darwin"];
    outputs = flake-utils.lib.eachSystem systems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [self.overlay];
      };
    in rec {
      # packages exported by the flake
      packages.default = pkgs.odbc2parquet {};

      # nix run
      apps = {
        odbc2parquet = flake-utils.lib.mkApp {drv = packages.default;};
        default = apps.odbc2parquet;
      };

      # nix fmt
      formatter = pkgs.alejandra;

      # nix develop -c $SHELL
      devShells.default = pkgs.mkShell {
        packages = [
          packages.default
        ];
      };
    });
  in
    outputs
    // {
      # Overlay that can be imported so you can access the packages
      # using odbc2parquet.overlay
      overlay = final: prev: {
        odbc2parquet = prev.pkgs.callPackage ./default.nix {};
      };
    };
}
