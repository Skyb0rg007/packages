{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  tomlkit,
  apt,
  dpkg,
  zstd,
  util-linux,
  debootstrap,
  pkgconfig,
  python,
  pkgs,
  nix-update-script,
  testers,
}:
buildPythonPackage (finalAttrs: {
  pname = "debspawn";
  version = "0.6.5";
  pyproject = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "lkhq";
    repo = "debspawn";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cDc9xmZZd7cU72HqcNQI1ej6A1GSAmMJiRB6y9WTRoQ=";
  };

  build-system = [
    setuptools
    pkgconfig
  ];

  dependencies = [ tomlkit ];

  postPatch = ''
    substituteInPlace debspawn/dsrun \
      --replace-fail \
        "os.environ['SHELL'] = '/bin/sh'" \
        "os.environ['SHELL'] = '/bin/sh'; os.environ['PATH'] = '/usr/sbin:/usr/bin:/sbin:/bin'"
  '';

  postFixup = ''
    sed -i '1s|.*|#!/usr/bin/python3|' $out/${python.sitePackages}/debspawn/dsrun
  '';

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      pkgs.dpkg
      pkgs.debootstrap
      pkgs.util-linux # findmnt
      pkgs.zstd
      pkgs.systemd # systemd-nspawn
    ])
  ];

  passthru.updateScript = nix-update-script { };

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "Debian package builder and build helper using systemd-nspawn";
    homepage = "https://github.com/lkhq/debspawn";
    mainProgram = "debspawn";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.skyesoss ];
  };
})
