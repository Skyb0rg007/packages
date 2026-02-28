{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cascade";
  version = "0.1.0-alpha5";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = "cascade";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i3eKuiZj6fVUxTLLVI75BG+rwh35pjiqPJHelS65ueU=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  cargoHash = "sha256-0Vpa4C5dNZMLAuOffenK4F9cFaFdRlAsqaDu4oeRScs=";

  meta = {
    description = "Friendly DNSSEC signing pipeline";
    mainProgram = "cascade";
    homepage = "https://blog.nlnetlabs.nl/cascade/";
    license = lib.licenses.bsd3;
  };
})
