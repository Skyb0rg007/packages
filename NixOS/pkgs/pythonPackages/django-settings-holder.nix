{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  django,
}:
buildPythonPackage (finalAttrs: {
  pname = "django-settings-holder";
  version = "0.3.0";
  pyproject = true;
  src = fetchPypi {
    pname = builtins.replaceStrings [ "-" ] [ "_" ] finalAttrs.pname;
    inherit (finalAttrs) version;
    hash = "sha256-1B621gI9YcCOOV8kBv1vBH0e3/LwNG0EMj82gfEjcu8=";
  };
  build-system = [ poetry-core ];
  dependencies = [ django ];
  pythonImportsCheck = [ "settings_holder" ];
  meta = {
    description = "Django extensions utility for defining settings dictionaries";
    homepage = "https://github.com/MrThearMan/django-settings-holder";
    changelog = "https://github.com/MrThearMan/django-settings-holder/releases";
    license = lib.licenses.mit;
  };
})
