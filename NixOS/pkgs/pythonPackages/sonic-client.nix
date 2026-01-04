{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
}:
buildPythonPackage rec {
  pname = "sonic-client";
  version = "1.0.0";
  pyproject = true;
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/jJMc1RnBIjthIR/amcn08tfs2dcubYTltz1cg5aymY=";
  };
  build-system = [ setuptools ];
  pythonImportsCheck = [ "sonic" ];
  meta = {
    description = "Python client for sonic search backend";
    homepage = "https://github.com/xmonader/python-sonic-client";
    license = lib.licenses.mit;
  };
}
