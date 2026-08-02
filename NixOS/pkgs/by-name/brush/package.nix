{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "brush";
  version = "0.4.0-unstable-2026-07-31";

  src = fetchFromGitHub {
    owner = "reubeno";
    repo = "brush";
    rev = "71afef7ce79ad2fd94833fa4f93fa5486c86c56b";
    hash = "sha256-xUpeKbbi3IK6Q3zFuoL4Wgx8nKHAaTQKB9PBDOyIqck=";
  };

  cargoHash = "sha256-PS3yjRyVHoBHTyayWK5krkD1zjbd1+cyAF5qNu1SW3g=";

  postPatch = ''
    rm brush-shell/tests/compat_tests.rs
    sed -i -e '/^\[\[test\]\]$/{N;/name = "brush-compat-tests"/{N;N;N;d}}' brush-shell/Cargo.toml
  '';

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
