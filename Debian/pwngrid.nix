{
  pkgs,
  lib,
  fetchFromGitHub,
}:
pkgs.releaseTools.debBuild {
  diskImage = pkgs.vmTools.diskImageFuns.ubuntu2404x86_64 {};
  diskImageFormat = "qcow2";
  name = "pwngrid-deb";
  src = pkgs.fetchFromGitHub {
    owner = "jayofelony";
    repo = "pwngrid";
    rev = "0f1f46c8b993a51c19764e9b2aaf590545e86579";
    hash = "sha256-qswm/eJ/2ayLRxEymcHoJEIO6ikKsaHn/Jw6jgfai5s=";
  };
  buildInputs = [];
  meta = {
    description = "API server for pwnagotchi.ai";
    homepage = "https://github.com/jayofelony/pwngrid";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}
