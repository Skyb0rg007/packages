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
  pname = "smltojs";
  inherit (mlkit) src version;

  nativeBuildInputs = [
    autoreconfHook
    mlton
    git
  ];

  buildPhase = ''
    runHook preBuild

    make smltojs
    make smltojs_basislibs

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    make install_smltojs

    runHook postInstall
  '';

  checkPhase = ''
    runHook preCheck

    make -C js/test all

    runHook postCheck
  '';

  meta = {
    description = "Standard ML to JavaScript compiler";
    longDescription = ''
      SMLtoJs (pronounced "SML toys") is a compiler from Standard ML to
      JavaScript, which allows programmers to enjoy the power of Standard ML
      static typing, higher-order functions, pattern matching, and modules
      for programming client-side web applications.

      SMLtoJs compiles all of Standard ML, including most of the Standard ML
      Basis Library.
      It also has good support for integrating with JavaScript.

      SMLtoJs supports the following features:

      * All of Standard ML. SMLtoJs has support for all of Standard ML,
        including modules, pattern matching, higher-order functions,
        generative exceptions, etc.

      * Standard ML Basis Library support. SMLtoJs has support for most of
        the Standard ML basis library, including the following structures:

            Array2 ArraySlice Array Bool Byte Char CharArray CharArraySlice
            CharVector CharVectorSlice Date General Int Int31 Int32 IntInf
            LargeWord ListPair List Math Option OS.Path Pack32Big
            Pack32Little Random Real StringCvt String Substring Text Time
            Timer Vector VectorSlice Word Word31 Word32 Word8 Word8Array
            Word8ArraySlice Word8Vector Word8VectorSlice

      * JavaScript integration.
        SMLtoJs has support for calling JavaScript functions and for executing
        JavaScript statements.

      * Simple DOM access support and support for installing Standard ML
        functions as DOM event handlers and timer call back functions.

      * Optimization.
        All Modules language constructs, including functors,
        functor applications, and signature constraints, are eliminated by
        SMLtoJs at compile time.
        Moreover, SMLtoJs performs a series of compile time optimizations,
        including function inlining and specialization of higher-order
        recursive functions, such as map and foldl. Optimizations can be
        controlled using compile-time flags.
        As a result, SMLtoJs generates fairly efficient JavaScript
        code, although there are rooms for improvements; see below.

      * Compiling in the Browser.
        A version of SMLtoJs can be compiled by SMLtoJs itself,
        which leads to a proper browser hosted Standard ML compiler.
    '';
    homepage = "https://elsman.com/mlkit/";
    changelog = "https://github.com/melsman/mlkit/blob/v${version}/NEWS.md";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "smltojs";
  };
}
