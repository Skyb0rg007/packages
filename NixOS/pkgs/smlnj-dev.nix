{
  stdenv,
  fetchurl,
  fetchFromGitHub,
  lib,
  pkgs,
  ...
}: let
  version = "2025.2";
  arch = "amd64";
  opsys = "unix";
  boot = fetchurl {
    url = "https://smlnj.org/dist/working/${version}/boot.${arch}-${opsys}.tgz";
    hash = "sha256-N4EfJcHrco0aB7bAeXnAZzL7naZaM3yKI/U7iuSoMBs=";
  };
  github-source = fetchFromGitHub {
    name = "smlnj";
    owner = "smlnj";
    repo = "smlnj";
    rev = "refs/tags/v2025.2";
    hash = "sha256-TEchaj0YSCK4kCQJNdgvHi83RtCZcRv64RSgYMlpZIY=";
    fetchSubmodules = true;
  };
in
  stdenv.mkDerivation {
    pname = "smlnj-dev";
    sourceRoot = "smlnj";
    srcs = [boot github-source];
    nativeBuildInputs = [pkgs.cmake pkgs.deterministic-uname pkgs.python3 pkgs.time];
    inherit version;

    patchPhase = ''
      sed -i '/^PATH=/d' config/_arch-n-opsys
      # echo SRCARCHIVEURL="file:/$TMP" > config/srcarchiveurl
    '';

    dontConfigure = true;

    buildPhase = ''
      mv ../sml.boot.${arch}-${opsys} .
      ls -la
      echo ---
      ls -la runtime
      ./build.sh -h || true
      ./build.sh
    '';

    installPhase = ''
      mkdir -pv $out
      cp -rv bin lib $out

      cd $out/bin
      for i in *; do
        sed -i "2iSMLNJ_HOME=$out/" $i
      done
    '';
  }
