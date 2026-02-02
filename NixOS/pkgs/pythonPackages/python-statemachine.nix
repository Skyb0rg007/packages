{
  lib,
  buildPythonPackage,
  hatchling,
  pydot,
  fetchPypi,
}:
buildPythonPackage (finalAttrs: {
  pname = "python-statemachine";
  version = "2.5.0";
  pyproject = true;
  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "python_statemachine";
    hash = "sha256-rojNIuR5MLkrmDohduYdgR5XG2mJe+JWjsgSwohfuTo=";
  };
  build-system = [ hatchling ];
  optional-dependencies = {
    diagrams = [ pydot ];
  };
  pythonImportsCheck = [ "statemachine" ];
  meta = {
    description = "An intuitive and powerful state machine library";
    license = lib.licenses.mit;
    homepage = "https://github.com/fgmacedo/python-statemachine";
    changelog = "https://github.com/fgmacedo/python-statemachine/releases";
  };
})
