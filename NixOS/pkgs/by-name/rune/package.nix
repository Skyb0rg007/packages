{
  lib,
  fetchFromGitHub,
  stdenv,
  gmp,
  python3,
  mlton,
  pkg-config,
  versionCheckHook,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "rune";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "ruudkoot";
    repo = "rune";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3su9s/nxXIzhiiVULTNHkuJI99uDFAPl8RVBJfw1ObM=";
  };

  preBuild = ''
    mkdir -p build
    printf 'structure Config =\nstruct\n  val version = "%s"\n  val identity = ""\nend\n' \
      ${finalAttrs.version} > build/config.sml
    printf '#define RUNE_VERSION "%s"\n' ${finalAttrs.version} > runtime/version.h
  '';

  buildFlags = [
    "all"
    "repl"
    "kernel"
    "dap"
    "heapsim"
  ];

  makeFlags = [
    "MLTON=${lib.getExe' mlton "mlton"}"
    "GMP=yes"
    "DOCTOR=no"
    "JOBS=$(NIX_BUILD_CORES)"
  ];

  nativeBuildInputs = [
    python3
    mlton
    pkg-config
  ];

  buildInputs = [
    gmp
  ];

  installPhase = ''
    runHook preInstall

    sh scripts/install.sh --prefix $out
    install -Dm755 -t $out/bin bin/heapsim bin/heapsim-gen bin/gcsim

    # The wrappers find runevm and lib/rune beside themselves with dirname,
    # which is not on PATH at run time.
    for w in rune rune-repl rune-dap rune-kernel runedoc runeopt; do
      substituteInPlace $out/bin/$w --replace-fail 'd=$(dirname "$0")' "d=$out/bin"
    done

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/ruudkoot/rune";
    description = "Compiler and runtime for Standard ML '97";
    license = lib.licenses.cc0;
    mainProgram = "rune";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
