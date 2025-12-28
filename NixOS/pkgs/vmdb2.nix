{
  lib,
  fetchFromRadicle,
  stdenv,
  python3Packages,
}:
python3Packages.buildPythonApplication {
  pname = "vmdb2";
  version = "0.41";
  pyproject = true;

  build-system = [ python3Packages.setuptools ];
  dependencies = [
    python3Packages.jinja2
    python3Packages.pyaml
  ];

  src = fetchFromRadicle {
    seed = "radicle.liw.fi";
    repo = "z2kxCtBwDQMPcaf9vGTNH5nYkp9qk";
    rev = "bb7c44a18d7aa31f1446da8b4974674fcf4e28cc";
    hash = "sha256-xaeSus1nWOhcTmxL3mZzZQAGcQoiiVxyYwMjlwmRr5Q=";
  };

  meta = {
    description = "Debian virtual machine image builder";
    longDescription = ''
      vmdb2 is a program for producing a disk image with Debian installed.
    '';
    mainProgram = "vmdb2";
    homepage = "https://vmdb2.liw.fi/";
    license = lib.licenses.gpl3Plus;
  };
}
