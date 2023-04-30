# odbc2parquetnix

Nix [flake](https://nixos.wiki/wiki/Flakes) for [odbc2parquet](https://github.com/pacman82/odbc2parquet)

## Usage

This `odbc2parquet` `nix` flake assumes you have already [installed nix](https://determinate.systems/posts/determinate-nix-installer)

### Option 1. Use the `odbc2parquet` CLI within your own flake

```nix
{
  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.odbc2parquet.url = "github:rupurt/odbc2parquet";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    odbc2parquet,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            odbc2parquet.overlay
          ];
        };
      in rec
      {
        packages = {
          odbc2parquet = pkgs.odbc2parquet {};
        };

        devShells.default = pkgs.mkShell {
          packages = [
            packages.odbc2parquet
          ];
        };
      }
    );
}
```

The above config will add `odbc2parquet` to your dev shell and also allow you to execute it
through the `nix` CLI utilities.

```sh
# run from devshell
nix develop -c $SHELL
odbc2parquet
```

```sh
# run as application
nix run .#odbc2parquet
```

### Option 2. Run the `odbc2parquet` CLI directly with `nix run`

```nix
nix run github:rupurt/odbc2parquetnix
```

## Authors

- Alex Kwiatkowski - alex+git@fremantle.io

## License

`odbc2parquetnix` is released under the MIT license
