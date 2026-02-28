{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dnst";
  version = "0.1.0-rc2";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = "dnst";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lyHEz6rJZOHN2r/S5fwR8Wv/8Hsc0YUp3ItuUyOscVs=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  cargoHash = "sha256-EE+bXHtDDCPwFuFGBPAXDsjSHmCYKAtWoEc5MxcKLwU=";

  cargoBuildFlags = [
    "--bin"
    "dnst"
  ];

  checkFlags = [
    "--skip=commands::keygen::test::simple_ksk"
  ];

  meta = {
    description = "Toolset to assist DNS operators with zone and nameserver maintenance";
    mainProgram = "dnst";
    homepage = "https://nlnetlabs.nl/projects/domain/dnst/";
    license = lib.licenses.bsd3;
  };
})
