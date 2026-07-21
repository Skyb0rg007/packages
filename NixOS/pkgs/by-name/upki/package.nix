{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  versionCheckHook,
  rustc,
  cacert,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "upki";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "rustls";
    repo = "upki";
    tag = "upki-${finalAttrs.version}";
    hash = "sha256-F+35W3lCoZ4Oq5tq2zbtBeU7lXVx9/tA3OY2UvkqsWU=";
  };

  cargoHash = "sha256-RXWeZT9c1lSVrz4J0XdxOmLmYtzwJgIQlXrvwGvkB78=";

  buildAndTestSubdir = "upki";

  nativeCheckInputs = [ cacert ];

  env.SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Platform-independent browser-grade certificate infrastructure";
    homepage = "https://github.com/rustls/upki/tree/main/upki";
    changelog = "https://github.com/rustls/upki/releases/tag/upki-${finalAttrs.version}";
    license = lib.licenses.OR [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    maintainers = [ lib.maintainers.skyesoss ]; # upstream: lesuisse
    mainProgram = "upki";
    platforms = rustc.meta.platforms;
  };
})
