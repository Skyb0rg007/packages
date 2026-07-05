{
  lib,
  fetchFromGitLab,
  rustPlatform,
  autoPatchelfHook,
  capnproto,
  desktop-file-utils,
  mold,
  pkg-config,
  wrapGAppsHook4,
  gtk4,
  libadwaita,
  nettle,
  openssl,
  pcsclite,
  sqlite,
  wayland,
  libxkbcommon,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sequin";
  version = "0-unstable-2026-06-30";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = "Sequin";
    rev = "7a267cad71134c9cd7ef4a6ae994a6b6f7f393be";
    hash = "sha256-dwf17ZdASFvYVXkOvnmv2Jvhx0plrYpQ91h9UeuESBI=";
  };

  cargoHash = "sha256-jE6Zr2osIHOL6CGW8VRXX5Ii8soWD63CgE90EC6PpQg=";

  nativeBuildInputs = [
    autoPatchelfHook
    rustPlatform.bindgenHook
    wrapGAppsHook4
    capnproto
    desktop-file-utils
    mold
    pkg-config
  ];
  buildInputs = [
    gtk4
    libadwaita
    nettle
    openssl
    openssl
    pcsclite
    sqlite
  ];
  runtimeDependencies = [
    libxkbcommon
    wayland
  ];

  meta = {
    description = "Contact-centric PGP certificate manager built on Sequoia";
    homepage = "https://gitlab.com/sequoia-pgp/sequin";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "sequin";
    maintainers = [ lib.maintainers.skyesoss ];
  };
})
