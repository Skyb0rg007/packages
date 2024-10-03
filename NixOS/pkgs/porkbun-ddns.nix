{
  lib,
  pkgs,
  fetchFromGitHub,
  python3Packages,
  ...
}:
python3Packages.buildPythonApplication {
  pname = "porkbun-ddns";
  version = "1.1.4-alpha";
  src = fetchFromGitHub {
    owner = "mietzen";
    repo = "porkbun-ddns";
    rev = "92f1434a88071be0ab6b99845e5bff17574b0a3c";
    hash = "sha256-awkEx0wDj/eHUSCRRJSytzMXRWtMewYtGcUT2TmguCY=";
  };
  build-system = [python3Packages.setuptools];
  dependencies = [python3Packages.xdg-base-dirs];
  meta = {
    description = "An unofficial DDNS-Client for Porkbun Domains";
    homepage = "https://github.com/mietzen/porkbun-ddns";
    license = lib.licenses.mit;
  };
}
