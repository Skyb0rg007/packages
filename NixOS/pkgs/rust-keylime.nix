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
  version = "0.2.9";

  src = fetchFromGitHub {
    owner = "keylime";
    repo = "rust-keylime";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/8ZvIhv/Z177Svv/h81zq9uz5NnPHEDA3B49Fn57Pz8=";
  };

  cargoHash = "sha256-Fg07/C3rbFeJWtvhX2UJuWmWDh4XCDuoDyEUZSsuzX8=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl.dev
    tpm2-tss.dev
  ];

  meta = {
    description = "Rust implementation of the keylime agent";
    longDescription = ''
      This is a Rust implementation of the keylime agent.
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
