{
  lib,
  fetchFromGitLab,
  rustPlatform,
  pkg-config,
  openssl,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tpm2sh";
  version = "0.20.1";

  src = fetchFromGitLab {
    owner = "tpm-protocol";
    repo = "tpm2sh";
    tag = finalAttrs.version;
    hash = "sha256-cItaqJ202YG2crIebmsiazQS6aQOAYLbXWN0VntJPtw=";
  };

  cargoHash = "sha256-ccivI3Yx9U5kFd4XBaNrrM5Hm78DbprgmxBV8U1g3xc=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  # Tests require a TPM
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for accessing TPM 2.0 chips on Linux.";
    homepage = "https://gitlab.com/tpm-protocol/tpm2sh";
    mainProgram = "tpm2sh";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.skyesoss ];
    platforms = lib.platforms.linux;
  };
})
