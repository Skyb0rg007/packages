{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:
buildPythonPackage rec {
  pname = "django-object-actions";
  version = "5.0.0";
  pyproject = true;
  src = fetchPypi {
    inherit version;
    pname = "django_object_actions";
    hash = "sha256-6kVfdjRDFrYg+BXkEDwPUVFTAXfTUgJoL8FzQCe/ARY=";
  };
  build-system = [ setuptools ];
  meta = {
    description = "Library for writing Django admin object tools";
    homepage = "https://github.com/crccheck/django-object-actions";
    changelog = "https://github.com/crccheck/django-object-actions/releases";
    license = lib.licenses.asl20;
  };
}
