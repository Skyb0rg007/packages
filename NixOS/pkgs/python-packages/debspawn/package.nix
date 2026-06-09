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
}:
buildPythonPackage (finalAttrs: {
  pname = "debspawn";
  version = "0.6.5";
  pyproject = true;

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

  meta = {
    description = "Debian package builder and build helper using systemd-nspawn";
    homepage = "https://github.com/lkhq/debspawn";
    mainProgram = "debspawn";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.skyesoss ];
  };
})
