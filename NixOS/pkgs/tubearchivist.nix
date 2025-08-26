{
  pkgs,
  lib,
  config,
  ...
}: let
  version = "0.5.7";
  source = pkgs.fetchFromGitHub {
    owner = "tubearchivist";
    repo = "tubearchivist";
    rev = "v${version}";
    hash = "sha256-fmsRzR5GRA5pEBHuRwiysvIieTOaQYhEYJjg7l5jm2c=";
  };

  frontend = pkgs.buildNpmPackage {
    pname = "tubearchivist-frontend";
    inherit version;
    buildInputs = [pkgs.nodejs];
    src = "${source}/frontend";
    npmDepsHash = "sha256-tyTg8wsNyWs54OqW2mbnXlrnBi8BGfG0Ja2+JD1c5ds=";
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

    patchPhase = ''
    '';

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

      # Disable writing to the NGINX config
      sed --in-place \
        --expression='s/self\._disable_static_auth/# &/' \
        --expression='s/self\._ta_[a-z_]*_overwrite/# &/' \
        $out/share/tubearchivist/config/management/commands/ta_envcheck.py

      sed --in-place \
        --expression='s:^STATIC_ROOT\s*=.*:STATIC_ROOT = environ.get("TA_STATIC_ROOT"):' \
        --expression='s:^STATICFILES_DIRS\s*=.*:STATICFILES_DIRS = ("${frontend}",):' \
        $out/share/tubearchivist/config/settings.py

      sed --in-place \
        '1i cd "$(dirname "$0")"' \
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
