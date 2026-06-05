{
  lib,
  rustPlatform,
  buildNpmPackage,
  fetchzip,
  fetchurl,
  runCommand,
  fetchFromGitHub,
  withHyperlight ? true,
  withMicrovm ? true,
  lxc,
}:
let
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "mxc";
    tag = "v${version}";
    hash = "sha256-PBnhEwA94TqynLhUzRJwhdzIXk6uGjZSDzgQN0agd0M=";
  };

  meta = {
    description = "Sandboxed code execution system for running untrusted code";
    homepage = "https://github.com/microsoft/mxc";
    license = lib.licenses.mit;
    # TODO
    platforms = [ "x86_64-linux" ] ++ lib.platforms.darwin;
    badPlatforms = lib.platforms.darwin;
    maintainers = [ lib.maintainers.skyesoss ];
  };

  lxcPackages = lib.map (p: "--package=${p}") [
    "lxc"
    "lxc_common"
    "wxc_common"
    "bwrap_common"
    "linux_test_proxy"
  ];
  buildFeatures = lib.optional withHyperlight "hyperlight" ++ lib.optional withMicrovm "microvm";

  # Nanvix - taken from ./src/backends/nanvix/binaries/versions.json
  # XXX: Some of these fields are unused in the build
  nanvixVersions = {
    tag = "3.12.3-nanvix-0.15.4-ac76d40";
    asset = "microvm-standalone-256mb.zip";
    asset_linux = "microvm-standalone-256mb.tar.gz";
    binaries = [
      "nanvixd.exe"
      "nanvix_rootfs.img"
      "python3.initrd"
    ];
    binaries_linux = [
      "nanvixd.elf"
      "nanvix_rootfs.img"
      "python3.initrd"
    ];
  };

  nanvixLinux = fetchzip {
    url = "https://github.com/nanvix/nanvix-python/releases/download/${nanvixVersions.tag}/${nanvixVersions.asset_linux}";
    hash = "sha256-WkqLdz1ttxe5MVYJHRJunoneEiUESfDDpmw4HxqMndc=";
  };

  lxc-exec = rustPlatform.buildRustPackage {
    pname = "lxc-exec";
    inherit src version;

    sourceRoot = "${src.name}/src";

    cargoHash = "sha256-sGqKQ4d5OmLTYKEoWawcpOJO8TKP3pE2gHKTHMUrTh8=";

    buildInputs = [
      lxc
    ];

    patchPhase = ''
      runHook prePatch

      export NANVIX_OUT_DIR="$TMPDIR"

      mkdir -pv "$NANVIX_OUT_DIR/nanvix-binaries/bin"

      cp -v ${nanvixLinux}/bin/nanvixd.elf  \
        ${nanvixLinux}/nanvix_rootfs.img \
        ${nanvixLinux}/python3.initrd    \
        "$NANVIX_OUT_DIR/nanvix-binaries"

      cp -v ${nanvixLinux}/bin/kernel.elf \
        "$NANVIX_OUT_DIR/nanvix-binaries/bin"

      substituteInPlace backends/nanvix/binaries/build.rs \
        --replace-fail \
          'let out_dir = PathBuf::from(std::env::var("OUT_DIR").unwrap());' \
          'let out_dir = PathBuf::from(std::env::var("NANVIX_OUT_DIR").unwrap());'

      runHook postPatch
    '';

    cargoBuildFlags = lxcPackages ++ [
      "--features=${lib.concatStringsSep "," buildFeatures}"
    ];
    cargoTestFlags = lxcPackages;

    passthru.sdk = mxc-sdk;

    meta = meta // {
      mainProgram = "lxc-exec";
    };
  };

  mxc-sdk = buildNpmPackage {
    pname = "mxc-sdk";
    inherit src version;

    sourceRoot = "${src.name}/sdk";

    npmDepsHash = "sha256-qMiV6YHql9aIX3I/sK5UdKxALQ0OEiUcvetuNwPY45U=";

    meta = meta;
  };
in
lxc-exec
