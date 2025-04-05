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
    # owner = "mietzen";
    owner = "Skyb0rg007";
    repo = "porkbun-ddns";
    rev = "c7cfab36c3cf9a013ec1418d904ff5117290d017";
    hash = "sha256-9ofhjN3gDilRmHLt5sIbyip85mWWCEXnKLYmO/skuik=";
  };
  build-system = [python3Packages.setuptools];
  dependencies = [python3Packages.xdg-base-dirs];
  meta = {
    description = "An unofficial DDNS-Client for Porkbun Domains";
    homepage = "https://github.com/mietzen/porkbun-ddns";
    license = lib.licenses.mit;
  };
}
