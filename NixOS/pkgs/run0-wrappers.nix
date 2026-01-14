{
  fetchFromGitHub,
  stdenv,
  meson,
  ninja,
  libxslt,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "run0-wrappers";
  version = "0.4.0";
  src = fetchFromGitHub {
    owner = "thkukuk";
    repo = "run0-wrappers";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gkDEIvD+OpQRlBKSrehmyrjC8/ALwMvKrSXNb7XEll8=";
  };
  nativeBuildInputs = [
    meson
    ninja
    libxslt
  ];
  mesonFlags = [
    (lib.mesonEnable "man" false)
    (lib.mesonOption "sysconfdir" "etc")
  ];
})
