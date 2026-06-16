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
  version = "0.14.5";
  src = fetchFromGitHub {
    owner = "landstrip";
    repo = "landstrip";
    tag = finalAttrs.version;
    hash = "sha256-OCrAJSFfGwxCSGOqdm9B8YQZKaIsUIoJCrcVXkZ/20E=";
  };

  cargoHash = "sha256-ZFTag/32HS9xiW/pAdqQvA9icoffVgsqEWOq0QuYgFA=";

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
