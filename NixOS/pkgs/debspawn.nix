{
  pkgs,
  lib,
  fetchPypi,
  python3Packages,
  ...
}: let
  version = "0.6.4";
  pname = "debspawn";
in
  python3Packages.buildPythonPackage {
    inherit pname version;
    pyproject = true;
    src = fetchPypi {
      inherit pname version;
      hash = "sha256-hEoWOML5fx9+eNjWNnQAieCsdDtS++Fgpvc4gNvP5WM=";
    };
    build-system = [
      python3Packages.setuptools
      python3Packages.pkgconfig
    ];
    dependencies = [
      python3Packages.tomlkit
      pkgs.debootstrap
    ];
    meta = {
      description = "Debian package builder and build helper using systemd-nspawn";
      homepage = "https://github.com/lkhq/debspawn";
      license = lib.licenses.lgpl3;
      mainProgram = "debspawn";
    };
  }
