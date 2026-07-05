{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
  installShellFiles,
  nix-update-script,
  testers,
  versionCheckHook,
  nixosTests,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cascade";
  version = "0.1.0-beta4";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = "cascade";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AhArOnYfPY1jl5s8klv7QmeDh9OalofOFrHrEwO9hzg=";
  };

  cargoHash = "sha256-jCY1KZWFf/nT3DHC8qDrgXPavMy46vXeaPftffCYgpA=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];
  nativeInstallCheckInputs = [ versionCheckHook ];
  buildInputs = [ openssl ];

  doInstallCheck = true;

  postInstall = ''
    installManPage ./doc/manual/build/man/*.{1,5}
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version=unstable" ];
    };
    tests.nixos = nixosTests.cascade;
  };

  meta = {
    description = "Friendly DNSSEC signing pipeline";
    mainProgram = "cascade";
    homepage = "https://blog.nlnetlabs.nl/cascade/";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.skyesoss ];
  };
})
