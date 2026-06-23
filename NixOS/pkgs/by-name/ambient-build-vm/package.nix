{
  lib,
  python3,
  stdenv,
  fetchFromRadicle,
  installShellFiles,
  testers,
}:
let
  python = python3.withPackages (ps: [ ps.pyaml ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ambient-build-vm";
  version = "0.1.0-unstable-2026-06-15";

  src = fetchFromRadicle {
    seed = "radicle.liw.fi";
    repo = "z24yNhQC3JAyE3nbj8PP9SGUk5SgU";
    rev = "b3f98c9d2e60a331ed9f5e07a7e368a843454cf8";
    hash = "sha256-UsynsbD3Zzh+5bdYi+spfnle5ifQU0iZOU0dfA8Obw0=";
  };

  dontConfigure = true;
  dontBuild = true;

  buildInputs = [ python ];
  nativeBuildInputs = [ installShellFiles ];

  # TODO: Substitute vmdb2 and qemu-img
  installPhase = ''
    mkdir -pv \
      $out/share/doc/ambient-build-vm $out/share/ambient-build-vm

    substituteInPlace ambient-build-vm \
      --replace-fail "/usr/share" "$out/share"

    installBin ambient-build-vm
    install -D --mode=644 \
      --target-directory="$out/share/doc/ambient-build-vm" \
      README.md
    install -D --mode=644 \
      --target-directory="$out/share/ambient-build-vm" \
      ambient.service base.vmdb playbook.yml
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = "0.1.0";
  };

  meta = {
    description = "Build VM images for Ambient CI";
    longDescription = ''
      ambient-build-vm creates a virtual machine image for use with
      Ambient, the CI system.
    '';
    mainProgram = "ambient-build-vm";
    homepage = "https://ambient.liw.fi/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.skyesoss ];
  };
})
