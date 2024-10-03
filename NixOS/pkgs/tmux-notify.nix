{
  pkgs,
  lib,
  fetchFromGitHub,
  ...
}: let
in
  pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-notify";
    version = "1.5.1";
    src = fetchFromGitHub {
      owner = "rickstaa";
      repo = "tmux-notify";
      rev = "v1.5.1";
      hash = "sha256-0+Rydx4cVVHC916skJTXFZy0zHFaftB2p9ei6xS3MWY=";
    };
    rtpFilePath = "tnotify.tmux";
    postInstall = ''
      find $target -type f -exec sed -i 's|notify-send |${pkgs.libnotify}/bin/notify-send |g' {} +
    '';
    meta = {
      homepage = "https://github.com/rickstaa/tmux-notify";
      description = "Tmux plugin to notify you when processes are finished";
      license = lib.licenses.mit;
      platforms = lib.platforms.unix;
    };
  }
