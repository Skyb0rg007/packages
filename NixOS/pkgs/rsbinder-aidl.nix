{
  fetchCrate,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rsbinder-aidl";
  version = "0.5.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-5Tg9EWMGJIagXPgV6gOJroWnSTmaX9itX2rkr0YrxPI=";
  };

  checkFlags = [
    "--skip=test_fixed_size_array"
    "--skip=test_nullability"
    "--skip=test_enums"
    "--skip=test_array_of_interfaces_check"
  ];

  cargoHash = "sha256-We14Slw5/FkTjQz10nCKsBQsddgdrSXxI0aChrQlpJg=";

  meta = {
    description = "AIDL compiler for rsbinder";
    homepage = "https://github.com/hiking90/rsbinder";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
  };
})
