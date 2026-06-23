{
  lib,
  fetchFromGitHub,
  nix-update-script,
  testers,
  rustPlatform,
  rustc,
  installShellFiles,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "landstrip";
  version = "0.16.11";
  src = fetchFromGitHub {
    owner = "landstrip";
    repo = "landstrip";
    tag = finalAttrs.version;
    hash = "sha256-L7vbg3g0FMQVX58WtfX5IsoM7T0K+45voPPCoykMovE=";
  };

  cargoHash = "sha256-HVwku+sTKIVGELyoNvvTdScoFUTRaAdSaCmy6kIn/ac=";

  nativeBuildInputs = [
    installShellFiles
  ];

  doCheck = false; # Requires permissions

  postInstall = ''
    installManPage ./man/man1/landstrip.1
  '';

  passthru.updateScript = nix-update-script { };
  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = {
    homepage = "https://github.com/landstrip/landstrip";
    description = "Run tools in OS-level sandboxes";
    mainProgram = "landstrip";
    maintainers = [ lib.maintainers.skyesoss ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin ++ lib.platforms.windows;
  };
})
