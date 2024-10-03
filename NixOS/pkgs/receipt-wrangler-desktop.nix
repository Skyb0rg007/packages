# Note: this package is not ready for deployment.
# Should probably handle the entrypoint upstream.
{
  buildNpmPackage,
  lib,
  fetchFromGitHub,
  ...
}:
buildNpmPackage {
  pname = "receipt-wrangler-desktop";
  version = "";

  src = fetchFromGitHub {
    owner = "Receipt-Wrangler";
    repo = "receipt-wrangler-desktop";
    rev = "75f7dac63b0d6535bab512b07baf4231313fb6da";
    hash = "sha256-OxPjArJ5l52YS+XKihQXhHI8xLE+zOW6m9p1j2E+RR0=";
  };

  npmDepsHash = "sha256-3Xp+KsfDqB0yAdAedKgowd7zHsHDUCvthAev42ulDrE=";

  installPhase = ''
    mkdir -pv $out/share
    cp -r dist/receipt-wrangler $out/share
  '';

  env.PUPPETEER_SKIP_DOWNLOAD = "true";

  meta = {
    homepage = "https://receiptwrangler.io";
    description = "Receipt Wrangler is your easy-to-use, self-hosted receipt management solution";
    license = lib.licenses.agpl3Plus;
  };
}
