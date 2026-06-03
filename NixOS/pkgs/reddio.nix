{
  stdenv,
  fetchFromGitLab,
  lib,
  config,
  nix-update-script,
}:
let
in
stdenv.mkDerivation (finalAttrs: {
  pname = "reddio";
  version = "0.52";
  src = fetchFromGitLab {
    owner = "aaronNG";
    repo = "reddio";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Bhe3icWycQXwwyBp9z1GpnTYAfAp3m79orfMITTU2Z8=";
  };

  dontBuild = true;

  makeFlags = [ "PREFIX=$(out)" ];

  passthru.updateScript = nix-update-script { };
})
