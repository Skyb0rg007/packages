{
  lib,
  python3,
  stdenv,
  fetchFromRadicle,
  installShellFiles,
}: let
  python = python3.withPackages (ps: [ps.pyaml]);
in
  stdenv.mkDerivation {
    pname = "ambient-build-vm";
    version = "0.1-f0035a9";

    src = fetchFromRadicle {
      seed = "radicle.liw.fi";
      repo = "z24yNhQC3JAyE3nbj8PP9SGUk5SgU";
      rev = "f0035a9e714319145b85bdaf1e60867ee4ce8368";
      hash = "sha256-JThhJToo0OR0JdLvyU0lWwQh5xLuDiY40q6F5Tu4/Zw=";
    };

    dontConfigure = true;
    dontBuild = true;

    buildInputs = [python];
    nativeBuildInputs = [installShellFiles];

    # TODO: Substitute vmdb2 and qemu-img
    installPhase = ''
      mkdir -pv \
        $out/share/doc/ambient-build-vm $out/share/ambient-build-vm

      substituteInPlace ambient-build-vm \
        --replace-fail "/usr/share" "$out/share"

      installBin ambient-build-vm
      install -D --mode=755 \
        --target-directory="$out/share/doc/ambient-build-vm" \
        README.md
      install -D --mode=755 \
        --target-directory="$out/share/ambient-build-vm" \
        ambient.service base.vmdb playbook.yml
    '';

    meta = {
      description = "Build VM images for Ambient CI";
      longDescription = ''
        ambient-build-vm creates a virtual machine image for use with
        Ambient, the CI system.
      '';
      mainProgram = "ambient-build-vm";
      homepage = "https://ambient.liw.fi/";
      license = lib.licenses.gpl3Plus;
    };
  }
