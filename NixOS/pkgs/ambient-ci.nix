{
  lib,
  fetchgit,
  rustPlatform,
  libisoburn,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ambient-ci";
  version = "0.10.0";

  nativeCheckInputs = [libisoburn];
  src = fetchgit {
    url = "https://radicle.liw.fi/zwPaQSTBX8hktn22F6tHAZSFH2Fh.git";
    hash = "sha256-7T5nkpDL7vaYO8Yl2TP5bIi2r/b0QX9wviOjTfVc7tw=";
  };

  cargoHash = "sha256-6XOYHs6+fZRhyiqTF9Dzz8s5BReY7tzERVNXy4R2xM4=";

  meta = {
    description = "Ambient continuous integration engine";
    homepage = "https://ambient.liw.fi/";
    license = lib.licenses.gpl3Plus;
  };
})
