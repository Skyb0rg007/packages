{
  lib,
  fetchFromGitHub,
  python3Packages,
  systemd,
  polkit,
  bluez,
  gobject-introspection,
  wrapGAppsHook4,
  libadwaita,
  kdePackages,
}:
python3Packages.buildPythonPackage (finalAttrs: {
  pname = "blueferry";
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "erikwb";
    repo = "blueferry";
    rev = "88054d4a030119410445118769bb8622e578b313";
    hash = "sha256-FH+iBZruUjBoLgwpKRSsR/mCcM5dkbBHnTnkz3Bncmo=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook4
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    libadwaita
    kdePackages.kirigami
    kdePackages.qtdeclarative
  ];

  dependencies = [
    python3Packages.cryptography
    python3Packages.dbus-python
    python3Packages.typer
    python3Packages.textual
    python3Packages.pygobject3
    python3Packages.pyside6
  ];

  postPatch = ''
    substituteInPlace \
      src/blueferry/{bluetooth_capabilities,backend_lifecycle,pair_setup}.py \
      --replace-quiet /usr/bin/systemctl ${lib.getExe' systemd "systemctl"} \
      --replace-quiet /usr/bin/pkexec ${lib.getExe' polkit "pkexec"} \
      --replace-quiet /usr/bin/btmgmt ${lib.getExe' bluez "btmgmt"}
  '';

  postInstall = ''
    mkdir -p $out/share/{systemd/user,dbus-1/services}
    substitute systemd/blueferry.service $out/share/systemd/user/blueferry.service \
      --replace-fail /usr/bin/blueferry $out/bin/blueferry

    substitute packaging/arch/io.weirdware.BlueFerry.service \
      $out/share/dbus-1/services/io.weirdware.BlueFerry.service \
      --replace-fail /usr/bin/blueferry $out/bin/blueferry

    install -Dm644 data/io.weirdware.BlueFerry.xml \
      $out/share/dbus-1/interfaces/io.weirdware.BlueFerry.xml
  '';

  dontWrapGApps = true;
  dontWrapQtApps = true;

  postFixup = ''
    wrapGApp $out/bin/blueferry-gtk
    wrapQtApp $out/bin/blueferry-qt
  '';

  meta = {
    description = "iPhone iMessage/SMS and notifications bridge to Linux over Bluetooth";
    homepage = "https://github.com/erikwb/blueferry";
    license = lib.licenses.gpl2Only;
    mainProgram = "blueferry";
    platforms = lib.platforms.linux;
  };
})
