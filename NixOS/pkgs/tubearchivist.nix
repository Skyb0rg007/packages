{
  pkgs,
  lib,
  config,
  ...
}: let
  version = "0.4.14alpha";
  source = pkgs.fetchFromGitHub {
    owner = "tubearchivist";
    repo = "tubearchivist";
    rev = "dfddf8cb4d24c172fd1d9ee8724869e1d60a1c1e";
    hash = "sha256-JUUODzx/v6KdbfjxvLUi0PLk2vZjCw4Gm5fW3a1USw0=";
  };

  frontend = pkgs.buildNpmPackage {
    pname = "tubearchivist-frontend";
    inherit version;
    buildInputs = [pkgs.nodejs];
    src = "${source}/frontend";
    npmDepsHash = "sha256-KQ328ju4bCicpZeDILyW1U9Ac/tzFZyq5DXm/74kEP8=";
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
