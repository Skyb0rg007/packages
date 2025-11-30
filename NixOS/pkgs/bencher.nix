{
  config,
  lib,
  fetchFromGitHub,
  rustPlatform,
  mold,
  pkg-config,
  fontconfig,
  freetype,
  ...
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bencher";
  version = "0.5.8";

  nativeBuildInputs = [
    mold
    pkg-config
  ];
  buildInputs = [
    fontconfig
    freetype
  ];
  checkInputs = [
    fontconfig.lib
  ];

  src = fetchFromGitHub {
    owner = "bencherdev";
    repo = "bencher";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Nz+j8Iwjy4Ziw/L8D7SK3AFRIWP4QQyu63mQnc7dh4o=";
  };

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "client"
    "server"
  ];

  doCheck = false;

  cargoHash = "sha256-3jiBz1gWO9klTeXMqVL16qczJptPf9HVksitiGversI=";

  meta = {
    description = "Bencher - Continuous Benchmarking";
    homepage = "https://bencher.dev";
    license = [
      lib.licenses.asl20
      lib.licenses.mit
      lib.licenses.unfree
    ];
  };
})
