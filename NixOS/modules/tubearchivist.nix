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

    hostName = lib.mkOption {
      type = lib.types.str;
      description = "The hostname to serve the site from";
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.tubearchivist;
    };

    # Settings
    settings = {
      debug = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable additional debugging output. Don't enable in production";
      };
      port = lib.mkOption {
        type = lib.types.port;
        default = 8080;
        description = "The port to listen on for the web interface";
      };
      cacheDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/cache/tubearchivist";
        description = "Directory to use for caching";
      };
      mediaDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/tubearchivist/youtube";
        description = "Directory to store media files";
      };
      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/tubearchivist/staticfiles";
        description = "Directory to hold runtime-generated static content";
      };
      staticAuth = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Use auth_request to validate api routes";
      };
      username = lib.mkOption {
        type = lib.types.str;
        default = "tubearchivist";
        description = "The username";
      };
      password = lib.mkOption {
        type = lib.types.str;
        description = "The password";
      };
      redis.namespace = lib.mkOption {
        type = lib.types.str;
        default = "ta:";
        description = "The Redis namespace to use";
      };
      elasticsearch = {
      };
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.tubearchivist = {
      description = "TubeArchivist, your self hosted YouTube media server";

      environment = {
        # These are used to mutate nginx.conf and thus aren't supported on Nix
        # DISABLE_STATIC_AUTH
        # TA_PORT

        # This setting isn't useful since there isn't any containerization
        # HOST_UID
        # HOST_GUID

        # ENABLE_CAST = "False";
        # TZ = "UTC";
        TA_BACKEND_PORT = "${toString cfg.settings.port}";
        TA_HOST = "https://${cfg.hostName}";

        # Application paths
        TA_MEDIA_DIR = cfg.settings.mediaDir;
        TA_CACHE_DIR = cfg.settings.cacheDir;
        # TODO
        TA_STATIC_ROOT = "/var/lib/tubearchivist/staticfiles";

        # Initial credentials
        TA_USERNAME = cfg.settings.username;
        TA_PASSWORD = cfg.settings.password; # TODO

        # Redis
        REDIS_CON = config.services.redis.servers.tubearchivist.unixSocket;
        REDIS_NAME_SPACE = cfg.settings.redis.namespace;

        # ElasticSearch
        ES_URL = "http://${config.services.elasticsearch.listenAddress}:${toString config.services.elasticsearch.port}";
        ES_PASS = "";
        ES_USER = "elastic";
        ELASTIC_PASSWORD = "";
        ES_SNAPSHOT_DIR = "/var/lib/elasticsearch/data/snapshot";
        ES_DISABLE_VERIFY_SSL = "False";

        DJANGO_DEBUG = lib.mkIf cfg.settings.debug "True";
      };

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/tubearchivist";
        DynamicUser = true;
        StateDirectory = "tubearchivist";
        CacheDirectory = "tubearchivist";
      };
    };

    services.redis.servers.tubearchivist = {
      enable = lib.mkDefault true;
    };

    services.elasticsearch = {
      enable = lib.mkDefault true;
    };

    services.nginx = {
      enable = lib.mkDefault true;
      virtualHosts.${cfg.hostName} = {
        root = "${cfg.package}/share/tubearchivist/static";
        # index = "index.html";
        locations = let
          authRequest = lib.optionalString cfg.settings.staticAuth "auth_request /api/ping/;";
        in {
          "/".tryFiles = "$uri $uri/ /index.html =404";
          "/cache/videos/".extraConfig = ''
            ${authRequest}
            alias /cache/videos/;
          '';
          "/cache/channels/".extraConfig = ''
            ${authRequest}
            alias /cache/channels/;
          '';
          "/cache/playlists/".extraConfig = ''
            ${authRequest}
            alias /cache/playlists/;
          '';
          "/media/".extraConfig = ''
            ${authRequest}
            alias /youtube/;
            types {
              text/vtt vtt;
            }
          '';
          "/youtube/".extraConfig = ''
            ${authRequest}
            alias /youtube/;
            types {
              video/mp4 mp4;
            }
          '';
          "/api" = {
            proxyPass = "http://localhost:${toString cfg.settings.port}";
          };
          "/admin" = {
            proxyPass = "http://localhost:${toString cfg.settings.port}";
          };
          "/static/" = {
            alias = "/var/lib/tubearchivist/staticfiles/";
          };
        };
      };
    };
  };
}
