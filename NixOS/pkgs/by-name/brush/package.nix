{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "brush";
  version = "0.4.0-unstable-2026-07-26";

  src = fetchFromGitHub {
    owner = "reubeno";
    repo = "brush";
    rev = "897b373e08279f644438fb19438f156fc34647cd";
    hash = "sha256-cGyU/gbgT8zZ8mG5aljH5L7NKqk1T6NePH52Rx/UpgI=";
  };

  cargoHash = "sha256-PS3yjRyVHoBHTyayWK5krkD1zjbd1+cyAF5qNu1SW3g=";

  doCheck = false;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version=branch"
      "--version-regex=^brush-v([0-9.]+-unstable-[0-9-]+)$"
    ];
  };

  meta = {
    description = "Bash/POSIX-compatible shell implemented in Rust";
    homepage = "https://github.com/reubeno/brush";
    changelog = "https://github.com/reubeno/brush/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.skyesoss ];
    mainProgram = "brush";
  };
})
