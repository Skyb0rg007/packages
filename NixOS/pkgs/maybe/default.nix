{
  bundlerApp,
  bundlerEnv,
  bundlerUpdateScript,
  fetchFromGitHub,
  git,
  lib,
  postgresql,
  vips,
  ...
}: let
  source = fetchFromGitHub {
    owner = "maybe-finance";
    repo = "maybe";
    rev = "728b10d08e017338876ceb945fe472430d66739a";
    hash = "sha256-IV5MJNgBVGpT3icZRF9XLlwZAlYERRjOTOeVLYsiHIY=";
  };
in
  bundlerEnv {
    pname = "maybe";
    gemdir = ./.;
    buildInputs = [vips postgresql];
    nativeBuildInputs = [git];
    exes = [];
    passthru.updateScript = bundlerUpdateScript "maybe";
    meta = {
      description = "Maybe: The OS for your personal finances";
      homepage = "https://maybe.co";
      license = lib.licenses.agpl3Plus;
      maintainers = [];
      platforms = lib.platforms.unix;
      # mainProgram = "";
    };
  }
