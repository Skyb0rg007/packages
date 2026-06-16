{
  lib,
  fetchFromGitLab,
  rustPlatform,
  pkg-config,
  openssl,
  nix-update-script,
  testers,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tpm2sh";
  version = "0.17.2";

  src = fetchFromGitLab {
    owner = "tpm-protocol";
    repo = "tpm2sh";
    tag = finalAttrs.version;
    hash = "sha256-i76TzDLc462WxcBmbbxNiKcWOmuMJIjZuexPsxXGnkY=";
  };

  cargoHash = "sha256-PaeKHRomOH49rmYM5BOxX7h6TBolmF0FyC6ZqEmMgA0=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  # Tests require a TPM
  doCheck = false;

  passthru.updateScript = nix-update-script { };
  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "CLI for accessing TPM 2.0 chips on Linux.";
    homepage = "https://gitlab.com/tpm-protocol/tpm2sh";
    mainProgram = "tpm2sh";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.skyesoss ];
    platforms = lib.platforms.linux;
  };
})
