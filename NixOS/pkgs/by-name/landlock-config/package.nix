{
  lib,
  stdenv,
  buildPackages,
  rustPlatform,
  fetchFromGitHub,
  cargo-c,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "landlock-config";
  version = "0-unstable-2026-07-22";

  src = fetchFromGitHub {
    owner = "landlock-lsm";
    repo = "landlockconfig";
    rev = "bdffdcd14e6c5fb8c0b014ee8a7df897fafcb8e2";
    hash = "sha256-MgXAikH8H7wPJKRFu7TH50JDOXTNaxdgMXgDrQ/E+LY=";
  };

  cargoHash = "sha256-abRwcJqLm4UD1Bn7ZnxO/5R3xyVA5Hb1fisw5/bYE3g=";

  nativeBuildInputs = [
    cargo-c
  ];

  cargoBuildFlags = [
    "--package=llconfig"
  ];

  postBuild = ''
    ${buildPackages.rust.envVars.setEnv} cargo cbuild --release --frozen \
      --package landlockconfig_ffi \
      --prefix=$out \
      --target ${stdenv.hostPlatform.rust.rustcTarget}
  '';

  postInstall = ''
    ${buildPackages.rust.envVars.setEnv} cargo cinstall --release --frozen \
      --package landlockconfig_ffi \
      --prefix=$out \
      --target ${stdenv.hostPlatform.rust.rustcTarget}
  '';

  meta = {
    description = "Landlock configuration library";
    homepage = "https://landlock.io";
    downloadPage = "https://github.com/landlock-lsm/landlockconfig";
    license = lib.licenses.OR [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.skyesoss ];
  };
})
