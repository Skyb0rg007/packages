{
  lib,
  fetchCrate,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "radicle-ci-ambient";
  version = "0.13.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-7dD7nQMNJ5MpxRGj9dcSe6ZXboteHoW+nkzrWIsCsAY=";
  };

  cargoHash = "sha256-bJ0yE947GawqR1XcQonLnHpTliJ5W9Xng6wEH0dlzjw=";

  meta = {
    description = "Radicle CI adapter for Ambient";
    mainProgram = "radicle-ci-ambient";
    homepage = "https://ambient.liw.fi/";
    license = lib.licenses.mit;
  };
})
