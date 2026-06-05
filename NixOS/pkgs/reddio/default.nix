{
  stdenv,
  fetchFromGitLab,
  lib,
  config,
  nix-update-script,
  testers,
}:
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

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "reddio -V";
    };
  };

  meta = {
    description = "Command-line interface for Reddit";
    homepage = "https://gitlab.com/aaronNG/reddio/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.skyesoss ];
  };
})
