{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.services.tubearchivist;
in {
  options.services.tubearchivist = {
    enable = lib.mkEnableOption "TubeArchivist, a self hosted YouTube media server";

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "The port to bind to";
    };

    mediaDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/tubearchivist/youtube";
      description = "The media directory";
    };

    hostName = lib.mkOption {
      type = lib.types.str;
      description = "The hostname to serve the site from";
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.tubearchivist;
    };

    debug = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable additional debugging output";
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.tubearchivist = {
      description = "TubeArchivist, your self hosted YouTube media server";

      environment = {
        # HOST_UID = "False";
        # HOST_GUID = "False";
        # ENABLE_CAST = "False";
        # DISABLE_STATIC_AUTH = "False";
        # TZ = "UTC";
        TA_BACKEND_PORT = "${toString cfg.port}";
        TA_HOST = "https://${cfg.hostName}";

        # Application paths
        TA_MEDIA_DIR = cfg.mediaDir;
        TA_APP_DIR = "/var/lib/tubearchivist/app";
        TA_CACHE_DIR = "/var/cache/tubearchivist";

        # Redis
        REDIS_CON = config.services.redis.servers.tubearchivist.unixSocket;
        # REDIS_NAME_SPACE = "ta:";

        # ElasticSearch
        ES_URL = "";
        ES_PASS = "";
        ES_USER = "elastic";
        ES_SNAPSHOT_DIR = "/var/lib/elasticsearch/data/snapshot";
        ES_DISABLE_VERIFY_SSL = "False";

        DJANGO_DEBUG = lib.mkIf cfg.debug "True";
      };

      preStart = ''
        if [ ! -e "$TA_APP_DIR/static" ]; then
          mkdir -p "$TA_APP_DIR"
          ln -s ${cfg.package}/share/tubearchivist/* "$TA_APP_DIR"
          mkdir "$TA_APP_DIR/staticfiles"
        fi
      '';

      script = ''
        ${cfg.package}/libexec/tubearchivist/manage.py ta_stop_on_error

        ${cfg.package}/libexec/tubearchivist/manage.py migrate
        ${cfg.package}/libexec/tubearchivist/manage.py collectstatic --noinput -c

        ${cfg.package}/libexec/tubearchivist/manage.py ta_envcheck
        ${cfg.package}/libexec/tubearchivist/manage.py ta_connection
        ${cfg.package}/libexec/tubearchivist/manage.py ta_startup

        ${cfg.package}/libexec/tubearchivist/backend_start.py
      '';

      serviceConfig = {
        DynamicUser = true;
        StateDirectory = "tubearchivist";
        CacheDirectory = "tubearchivist";
      };
    };

    services.redis.servers.tubearchivist = {
      enable = lib.mkDefault true;
    };

    services.nginx = {
      enable = lib.mkDefault true;
      virtualHosts.${cfg.hostName} = {
        root = "${cfg.package}/share/tubearchivist/static";
        # index = "index.html";
        locations = {
          "/".tryFiles = "$uri $uri/ /index.html =404";
          "/cache/videos/".extraConfig = ''
            auth_request /api/ping/;
            alias /cache/videos/;
          '';
          "/cache/channels/".extraConfig = ''
            auth_request /api/ping/;
            alias /cache/channels/;
          '';
          "/cache/playlists/".extraConfig = ''
            auth_request /api/ping/;
            alias /cache/playlists/;
          '';
          "/media/".extraConfig = ''
            auth_request /api/ping/;
            alias /youtube/;
            types {
              text/vtt vtt;
            }
          '';
          "/youtube/".extraConfig = ''
            auth_request /api/ping/;
            alias /youtube/;
            types {
              video/mp4 mp4;
            }
          '';
          "/api" = {
            proxyPass = "http://localhost:${toString cfg.port}";
          };
          "/admin" = {
            proxyPass = "http://localhost:${toString cfg.port}";
          };
          "/static/" = {
            alias = "/app/staticfiles/";
          };
        };
      };
    };
  };
}
