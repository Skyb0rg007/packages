{
  lib,
  fetchgit,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "radicle-ci-ambient";
  version = "0.12.0";

  src = fetchgit {
    url = "https://radicle.liw.fi/z35CgFVYCKpqqDtJMzk8dyE6dViS6.git";
    hash = "sha256-3WIAhE9vDgC14V9PJWUUriXFxzDEf1x0/05k4aq/TM0=";
  };

  cargoHash = "sha256-QR8pODzNGRsrfoEh2mlWwEmdiDU2ZulRs4UHbOX2ArU=";

  meta = {
    description = "Radicle CI adapter for Ambient";
    homepage = "https://ambient.liw.fi/";
    license = lib.licenses.mit;
  };
})
