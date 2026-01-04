{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  django,
  django-settings-holder,
}:
buildPythonPackage rec {
  pname = "django-admin-data-views";
  version = "0.4.3";
  pyproject = true;
  src = fetchPypi {
    inherit version;
    pname = "django_admin_data_views";
    hash = "sha256-vSh6XYdP69i1RPg7R9CEb797PgCn9mM5EmMAU8euQpg=";
  };
  build-system = [ poetry-core ];
  dependencies = [
    django
    django-settings-holder
  ];
  pythonImportsCheck = [ "admin_data_views" ];
  meta = {
    description = "Easily add non-model data to the django admin panel";
    homepage = "https://github.com/MrThearMan/django-admin-data-views";
    changelog = "https://github.com/MrThearMan/django-admin-data-views/releases";
    license = lib.licenses.mit;
  };
}
