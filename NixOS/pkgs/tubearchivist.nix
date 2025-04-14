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

    # Override the /app/static path with the Nix path to the frontend
    # Also allow the STATIC_ROOT property to be set
    # through the environment variable TA_STATIC_ROOT
    installPhase = ''
      mkdir -p $out/{bin,share/tubearchivist}
      cp -r --no-preserve=mode \
        $src/backend/* \
        $src/docker_assets/run.sh \
        $src/docker_assets/backend_start.py \
        $out/share/tubearchivist
      chmod +x $out/share/tubearchivist/run.sh

      sed --in-place \
        --expression='s:^STATIC_ROOT\s*=.*:STATIC_ROOT = environ.get("TA_STATIC_ROOT"):' \
        --expression='s:^STATICFILES_DIRS\s*=.*:STATICFILES_DIRS = ("${frontend}",):' \
        $out/share/tubearchivist/config/settings.py

      sed --in-place \
        '1i cd "$(basename "$0")"' \
        $out/share/tubearchivist/run.sh
      makeWrapper $out/share/tubearchivist/run.sh $out/bin/tubearchivist \
        --prefix PATH : ${pythonEnv}/bin \
        --set TA_APP_DIR $out/share/tubearchivist
    '';

    meta = {
      description = "Your self hosted YouTube media server";
      homepage = "https://tubearchivist.com";
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.linux;
    };
  }
