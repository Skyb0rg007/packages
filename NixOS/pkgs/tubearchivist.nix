{
  pkgs,
  lib,
  config,
  ...
}: let
  version = "0.5.0";
  source = pkgs.fetchFromGitHub {
    owner = "tubearchivist";
    repo = "tubearchivist";
    rev = "v0.5.0";
    hash = "sha256-A2aMh+uflAZPKOqoChumVppDu0QDN7/C1BuoUOCPXLY=";
  };

  frontend = pkgs.buildNpmPackage {
    pname = "tubearchivist-frontend";
    inherit version;
    buildInputs = [pkgs.nodejs];
    src = "${source}/frontend";
    npmDepsHash = "sha256-luwl7dolzjXGmUWoB0JbPzQs0NnLVd5I+xeIY2z9u2w=";
    npmBuildScript = "build:deploy";
    installPhase = ''
      mkdir -p $out
      cp -r dist/* $out
    '';
  };

  python = pkgs.python3.override {
    self = python;
    packageOverrides = final: prev: {
      django = prev.django_5;
    };
  };

  pythonEnv = python.withPackages (ps: [
    ps.apprise
    ps.celery
    ps.django-auth-ldap
    ps.django-celery-beat
    ps.django-cors-headers
    ps.django_5
    ps.djangorestframework
    ps.drf-spectacular
    ps.pillow
    ps.redis
    ps.requests
    ps.ryd-client
    ps.uvicorn
    ps.whitenoise
    ps.yt-dlp
  ]);
in
  pkgs.stdenv.mkDerivation {
    pname = "tubearchivist";
    inherit version;
    src = source;

    nativeBuildInputs = [pkgs.makeWrapper];

    buildPhase = ''
      mkdir -p $out/{libexec,share/tubearchivist/static}
      cp -r --no-preserve=mode $src/backend/* $src/LICENSE $out/share/tubearchivist
      cp --no-preserve=mode $src/docker_assets/backend_start.py $src/LICENSE $out/share/tubearchivist
      cp -r --no-preserve=mode ${frontend}/* $out/share/tubearchivist/static

      makeWrapper ${pythonEnv}/bin/python $out/libexec/tubearchivist/manage.py \
        --add-flags $out/share/tubearchivist/manage.py
      makeWrapper ${pythonEnv}/bin/python $out/libexec/tubearchivist/backend_start.py \
        --add-flags $out/share/tubearchivist/backend_start.py
    '';
  }
