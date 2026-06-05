{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
  installShellFiles,
  nix-update-script,
  testers,
  nixosTests,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cascade";
  version = "0.1.0-alpha5";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = "cascade";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i3eKuiZj6fVUxTLLVI75BG+rwh35pjiqPJHelS65ueU=";
  };

  cargoHash = "sha256-0Vpa4C5dNZMLAuOffenK4F9cFaFdRlAsqaDu4oeRScs=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];
  buildInputs = [ openssl ];

  postInstall = ''
    installManPage ./doc/manual/build/man/*.{1,5}
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version=unstable" ];
    };
    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
      };
      nixos = nixosTests.cascade;
    };
  };

  meta = {
    description = "Friendly DNSSEC signing pipeline";
    mainProgram = "cascade";
    homepage = "https://blog.nlnetlabs.nl/cascade/";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.skyesoss ];
  };
})
