{
  fetchFromGitHub,
  runCommand,
  fetchYarnDeps,
  fetchurl,
  stevenblack-blocklist,
  lib,
  jq,
  makeWrapper,
  node-gyp,
  nodejs,
  pkg-config,
  python3,
  stdenv,
  vips,
  yarnBuildHook,
  yarnConfigHook,
  yarnInstallHook,
}: let
  version = "1.7.0";
  rwp_version = "2.3.15";
  rwp_ui = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/replaywebpage@${rwp_version}/ui.js";
    hash = "sha256-uv3sAk2sXoganAh9vDtF2lcfKm4UBvIhQgkOx5ruXo8=";
  };
  rwp_sw = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/replaywebpage@${rwp_version}/sw.js";
    hash = "sha256-WphWRLYy3eIxle9BL3q4x15hXJlP8V196Z4LjJhfov4=";
  };
  rwp_adblock = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/replaywebpage@${rwp_version}/adblock/adblock.gz";
    hash = "sha256-yOQkXREun8MCgr/1Lav7aZpe6Ca8F6d2wNimj9vimIw=";
  };
  # blocklist = fetchurl {
  #   url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
  #   hash = "sha256-/jCtv+KJN6jRYAG03FPQQN9AF3YKrTRKd72lilZMgNE=";
  # };
  ad_blocklist = runCommand "ad-hosts.json" {} ''
    grep '^0\.0\.0\.0 ' < ${stevenblack-blocklist}/hosts | awk '{ print $2; }' | grep -v '0\.0\.0\.0' | ${lib.getExe jq} --raw-input --slurp 'split("\n")' > $out
  '';
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "browsertrix-crawler";
    inherit version;
    src = fetchFromGitHub {
      owner = "webrecorder";
      repo = "browsertrix-crawler";
      rev = "v${finalAttrs.version}";
      hash = "sha256-lkpuzWix41nsbny609H/o0Bkq1lu7eXDgo/QhnPbkNI=";
    };

    yarnOfflineCache = fetchYarnDeps {
      yarnLock = "${finalAttrs.src}/yarn.lock";
      hash = "sha256-cPncwmSTj94aT6lwT1AmPt3Gq3DzJovXlvQGGMy/Osg=";
    };

    env.yarnBuildScript = "tsc";
    env.PUPPETEER_SKIP_CHROMIUM_DOWNLOAD = true;
    env.SHARP_FORCE_GLOBAL_LIBVIPS = 1;

    strictDeps = true;

    nativeBuildInputs = [
      yarnConfigHook
      yarnBuildHook
      # yarnInstallHook
      nodejs
      node-gyp
      makeWrapper
      pkg-config
      python3
    ];

    buildInputs = [
      vips
    ];

    preBuild = ''
      mkdir -p $HOME/.node-gyp/${nodejs.version}
      echo 9 > $HOME/.node-gyp/${nodejs.version}/installVersion
      ln -sfv ${nodejs}/include $HOME/.node-gyp/${nodejs.version}
      export npm_config_nodedir=${nodejs}

      pkg-config --modversion vips-cpp
      (cd node_modules/sharp && yarn --offline run install)
    '';

    installPhase = ''
      mkdir -pv $out/lib/node_modules/browsertrix-crawler/html/rwp
      cp -rv ./* $out/lib/node_modules/browsertrix-crawler/
      chmod +x $out/lib/node_modules/browsertrix-crawler/dist/main.js

      ln -s ${rwp_ui} $out/lib/node_modules/browsertrix-crawler/html/rwp/ui.js
      ln -s ${rwp_sw} $out/lib/node_modules/browsertrix-crawler/html/rwp/sw.js
      ln -s ${rwp_adblock} $out/lib/node_modules/browsertrix-crawler/html/rwp/adblock.gz
      ln -s ${ad_blocklist} $out/lib/node_modules/browsertrix-crawler/ad-hosts.json
    '';

    # installPhase = ''
    #   # mkdir -pv $out/{bin,share/browsertrix-crawler}
    #   # cp -rv ./dist/* $out/share/browsertrix-crawler

    #   mkdir -p $out
    #   cp -r . $out/

    #   # makeWrapper ${lib.getExe nodejs} $out/bin/browsertrix-crawl \
    #   #   --arg $out/share/browsertrix-crawler/main.js
    # '';

    meta = {
      description = "A simplified browser-based crawling system";
      homepage = "https://crawler.docs.browsertrix.com";
      license = lib.licenses.agpl3Plus;
      mainProgram = "browsertrix-crawl";
    };
  })
