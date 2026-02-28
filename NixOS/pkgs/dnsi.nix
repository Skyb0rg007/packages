{
  lib,
  fetchCrate,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dnsi";
  version = "0.2.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-t/i+pRRUH2wjVzol2ghZHZ9b4R2YB9qsW/l2Q+itoVE=";
  };

  cargoHash = "sha256-uIW7EDL2ulg6qDizjw5iHtc5HqyEZDBoXJxWHZOmoqo=";

  meta = {
    description = "Command line tool to investigate various aspects of the Domain Name System";
    mainProgram = "dnsi";
    homepage = "https://nlnetlabs.nl/projects/domain/dnsi/";
    license = lib.licenses.bsd3;
  };
})
