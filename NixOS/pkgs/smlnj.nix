{
  lib,
  stdenv,
  fetchurl,
  darwin,
}: let
  version = "110.99.7.1";
  baseurl = "https://smlnj.cs.uchicago.edu/dist/working/${version}";

  hashes = builtins.fromJSON (builtins.readFile ./smlnj.json);

  arch =
    if stdenv.hostPlatform.is64bit
    then "64"
    else "32";

  bootSource =
    if stdenv.hostPlatform.is64bit
    then "boot.amd64-unix.tgz"
    else "boot.x86-unix.tgz";
  fetchSource = name: fetchurl { url = "${baseurl}/${name}"; hash = hashes.${name}; };

  sources = map fetchSource [
    bootSource
    "config.tgz"
    "cm.tgz"
    "compiler.tgz"
    "runtime.tgz"
    "system.tgz"
    "MLRISC.tgz"
    "smlnj-lib.tgz"
    "old-basis.tgz"
    "ckit.tgz"
    "nlffi.tgz"
    "cml.tgz"
    "eXene.tgz"
    "ml-lpt.tgz"
    "ml-lex.tgz"
    "ml-yacc.tgz"
    "ml-burg.tgz"
    "pgraph.tgz"
    "trace-debug-profile.tgz"
    "heap2asm.tgz"
    "smlnj-c.tgz"
    "doc.tgz"
    "asdl.tgz"
  ];
in
  stdenv.mkDerivation {
    pname = "smlnj";
    inherit version sources;

    patchPhase =
      ''
        sed -i '/^PATH=/d' config/_arch-n-opsys base/runtime/config/gen-posix-names.sh
        echo SRCARCHIVEURL="file:/$TMP" > config/srcarchiveurl
      ''
      + lib.optionalString stdenv.isDarwin ''
        # Locate standard headers like <unistd.h>
        substituteInPlace base/runtime/config/gen-posix-names.sh \
          --replace "\$SDK_PATH/usr" "${darwin.Libsystem}"
      '';

    unpackPhase = ''
      for s in $sources; do
        b=$(basename $s)
        cp $s ''${b#*-}
        echo "\$b = '$b', \$s = '$s'"
      done
      unpackFile config.tgz
      mkdir base
      ./config/unpack $TMP runtime
    '';

    buildPhase = ''
      ./config/install.sh -default ${arch}
    '';

    installPhase = ''
      mkdir -pv $out
      cp -rv bin lib $out

      cd $out/bin
      for i in *; do
        sed -i "2iSMLNJ_HOME=$out/" $i
      done
    '';

    meta = with lib; {
      description = "Standard ML of New Jersey, a compiler";
      homepage = "http://smlnj.org";
      license = licenses.bsd3;
      platforms = ["x86_64-linux" "i686-linux" "x86_64-darwin" "aarch64-darwin"];
      maintainers = with maintainers; [skyesoss thoughtpolice];
      mainProgram = "sml";
    };
  }
