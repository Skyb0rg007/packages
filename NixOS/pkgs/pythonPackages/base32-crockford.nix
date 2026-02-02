{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,
}:
buildPythonPackage (finalAttrs: {
  pname = "base32-crockford";
  version = "0.3.0";
  pyproject = true;
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-EV9b0yrjK3JANcsC62UGmogk6gjAiFHrgMi59jRDqWk=";
  };
  build-system = [ setuptools ];
  meta = {
    description = "A Python module implementing the alternate base32 encoding described by Douglas Crockford";
    homepage = "https://github.com/jbittel/base32-crockford";
    changelog = "https://github.com/jbittel/base32-crockford#changelog";
    license = lib.licenses.bsd3;
  };
  pythonImportsCheck = [ "base32_crockford" ];
})
