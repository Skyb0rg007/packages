{
  lib,
  config,
  mlkit,
  git,
  stdenv,
  autoreconfHook,
  mlton,
  ...
}:
stdenv.mkDerivation rec {
  pname = "barry";
  inherit (mlkit) src version;

  nativeBuildInputs = [
    autoreconfHook
    mlton
    git
  ];

  # TODO: Separate docs by writing custom install phase
  outputs = [
    "out"
    "doc"
  ];

  buildFlags = ["barry"];
  installFlags = ["datarootdir=$doc"];
  installTargets = ["install_barry"];

  checkPhase = ''
    runHook preCheck
    make -C test/barry
    runHook postCheck
  '';

  meta = {
    description = "Standard ML Barifier";
    homepage = "https://elsman.com/mlkit/";
    changelog = "https://github.com/melsman/mlkit/blob/v${version}/NEWS.md";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "barry";
  };
}
