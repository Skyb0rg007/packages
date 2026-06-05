{
  lib,
  pkgs,
  fetchFromGitHub,
  buildPythonApplication,
  nix-update-script,
  setuptools,
  xdg-base-dirs,
  pytestCheckHook,
}:
let
  version = "1.1.26";
in
buildPythonApplication {
  pname = "porkbun-ddns";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mietzen";
    repo = "porkbun-ddns";
    rev = "v${version}";
    hash = "sha256-MBqblkT3hDRqInESuvnEZQqgrVe5e4Eq9uemE0f4SYc=";
  };

  build-system = [ setuptools ];
  dependencies = [ xdg-base-dirs ];
  nativeCheckInputs = [ pytestCheckHook ];
  enabledTestPaths = [ "porkbun_ddns/test" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "An unofficial DDNS-Client for Porkbun Domains";
    longDescription = ''
      porkbun-ddns is a unofficial DDNS-Client for Porkbun Domains.
      This library will only update the records if the IP(s) have changed or
      the dns entry didn't exist before, it will also set/update A (IPv4) and
      AAAA (IPv6) records.
    '';
    homepage = "https://github.com/mietzen/porkbun-ddns";
    license = lib.licenses.mit;
    mainProgram = "porkbun-ddns";
  };
}
