{
  lib,
  fetchFromGitHub,
  fetchNpmDeps,
  npmHooks,
  cypress,
  nodejs,
  php,
  ...
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "cdash";
  version = "4.7.0";

  src = fetchFromGitHub {
    owner = "Kitware";
    repo = "CDash";
    rev = "v${finalAttrs.version}";
    hash = "sha256-HxcSyIuDXwBxEYdGdkTtRz1iR7kBvobzaxwjXFZCnks=";
  };

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-nZa+jnjuD+Q7uxWdIp/Zp4nfHlNgfdX7egAdQBkvqZg=";
  };

  env = {
    CYPRESS_INSTALL_BINARY = "0";
    CYPRESS_RUN_BINARY = lib.getExe cypress;
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  postBuild = ''
    npm run prod
  '';

  postInstall = ''
    mkdir -p $out/bin
    cat > $out/bin/artisan << EOF
    #!/bin/sh
    export QUEUE_CONNECTION="\''${QUEUE_CONNECTION-sync}"
    export LARAVEL_STORAGE_PATH="\''${LARAVEL_STORAGE_PATH-"\$STATE_DIRECTORY"}"
    export APP_SERVICES_CACHE="\$LARAVEL_STORAGE_PATH/bootstrap/cache/services.php"
    export APP_PACKAGES_CACHE="\$LARAVEL_STORAGE_PATH/bootstrap/cache/packages.php"
    export APP_CONFIG_CACHE="\$LARAVEL_STORAGE_PATH/bootstrap/cache/config.php"
    export APP_ROUTES_CACHE="\$LARAVEL_STORAGE_PATH/bootstrap/cache/routes.php"
    export APP_EVENTS_CACHE="\$LARAVEL_STORAGE_PATH/bootstrap/cache/events.php"
    export LIGHTHOUSE_SCHEMA_CACHE_PATH="\$LARAVEL_STORAGE_PATH/bootstrap/cache/lighthouse-schema.php"
    exec $out/share/php/cdash/artisan "\$@"
    EOF
    chmod +x $out/bin/artisan
  '';

  php = php.buildEnv {
    extensions = {
      enabled,
      all,
    }:
      enabled ++ [all.xsl];
  };
  vendorHash = "sha256-Y1T+X4kOPB1k/sgxV9zXctaRR9oSAEQ+M7bB7eRumlU=";
})
