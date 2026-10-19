{
  lib,
  fetchFromRadicle,
  rustPlatform,
  rustc,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "radicle-artifact";
  version = "0.23.1";

  src = fetchFromRadicle {
    seed = "iris.radicle.network";
    repo = "z4VYyJ9KuwMNkXGQnmKuGPGKw3inv";
    tag = "releases/${finalAttrs.version}";
    hash = "sha256-9iUkPdO6Cc861eiYmvqfoCiG2AcSBWc4hsDUxqfUKQ8=";
  };

  cargoHash = "sha256-cQqBN3Pw0tFvTRy90LHJi9yTebM0qimkJB1vz5MLo5A=";

  doCheck = false; # TODO: Enable these tests

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Secure artifact distribution for Radicle";
    homepage = "https://radicle.network/nodes/${finalAttrs.src.seed}/rad%3A${finalAttrs.src.repo}";
    changelog = "${finalAttrs.meta.homepage}/tree/${lib.escapeURL finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.OR [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    mainProgram = "rad-artifact";
    inherit (rustc.meta) platforms;
    hydraPlatforms = [ "x86_64-linux" ];
    maintainers = [ lib.maintainers.skyesoss ];
  };
})
