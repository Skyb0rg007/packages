{
  fetchFromGitHub,
  lib,
  openssl,
  pkg-config,
  rustPlatform,
  tpm2-tss,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rust-keylime";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "keylime";
    repo = "rust-keylime";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TUS1goiU/DecC3HKk72fshyMQr3zLkvn72hFb0x9Ot4=";
  };

  doCheck = true;

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl.dev
    tpm2-tss.dev
  ];

  cargoHash = "sha256-AcaCmlwNkA0TO3OprAKDILeFa7xepT1q8N9ZUVYx4M0=";

  meta = {
    description = "Rust implementation of a keylime agent";
    longDescription = ''
      This is a Rust implementation of keylime agent.
      Keylime is system integrity monitoring system that has the following features:

      - Exposes TPM trust chain for higher-level use
      - Provides an end-to-end solution for bootstrapping node cryptographic identities
      - Securely monitors system integrity

      The rust-keylime agent is the official agent and replaces the Python implementation.
    '';
    homepage = "https://keylime.dev";
    changelog = "https://github.com/keylime/rust-keylime/releases";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.skyesoss ];
    mainProgram = "keylime_agent";
    platforms = lib.platforms.linux;
  };
})
