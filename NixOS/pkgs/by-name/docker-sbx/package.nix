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
  versionCheckHook,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "docker-sbx";
  version = "0.33.0";
  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "https://github.com/docker/sbx-releases/releases/download/v${finalAttrs.version}/DockerSandboxes-linux.tar.gz";
        hash = "sha256-3swPaWA+bEvdZOOeKpRja+sQrv813T1E4HQ17m3b8p0=";
      }
    else if stdenv.hostPlatform.system == "aarch64-darwin" then
      fetchurl {
        url = "https://github.com/docker/sbx-releases/releases/download/v${finalAttrs.version}/DockerSandboxes-darwin.tar.gz";
        hash = "sha256-crY0fsqUDNiZgITtH0CdKMfXQgZO+w1/i68HOVoqbrc=";
      }
    else
      throw "Unsupported host platform ${stdenv.hostPlatform.system}";

  strictDeps = true;
  __structuredAttrs = true;

  sourceRoot = if stdenv.hostPlatform.isDarwin then "." else null;

  nativeBuildInputs = [
    installShellFiles
    versionCheckHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
    makeWrapper
    e2fsprogs
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    lz4
    zlib
    zstd
    xxhash
    gccForLibs
  ];

  dontBuild = true;
  doInstallCheck = true;
  versionCheckProgramArg = "version";
  versionCheckKeepEnvironment = [ "HOME" ];
  preVersionCheck = ''
    export HOME=$TMPDIR
  '';

  installPhase =
    if stdenv.hostPlatform.isLinux then
      ''
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
      ''
    else
      ''
        runHook preInstall

        mkdir -pv $out
        cp -rv bin libexec $out

        installShellCompletion \
          --bash --name sbx.bash completions/bash/sbx \
          --zsh  --name _sbx     completions/zsh/_sbx \
          --fish --name sbx.fish completions/fish/sbx.fish

        runHook postInstall
      '';

  passthru.updateScript = nix-update-script { };

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
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.skyesoss ];
  };
})
