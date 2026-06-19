{
  lib,
  rustPlatform,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  dbus,
  udev,
  gtk4,
  pcsclite,
  libnfc,
  openssl,
  meson,
  ninja,
  rustc,
  cargo,
  wrapGAppsHook4,
  desktop-file-utils,
  libxml2,
  kdePackages,
  zip,
  libclang,
  blueprint-compiler,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "credentialsd";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "linux-credentials";
    repo = "credentialsd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7rXO0ZYCf84BE9ZBx4zYwgrd4xR1gv0vtRuxTqvBMQ4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-ugb671Wxlx6T12sX+j/Wj9+mOO3mbfFebN5AGKmb7gI=";
  };

  env.LIBCLANG_PATH = lib.makeLibraryPath [ libclang ];

  nativeBuildInputs = [
    meson
    ninja
    rustPlatform.cargoSetupHook
    rustPlatform.bindgenHook
    rustc
    cargo
    wrapGAppsHook4
    pkg-config
    blueprint-compiler
    desktop-file-utils
    kdePackages.appstream-qt
    libxml2
    zip
  ];

  buildInputs = [
    dbus
    gtk4
    libnfc
    openssl
    pcsclite
    udev
  ];

  meta = {
    description = "Linux Credential Manager API";
    homepage = "https://github.com/linux-credentials/credentialsd";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
  };
})
