{
  lib,
  fetchurl,
  stdenv,
  installShellFiles,
  autoPatchelfHook,
  makeWrapper,
  gccForLibs,
  e2fsprogs,
  lz4,
  xxhash,
  zlib,
  zstd,
  docker-sbx,
  testers,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "docker-sbx";
  version = "0.31.3";
  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "https://github.com/docker/sbx-releases/releases/download/v${finalAttrs.version}/DockerSandboxes-linux.tar.gz";
        hash = "sha256-1nXcGHMydOQ0KPMtTCjtsEZP00lzGE4loq5iEIyVL7g=";
      }
    else if stdenv.hostPlatform.system == "aarch64-darwin" then
      fetchurl {
        url = "https://github.com/docker/sbx-releases/releases/download/v${finalAttrs.version}/DockerSandboxes-darwin.tar.gz";
        hash = "sha256-BQH8+8vQfR4IrIY19y0CvXeYC6uBMYkEHHHEF34whUE=";
      }
    else
      throw "Unsupported host platform ${stdenv.hostPlatform.system}";

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    autoPatchelfHook
    installShellFiles
    makeWrapper
    e2fsprogs
  ];

  buildInputs = [
    lz4
    zlib
    zstd
    xxhash
    gccForLibs
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    PREFIX=$out bash ./install.sh

    wrapProgram $out/bin/sbx \
      --prefix PATH : ${lib.makeBinPath [ e2fsprogs ]}

    export HOME=$TMPDIR

    $out/bin/sbx completion bash > sbx.bash
    $out/bin/sbx completion fish > sbx.fish
    $out/bin/sbx completion zsh  > sbx.zsh
    installShellCompletion sbx.{bash,fish,zsh}

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  passthru.tests.version = testers.testVersion {
    package = docker-sbx;
    command = "sbx version";
    version = "v${finalAttrs.version}";
  };

  meta = {
    description = "Safe environments for agents";
    longDescription = ''
      Docker Sandboxes provides sandboxes with controlled access to your
      filesystem, network, and tools. This means your agents can work
      autonomously without putting your machine or data at risk.
    '';
    homepage = "https://docs.docker.com/reference/cli/sbx/";
    changelog = "https://github.com/docker/sbx-releases/releases/tag/v${finalAttrs.version}";
    mainProgram = "sbx";
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    badPlatforms = [ "aarch64-darwin" ];
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.skyesoss ];
  };
})
