{
  lib,
  fetchFromRadicle,
  rustPlatform,
  installShellFiles,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "radicle-ci-ambient";
  version = "0.19.0";

  src = fetchFromRadicle {
    seed = "radicle.liw.fi";
    repo = "z35CgFVYCKpqqDtJMzk8dyE6dViS6"; # radicle-ci-ambient
    node = "z6MkgEMYod7Hxfy9qCvDv5hYHkZ4ciWmLFgfvm3Wn1b2w2FV"; # liw
    tag = "v${finalAttrs.version}";
    hash = "sha256-97O/E4aJ62jmsun1dts5GGYzoOEGqXSv0iHp2ahdO20=";
  };

  cargoHash = "sha256-9p7Kk6Mz2jFK0OutJMxe2RW6SHvI1Z2kANNdvIXYq+k=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage ./radicle-ci-ambient.1
  '';

  meta = {
    description = "Radicle CI adapter for Ambient CI";
    homepage = "https://radicle-ci.liw.fi";
    licenses = [
      lib.licenses.mit
      lib.licenses.asl2
    ];
    maintainers = [ lib.maintainers.skyesoss ];
  };
})
