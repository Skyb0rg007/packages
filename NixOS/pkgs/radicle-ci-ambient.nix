{
  lib,
  fetchCrate,
  rustPlatform,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "radicle-ci-ambient";
  version = "0.19.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-zTvuzipqQ4/yWnnQd+eaIdVYUruQwvKMEm6yBCSRuJs=";
  };

  cargoHash = "sha256-bJ0yE947GawqR1XcQonLnHpTliJ5W9Xng6wEH0dlzjw=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Radicle CI adapter for Ambient";
    mainProgram = "radicle-ci-ambient";
    homepage = "https://ambient.liw.fi/";
    license = lib.licenses.mit;
  };
})
