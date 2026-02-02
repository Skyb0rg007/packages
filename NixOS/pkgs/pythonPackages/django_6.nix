{
  argon2-cffi,
  asgiref,
  bcrypt,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
  sqlparse,
}:
buildPythonPackage (finalAttrs: {
  pname = "django";
  version = "6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django";
    repo = "django";
    tag = finalAttrs.version;
    hash = "sha256-n2hOl4WkEXIjQlah6BHMRbg5ECyD3sK1KPw2lo1QYYQ=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    asgiref
    sqlparse
  ];

  optional-dependencies = {
    argon2 = [ argon2-cffi ];
    bcrypt = [ bcrypt ];
  };

  meta = {
    changelog = "https://docs.djangoproject.com/en/6.0/releases/6.0";
    description = "High-level Python Web framework that encourages rapid development and clean, pragmatic design";
    homepage = "https://www.djangoproject.com";
    license = lib.licenses.bsd3;
  };
})
