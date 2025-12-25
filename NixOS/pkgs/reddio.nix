{
  pkgs,
  lib,
  config,
  ...
}: let
in
  pkgs.stdenv.mkDerivation (finalAttrs: {
    pname = "reddio";
    version = "0.52";
    src = pkgs.fetchFromGitLab {
      owner = "aaronNG";
      repo = "reddio";
      rev = "v${finalAttrs.version}";
      hash = "sha256-Bhe3icWycQXwwyBp9z1GpnTYAfAp3m79orfMITTU2Z8=";
    };

    dontBuild = true;
    installPhase = ''
      mkdir -p $out
      make install PREFIX=$out
    '';
  })
