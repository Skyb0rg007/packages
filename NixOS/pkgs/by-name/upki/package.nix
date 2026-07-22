{
  lib,
  fetchFromGitHub,
  rustPlatform,
  buildPackages,
  stdenv,
  testers,
  versionCheckHook,
  rustc,
  cacert,
  pkg-config,
  openssl,
  cargo-c,
  validatePkgConfig,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "upki";
  version = "1.0.0-beta.2";

  src = fetchFromGitHub {
    owner = "rustls";
    repo = "upki";
    tag = "upki-${finalAttrs.version}";
    hash = "sha256-QTtZnMMSfacqqQUNHtCHgkG2qjQqvO338J/7Cn4HODQ=";
  };

  cargoHash = "sha256-XQBElbN2QiqqP464rfgEwt7UHrKgCgmpHDP36m44kxc=";

  cargoBuildFlags = [
    "--package=upki-cli"
    "--package=upki-openssl"
  ];

  cargoInstallFlags = [
    "--package=upki-cli"
  ];

  nativeBuildInputs = [
    cargo-c
    pkg-config
  ];
  buildInputs = [ openssl ];

  env.SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  postBuild = ''
    ${buildPackages.rust.envVars.setEnv} cargo cbuild --release --frozen \
      --package upki-openssl \
      --prefix=$out \
      --target ${stdenv.hostPlatform.rust.rustcTarget}
  '';

  postInstall = ''
    ${buildPackages.rust.envVars.setEnv} cargo cinstall --release --frozen \
      --package upki-openssl \
      --prefix=$out \
      --target ${stdenv.hostPlatform.rust.rustcTarget}

    install -Dm444 upki/upki.h $out/include/upki_openssl/upki.h
  '';

  nativeInstallCheckInputs = [
    pkg-config
    versionCheckHook
    validatePkgConfig
  ];
  doInstallCheck = true;

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

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
    pkgConfigModules = [ "upki_openssl" ];
    platforms = rustc.meta.platforms;
  };
})
