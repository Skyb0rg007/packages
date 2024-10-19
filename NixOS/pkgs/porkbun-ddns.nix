{
  lib,
  pkgs,
  fetchFromGitHub,
  python3Packages,
  ...
}:
python3Packages.buildPythonApplication {
  pname = "porkbun-ddns";
  version = "1.1.8";
  src = fetchFromGitHub {
    owner = "mietzen";
    repo = "porkbun-ddns";
    rev = "558edfee4a8ae3f0e8052cf6ed2a0afdf8ce0084";
    hash = "sha256-HWHglpz/rRoLP4opMsraZeQ0gPA8MaQTmNUuodZ+eyY=";
  };
  build-system = [python3Packages.setuptools];
  dependencies = [python3Packages.xdg-base-dirs];
  meta = {
    description = "An unofficial DDNS-Client for Porkbun Domains";
    homepage = "https://github.com/mietzen/porkbun-ddns";
    license = lib.licenses.mit;
  };
}
