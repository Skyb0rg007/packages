{
  lib,
  fetchFromGitHub,
  stdenv,
  pkg-config,
  zlib,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "pdfio";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "michaelrsweet";
    repo = "pdfio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bjmQvcVV+XvuE3Lm0KnOex0OM+p6d7eZK6KLIvWb9UE=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    zlib
  ];

  passthru.tests.pkg-config = testers.hasPkgConfigModules {
    package = finalAttrs.finalPackage;
  };

  meta = {
    homepage = "https://github.com/michaelrsweet/pdfio";
    pkgConfigModules = [ "pdfio" ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    badPlatforms = lib.platforms.darwin;
  };
})
