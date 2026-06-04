{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.cascade;

  format = lib.formats.toml { };

  configFile = format.generate "cascade.toml" cfg.settings;
  hsmConfigFile = format.generate "cascade-hsm-bridge.toml" cfg.hsm-bridge.settings;
in
{
  options.services.cascade = {
    enable = lib.mkEnableOption "cascade";
    package = lib.mkPackageOption pkgs "cascade" { };
    dnstPackage = lib.mkPackageOption pkgs "dnst" { };
    settings = lib.mkOption {
      inherit (format) type;
      default = {
        version = "v1";
        policy-dir = "/etc/cascade/policies";
        zone-state-dir = "/var/lib/cascade/zone-state";
        tsig-store-path = "/var/lib/cascade/tsig-keys.db";
        kmip-credentials-store-path = "/var/lib/cascade/kmip/credentials.db";
        keys-dir = "/var/lib/cascade/keys";
        kmip-server-state-dir = "/var/lib/cascade/kmip";
        dnst-binary-path = "dnst";

        daemon = {
          log-level = "info";
          log-target.type = "syslog";
          daemonize = false;
        };

        remote-control.servers = [
          "127.0.0.1:4539"
          "[::1]:4539"
        ];

        loader.review.servers = [
          "127.0.0.1:4540"
          "[::1]:4540"
        ];

        signer.review.servers = [
          "127.0.0.1:4541"
          "[::1]:4541"
        ];

        server.servers = [
          "127.0.0.1:4542"
          "[::1]:4542"
        ];
      };
    };
    hsm-bridge = {
      enable = lib.mkEnableOption "cascade-hsm-bridge";
      package = lib.mkPackageOption pkgs "cascade-hsm-bridge" { };
      settings = lib.mkOption {
        inherit (format) type;
        default = {
          version = "v1";
          pkcs11.lib-path = "";
          daemon = {
            log-level = "info";
            log-target.type = "syslog";
            daemonize = false;
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.cascaded = {
      description = "Cascade DNSSEC Signer";
      documentation = "man:cascade(1)";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ cfg.dnstPackage ];
      serviceConfig = {
        Type = "exec";
        ExecStart = "${lib.getExe' cfg.package "cascaded"} --state=\${STATE_DIRECTORY}/state.db --config=${configFile}";
        ConfigurationDirectory = "cascade";
        StateDirectory = "cascade";
        Restart = "on-failure";
        DynamicUser = true;

        # Hardening
        LockPersonality = true;
        PrivateTmp = true;
        MemoryDenyWriteExecute = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        NoNewPrivileges = true;
        ProtectHome = true;
        ProtectSystem = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        RestrictRealtime = true;
        SystemCallFilter = "@system-service";
        SystemCallErrorNumber = "EPERM";
        SystemCallArchitectures = "native";
      };
    };

    systemd.services.cascade-hsm-bridge = lib.mkIf cfg.hsm-bridge.enable {
      description = "A KMIP to PKCS#11 bridge";
      documentation = "man:cascade-hsm-bridge(1)";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "exec";
        ExecStart = "${lib.getExe cfg.hsm-bridge.package} --config=${hsmConfigFile}";
        Restart = "on-failure";
        DynamicUser = true;
        # XXX: CAP_DAC_OVERRIDE?
      };
    };
  };
}
