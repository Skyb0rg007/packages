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
  version = "0-unstable-2026-07-02";

  src = fetchFromGitHub {
    owner = "landlock-lsm";
    repo = "landlockconfig";
    rev = "ab1ddf33b5d1c4b76c43ac8e0d46cbe1b0b48524";
    hash = "sha256-3CrWhEHN7+gH+tCQ7C2XVyVcv+UeKtF38EbCz6ASBZY=";
  };

  cargoPatches = [
    ./add-Cargo.lock.patch
  ];

  cargoHash = "sha256-nY6UxXk/CuPF03NdX/RviujFV4WhARIN/sQkgmVTfbs=";

  nativeBuildInputs = [
    cargo-c
  ];

  # landlockconfig is a library workspace: the root crate is a pure Rust lib and
  # the installable artifact is the C API (cdylib/staticlib + header + pkg-config)
  # produced by the `landlockconfig_ffi` crate via cargo-c. `cargo install` only
  # copies executables, so without this `$out` would be empty.
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
    homepage = "https://landlock.io";
    description = "Landlock configuration library";
    license = lib.licenses.OR [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    platforms = lib.platforms.linux;
  };
})
