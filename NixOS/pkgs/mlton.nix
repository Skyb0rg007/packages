{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  pkgs,
  ...
}: let
  version = "20240809";
in
  assert lib.assertMsg stdenv.isLinux "Only Linux for now";
    stdenv.mkDerivation {
      pname = "mlton-dev";
      inherit version;
      src = fetchFromGitHub {
        name = "mlton";
        owner = "MLton";
        repo = "mlton";
        rev = "680bfcc6d6d8df3e51220fd88d297830316b89b4";
        hash = "sha256-5+GafQydWR6blttUYPWf/YwHqH8wzBM8MKTg7MgW2Rg=";
      };
      propagatedBuildInputs = [pkgs.gmp];
      nativeBuildInputs = lib.optional stdenv.isLinux [pkgs.mlton pkgs.patchelf pkgs.makeWrapper];
      makeFlags = [
        "MLTON_VERSION=${version}"
        "WITH_GMP_INC_DIR=${pkgs.gmp.dev}/include"
        "WITH_GMP_LIB_DIR=${pkgs.gmp}/lib"
        "AR=${stdenv.cc.targetPrefix}ar"
        "RANLIB=${stdenv.cc.targetPrefix}ranlib"
        "STRIP=${stdenv.cc.targetPrefix}strip"
        "PREFIX=$(out)"
      ];
      buildPhase = ''
        make $makeFlags CC="$(type -p cc)"
      '';
      patchPhase = ''
        find . -type f ! -name '*.tgz' -exec sed -i "s:/usr/bin/env bash:$(type -p bash):" {} \;
      '';
      postConfigure = ''
        make $makeFlags show-config
      '';
      postFixup = lib.optionalString stdenv.isLinux ''
        for f in lib/mlton/mlton-compile bin/{mllex,mlnlffigen,mlprof,mlyacc}; do
          ${pkgs.patchelf}/bin/patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} $out/$f
          ${pkgs.patchelf}/bin/patchelf --set-rpath ${pkgs.gmp}/lib $out/$f
        done
      '';
    }
