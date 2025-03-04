{
  pkgs,
  lib,
  config,
  ...
}: let

in pkgs.stdenv.mkDerivation {
  pname = "reddio";
  version = "0.52";
  src = pkgs.fetchFromGitLab {
    owner = "aaronNG";
    repo = "reddio";
    rev = "eab05356847283725863886a66866090466dab52";
    hash = "sha256-CghOOBT4QsNsFOslSVazjsFAswvsfQbvBTL6RnBo5zQ=";
  };

  dontBuild = true;
  installPhase = ''
    mkdir -p $out
    make install PREFIX=$out
  '';
}
