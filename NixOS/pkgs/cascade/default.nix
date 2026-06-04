{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
  installShellFiles,
  nix-update-script,
  testers,
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
    nixosModule = ../modules/cascade.nix;
    tests.nixos = testers.runNixOSTest {
      imports = [ ../tests/cascade.nix ];
      defaults =
        { pkgs, ... }:
        {
          imports = import ../modules/all-modules.nix;
          environment.systemPackages = [ pkgs.cascade ];
        };
    };
    updateScript = nix-update-script {
      extraArgs = [ "--version=unstable" ];
    };
  };

  meta = {
    description = "Friendly DNSSEC signing pipeline";
    mainProgram = "cascade";
    homepage = "https://blog.nlnetlabs.nl/cascade/";
    license = lib.licenses.bsd3;
    maintainer = [ lib.maintainers.skyesoss ];
  };
})
