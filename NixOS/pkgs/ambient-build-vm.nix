{
  lib,
  python3,
  stdenv,
  fetchFromRadicle,
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

    # TODO: Substitute vmdb2 and qemu-img
    installPhase = ''
      mkdir -pv $out/bin \
        $out/share/doc/ambient-build-vm $out/share/ambient-build-vm

      substituteInPlace ambient-build-vm \
        --replace-fail "/usr/share" "$out/share"

      cp ambient-build-vm $out/bin
      cp README.md $out/share/doc/ambient-build-vm
      cp ambient.service base.vmdb playbook.yml $out/share/ambient-build-vm
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
