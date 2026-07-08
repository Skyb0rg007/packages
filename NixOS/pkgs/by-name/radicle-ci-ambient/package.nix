{
  lib,
  fetchFromRadicle,
  rustPlatform,
  installShellFiles,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "radicle-ci-ambient";
  version = "0.20.0";

  src = fetchFromRadicle {
    seed = "radicle.liw.fi";
    repo = "z35CgFVYCKpqqDtJMzk8dyE6dViS6"; # radicle-ci-ambient
    node = "z6MkgEMYod7Hxfy9qCvDv5hYHkZ4ciWmLFgfvm3Wn1b2w2FV"; # liw
    tag = "v${finalAttrs.version}";
    hash = "sha256-TOJeHV0qLxosrgXud40lrjNBBaLSQgNSt9Pnbo+8vHA=";
  };

  cargoHash = "sha256-1ofJDYnLtrrKl5q8T2QME+7GwfR/A7dArHTTQxS5WQg=";

  nativeBuildInputs = [ installShellFiles ];
  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  patchPhase = ''
    runHook prePatch

    substituteInPlace build.rs \
      --replace-fail 'VERSION={}@{hash}' 'VERSION={}'

    runHook postPatch
  '';

  postInstall = ''
    installManPage ./radicle-ci-ambient.1
  '';

  meta = {
    description = "Radicle CI adapter for Ambient CI";
    homepage = "https://radicle-ci.liw.fi";
    mainProgram = "radicle-ci-ambient";
    licenses = [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    maintainers = [ lib.maintainers.skyesoss ];
  };
})
