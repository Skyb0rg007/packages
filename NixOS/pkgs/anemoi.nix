{
  lib,
  python3Packages,
  fetchPypi,
  ...
}:
python3Packages.buildPythonPackage (finalAttrs: {
  pname = "anemoi";
  version = "1.0.5";
  pyproject = true;
  src = fetchPypi {
    pname = "anemoi_dns";
    inherit (finalAttrs) version;
    hash = "sha256-/uqIWyy413UFKsZ3z0mESRLhvD04y0ysRhIjh13YwQU=";
  };
  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];
  dependencies = with python3Packages; [
    click
    flask
    arrow
    tinydb
    requests
    cloudflare
    bcrypt
    peewee
    psycopg2
    jsonschema
    pyyaml
  ];
  meta = {
    description = "Anemoi is a least privilege dynamic DNS server";
    homepage = "https://github.com/dayt0n/anemoi";
    license = lib.licenses.bsd3;
    mainProgram = "anemoi";
  };
})
