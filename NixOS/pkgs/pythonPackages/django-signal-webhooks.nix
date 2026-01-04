{
  asgiref,
  buildPythonPackage,
  cryptography,
  django,
  django-settings-holder,
  fetchPypi,
  httpx,
  lib,
  poetry-core,
}:
buildPythonPackage rec {
  pname = "django-signal-webhooks";
  version = "0.3.1";
  pyproject = true;
  src = fetchPypi {
    inherit version;
    pname = "django_signal_webhooks";
    hash = "sha256-I9xDm+L96iS3RnJklesaellECAkFZILuvOsVPQUKP1s=";
  };
  build-system = [ poetry-core ];
  dependencies = [
    django
    asgiref
    cryptography
    django-settings-holder
    httpx
  ];
  # pythonImportsCheck = [ "signal_webhooks" ];
  meta = {
    description = "Library for adding webhooks to a Django project";
    homepage = "https://github.com/MrThearMan/django-signal-webhooks/";
    changelog = "https://github.com/MrThearMan/django-signal-webhooks/releases";
    license = lib.licenses.mit;
  };
}
