{
  pkgs,
  system,
  stdenv,
  ...
}: {
  pname ? "odbc2parquet",
  version ? "0.15.6",
  shas ? {
    aarch64-darwin = "07vza723n7q3v6m8x1clw195z4hhimpiqp4g5fbmardac40ac651";
    x86_64-darwin = "07vza723n7q3v6m8x1clw195z4hhimpiqp4g5fbmardac40ac651";
    x86_64-linux = "0js0pldq00k5nl914qqlss36953bkmm38sbpjsrankiqsibixv03";
  },
  ...
}: let
  arch =
    if stdenv.isDarwin
    then "osx"
    else "x86_64-ubuntu.gz";
  file = "odbc2parquet-${arch}";
in
  stdenv.mkDerivation {
    pname = pname;
    version = version;
    src = pkgs.fetchurl {
      url = "https://github.com/pacman82/odbc2parquet/releases/download/v${version}/${file}";
      sha256 = shas.${system};
    };

    phases = ["installPhase" "patchPhase"];

    installPhase =
      if stdenv.isDarwin
      then "mkdir -p $out/bin; cp $src $out/bin/odbc2parquet; chmod +x $out/bin/odbc2parquet"
      else "mkdir -p $out/bin; gunzip < $src > $out/bin/odbc2parquet; chmod +x $out/bin/odbc2parquet";

    checkPhase = ''
      odbc2parquet --version | grep ${version}
    '';
  }
