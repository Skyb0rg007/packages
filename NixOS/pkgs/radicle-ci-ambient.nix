{
  lib,
  fetchCrate,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "radicle-ci-ambient";
  version = "0.12.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-sLjSE4DR1Fj+vIu/Oouge93BqdGkA3jf+OK8yANtTNw=";
  };

  cargoHash = "sha256-QR8pODzNGRsrfoEh2mlWwEmdiDU2ZulRs4UHbOX2ArU=";

  meta = {
    description = "Radicle CI adapter for Ambient";
    homepage = "https://ambient.liw.fi/";
    license = lib.licenses.mit;
  };
})
