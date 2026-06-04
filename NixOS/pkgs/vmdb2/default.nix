{
  lib,
  fetchFromRadicle,
  stdenv,
  python3Packages,
}:
python3Packages.buildPythonApplication (finalAttrs: {
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
    node = "z6MkgEMYod7Hxfy9qCvDv5hYHkZ4ciWmLFgfvm3Wn1b2w2FV";
    tag = "vmdb2-${finalAttrs.version}";
    hash = "sha256-XHcOKsKEIxHzm66iVfK0QoVYqIo79Je1Kq/tqyzdWEE=";
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
})
