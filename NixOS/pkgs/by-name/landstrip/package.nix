{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  rustc,
  installShellFiles,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "landstrip";
  version = "0.17.38";
  src = fetchFromGitHub {
    owner = "landstrip";
    repo = "landstrip";
    tag = finalAttrs.version;
    hash = "sha256-bNLwiGgDCQmQ4jT30K5vf/0RaOGl/dEggZweE091n8A=";
  };

  cargoHash = "sha256-jR3E6mofsDlAVKW/GnVYE+iLVOW7Rg6/KjwRHkwIMj8=";

  nativeBuildInputs = [ installShellFiles ];
  nativeInstallCheckInputs = [ versionCheckHook ];

  doCheck = false; # Requires permissions
  doInstallCheck = true;

  postInstall = ''
    installManPage ./man/man1/landstrip.1
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/landstrip/landstrip";
    description = "Run tools in OS-level sandboxes";
    mainProgram = "landstrip";
    maintainers = [ lib.maintainers.skyesoss ];
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin ++ lib.platforms.windows;
  };
})
