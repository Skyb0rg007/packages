{
  ansible,
  ansible-core,
  ansible-runner,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  lib,
  pip,
  platformdirs,
  pydantic,
  pydantic-core,
  pyinfra,
  typing-extensions,
}:
buildPythonPackage (finalAttrs: {
  pname = "abx-pkg";
  version = "0.6.0";
  pyproject = true;
  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "abx_pkg";
    hash = "sha256-pM6uL/1hnmsNZVb8Hn82Gp710z4Vih2Frjm5dnfcmOo=";
  };
  build-system = [ hatchling ];
  dependencies = [
    pip
    platformdirs
    pydantic-core
    pydantic
    typing-extensions
  ];
  optional-dependencies = {
    pyinfra = [ pyinfra ];
    ansible = [
      ansible
      ansible-core
      ansible-runner
    ];
  };
  pythonImportsCheck = [ "abx_pkg" ];
  meta = {
    description = "Simple Python interfaces for package managers + installed binaries";
    license = lib.licenses.mit;
    homepage = "https://github.com/ArchiveBox/abx-pkg";
    changelog = "https://github.com/ArchiveBox/abx-pkg/releases";
  };
})
