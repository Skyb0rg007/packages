{
  lib,
  pkgs,
  fetchurl,
  python3Packages,
  ...
}: let
  version = "1.1.14";
in
  python3Packages.buildPythonApplication {
    pname = "porkbun-ddns";
    inherit version;
    src = fetchurl {
      url = "https://github.com/mietzen/porkbun-ddns/archive/refs/tags/v${version}.tar.gz";
      hash = "sha256-DFlGUA7+lh0JJBTEDKVPchfXsVK5C2wCMh6bMnqrZn8=";
    };
    pyproject = true;
    build-system = [python3Packages.setuptools];
    dependencies = [python3Packages.xdg-base-dirs];
    nativeCheckInputs = [python3Packages.pytestCheckHook];
    enabledTestPaths = ["porkbun_ddns/test"];
    meta = {
      description = "An unofficial DDNS-Client for Porkbun Domains";
      homepage = "https://github.com/mietzen/porkbun-ddns";
      license = lib.licenses.mit;
      mainProgram = "porkbun-ddns";
    };
  }
