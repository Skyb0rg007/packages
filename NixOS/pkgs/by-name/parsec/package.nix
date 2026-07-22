{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  pkg-config,
  tpm2-tss,
  protobuf,
  mbedtls,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "parsec";
  version = "1.5.0";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "parallaxsecond";
    repo = "parsec";
    tag = finalAttrs.version;
    hash = "sha256-LPJ+QOtzwvzQ1VAu/mJlTvYt9H5t8ppZZIKq7rKUy+I=";
  };

  cargoHash = "sha256-zxp1r23otuw4fv5KSbVBJiPPLdhKa1fdgUCTruU+j2w=";

  env = {
    CMAKE_POLICY_VERSION_MINIMUM = "3.5";
    PROTOC = "${protobuf}/bin/protoc";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    tpm2-tss
    mbedtls
  ];

  buildFeatures = [
    "mbed-crypto-provider"
    "pkcs11-provider"
    "tpm-provider"
    "cryptoauthlib-provider"
    # "all-providers"

    "direct-authenticator"
    "unix-peer-credentials-authenticator"
    # "jwt-svid-authenticator"
    # "all-authenticators"
  ];

  meta = {
    description = "Platform AbstRaction for SECurity";
    homepage = "https://parsec.community";
    changelog = "https://github.com/parallaxsecond/parsec/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.skyesoss ];
    mainProgram = "parsec";
    platforms = lib.platforms.linux;
  };
})
