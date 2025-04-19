{
  lib,
  python3Packages,
  fetchPypi,
  ...
}: let
  version = "1.0.5";

  hatchling = python3Packages.buildPythonPackage rec {
    pname = "hatchling";
    version = "1.26.3";
    pyproject = true;
    src = fetchPypi {
      inherit pname version;
      hash = "sha256-tnKpw2pgGgbE6IoauxMwY57o5yHgU1o3U25UamZ+/Ho=";
    };
    dependencies = with python3Packages; [
      editables
      packaging
      pathspec
      pluggy
      trove-classifiers
    ];
  };

  cloudflare = python3Packages.buildPythonPackage rec {
    pname = "cloudflare";
    version = "4.1.0";
    pyproject = true;
    src = fetchPypi {
      inherit pname version;
      hash = "sha256-a5++mUhW/pQq3GpIgbe+3tIIA03FxT3Wg3UfYy5Hoaw=";
    };
    build-system = with python3Packages; [
      hatchling
      hatch-fancy-pypi-readme
    ];
    dependencies = with python3Packages; [
      httpx
      pydantic
      typing-extensions
      anyio
      distro
      sniffio
    ];
  };
in
python3Packages.buildPythonApplication {
  pname = "anemoi";
  inherit version;
  pyproject = true;
  src = fetchPypi {
    pname = "anemoi_dns";
    inherit version;
    hash = "sha256-/uqIWyy413UFKsZ3z0mESRLhvD04y0ysRhIjh13YwQU=";
  };
  build-system = with python3Packages; [
    setuptools
    setuptools_scm
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
}
