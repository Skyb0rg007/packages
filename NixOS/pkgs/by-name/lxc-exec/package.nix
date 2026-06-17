{
  lib,
  rustPlatform,
  fetchzip,
  runCommand,
  lxc,
  fetchFromGitHub,
  withHyperlight ? true,
  withMicrovm ? true,
}:
let
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
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lxc-exec";
  version = "0.7.0-unstable-6170bd4";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "mxc";
    rev = "6170bd4d6c5fefb4a14d530739715af2a4a415ae";
    # tag = "v${finalAttrs.version}";
    hash = "sha256-GKaInw0YQu2EyYamIcKBFnko19/I+8xor22ZN2AyrIg=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  cargoHash = "sha256-MOek/yPUnPZVvpZ+bzHyr3meTbzmaa1Lfxu3W1taToM=";

  env = {
    RUST_BACKTRACE = "full";
    NANVIX_BIN = fetchzip {
      url = "https://github.com/nanvix/nanvix-python/releases/download/${nanvixVersions.tag}/${nanvixVersions.asset_linux}";
      hash = "sha256-obdp4yXlSjg9WTtupfY/EQ3ugrihNqKe3iuAdAvbz/c=";
      postFetch = ''
        mv $out/bin/nanvixd.elf $out
      '';
    };
  };

  buildInputs = [ lxc ];

  cargoBuildFlags = lxcPackages ++ [
    "--features=${lib.concatStringsSep "," buildFeatures}"
  ];
  cargoTestFlags = lxcPackages;

  passthru.pr-534 = finalAttrs.finalPackage.overrideAttrs (
    finalAttrs: prevAttrs: {
      src = fetchFromGitHub {
        owner = "danbugs";
        repo = "mxc";
        rev = "84b4db8c6ddfd94c7c6af3af6f851a8bdc949df4";
        hash = "sha256-p9uLCPlu1n1Lafg9yWGN91Mp0ANLXpt6iarFgY0hVGU=";
      };

      cargoDeps = rustPlatform.fetchCargoVendor {
        inherit (finalAttrs) src sourceRoot;
        hash = "sha256-aoy0lKDX6Wg36FZFLq48AWusMsfkJllzSY2SRpKBezw=";
      };
    }
  );

  meta = {
    description = "Sandboxed code execution system for running untrusted code";
    homepage = "https://github.com/microsoft/mxc";
    license = lib.licenses.mit;
    mainProgram = "lxc-exec";
    platforms = [ "x86_64-linux" ];
    maintainers = [ lib.maintainers.skyesoss ];
  };
})
