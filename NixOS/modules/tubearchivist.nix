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
        TA_PORT = "${toString cfg.port}";

        # Application paths
        TA_MEDIA_DIR = "${cfg.mediaDir}";
        TA_APP_DIR = "${cfg.package}/share/tubearchivist";
        TA_CACHE_DIR = "/var/cache/tubearchivist";

        # Redis
        REDIS_CON = config.services.redis.tubearchivist.unixSocket;
        # REDIS_NAME_SPACE = "ta:";

        # ElasticSearch
        ES_URL = "";
        ES_PASS = "";
        ES_USER = "elastic";
        ES_SNAPSHOT_DIR = "/var/lib/elasticsearch/data/snapshot";
        ES_DISABLE_VERIFY_SSL = "False";
      };

      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${cfg.package}/libexec/tubearchivist/backend_start.py";
        StateDirectory = "tubearchivist";
      };
    };

    services.redis.servers.tubearchivist = {
      enable = lib.mkDefault true;
    };

    services.nginx = {
      enable = lib.mkDefault true;
      virtualHosts.${cfg.hostName} = {
        root = "${cfg.package}/share/tubearchivist/static";
        index = "index.html";
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
              text/vtt vtt;
            }
          '';
          "/api" = {
            proxyPass = "http://localhost:${cfg.port}";
          };
          "/admin" = {
            proxyPass = "http://localhost:${cfg.port}";
          };
          "/static/".alias = "/app/staticfiles/";
        };
      };
    };
  };
}
