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
    rev = "531d239234b76a41425fca51a2c3ed0244a2ae68";
    hash = "sha256-p3DPVS/c0qQr2mCL7zS7UV0jr+aYum5mSgDzaNAjy2s=";
  };
  build-system = [python3Packages.setuptools];
  dependencies = [python3Packages.xdg-base-dirs];
  meta = {
    description = "An unofficial DDNS-Client for Porkbun Domains";
    homepage = "https://github.com/mietzen/porkbun-ddns";
    license = lib.licenses.mit;
  };
}
