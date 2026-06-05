{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  nix-update-script,
  testers,
  setuptools,
  setuptools-scm,
  click,
  flask,
  arrow,
  tinydb,
  requests,
  cloudflare,
  bcrypt,
  peewee,
  psycopg2,
  jsonschema,
  pyyaml,
}:
buildPythonPackage (finalAttrs: {
  pname = "anemoi";
  version = "1.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dayt0n";
    repo = "anemoi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V8evm5eNxUhQVY9xvLkq2jLBpLXdTIvcPH/VbIU6+NU=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
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

  pythonImportsCheck = [ "anemoi" ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
  };

  meta = {
    description = "Anemoi is a least privilege dynamic DNS server";
    homepage = "https://github.com/dayt0n/anemoi";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.freebsd;
    mainProgram = "anemoi";
    maintainers = [ lib.maintainers.skyesoss ];
  };
})
