{
  lib,
  fetchCrate,
  rustPlatform,
  libisoburn,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ambient-ci";
  version = "0.11.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-Wuircf360XcaUEG4viRYohtW7lJQ2vHim7AoYYyhAEg=";
  };

  cargoHash = "sha256-l4ZnhDtPwL5ofqOAIDqtiKGrNXk6b+3Cp6ucNWyCX0M=";

  doCheck = true;
  nativeCheckInputs = [libisoburn];

  meta = {
    description = "Ambient continuous integration engine";
    longDescription = ''
      Ambient CI is a continuous integration system that aims to make it safe
      and secure to run CI on other people's code.
      It runs all the code from the project under test in a virtual machine
      that has no network access.
    '';
    mainProgram = "ambient";
    homepage = "https://ambient.liw.fi/";
    license = lib.licenses.gpl3Plus;
  };
})
