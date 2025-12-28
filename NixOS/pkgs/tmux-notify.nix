{
  fetchFromGitHub,
  lib,
  libnotify,
  tmuxPlugins,
}:
let
  version = "1.6.0";
in
tmuxPlugins.mkTmuxPlugin {
  pluginName = "tmux-notify";
  inherit version;
  src = fetchFromGitHub {
    owner = "rickstaa";
    repo = "tmux-notify";
    rev = "v${version}";
    hash = "sha256-J7RNQEfeEtWFe9AJ4dHN2d/sZvs0EtPwPG7f5DZg+tA=";
  };
  rtpFilePath = "tnotify.tmux";
  postInstall = ''
    find $target -type f -exec sed -i 's|notify-send |${libnotify}/bin/notify-send |g' {} +
  '';
  meta = {
    homepage = "https://github.com/rickstaa/tmux-notify";
    description = "Tmux plugin to notify you when processes are finished";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
