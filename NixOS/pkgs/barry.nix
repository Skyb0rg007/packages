{
  autoreconfHook,
  config,
  git,
  lib,
  mlkit,
  mlton,
  stdenv,
# installShellFiles,
}:
stdenv.mkDerivation rec {
  pname = "barry";
  inherit (mlkit) src version;

  nativeBuildInputs = [
    autoreconfHook
    mlton
    git
  ];

  buildFlags = [ "barry" ];

  installPhase = ''
    runHook preInstall

    make install_barry

    runHook postInstall
  '';

  checkPhase = ''
    runHook preCheck

    make -C test/barry

    runHook postCheck
  '';

  meta = {
    description = "Standard ML Barifier";
    longDescription = ''
      Barry is a barifier (i.e., simplifier) for Standard ML, based on the
      frontend of the MLKit.
      Barry transforms Standard ML, including Modules, into a subset of
      Core Standard ML.
      Barry has the following features:

      Static interpretation of Modules.
      All Modules language constructs are eliminated by Barry, including
      functors, functor applications, and signature constraints.

      Pattern match compilation.
      Barry transforms complex patterns into simple ones.

      Optimization.
      By default, Barry performs various optimizations, including
      function inlining and specialization of higher-order recursive functions,
      such as map and foldl.
      Optimizations can be controlled using compile-time flags.
    '';
    homepage = "https://elsman.com/mlkit/";
    changelog = "https://github.com/melsman/mlkit/blob/v${version}/NEWS.md";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "barry";
  };
}
