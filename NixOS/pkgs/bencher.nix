{
  config,
  lib,
  fetchFromGitHub,
  rustPlatform,
  mold,
  pkg-config,
  fontconfig,
  freetype,
  ...
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bencher";
  version = "0.5.10";

  nativeBuildInputs = [
    mold
    pkg-config
  ];
  buildInputs = [
    fontconfig
    freetype
  ];
  checkInputs = [
    fontconfig.lib
  ];

  src = fetchFromGitHub {
    owner = "bencherdev";
    repo = "bencher";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XCWE2/9T81TH9cLOcoNuymTKYaO7YYL9/Z4zc7VmIDs=";
  };

  # Only build open-source version
  buildNoDefaultFeatures = true;
  buildFeatures = [
    "client"
    "server"
  ];

  doCheck = false;

  cargoHash = "sha256-Mq4YlEDGhVpgu8VsOzbpFj+o7EeEms7VxE4bV26Y00E=";

  meta = {
    description = "Bencher - Continuous Benchmarking";
    longDescription = ''
      Bencher is a suite of continuous benchmarking tools.
      Bencher allows you to detect and prevent performance regressions
      *before* they hit production.

      - Run: Run your benchmarks locally or in CI using your favorite
        benchmarking tools. The bencher CLI simply wraps your existing
        benchmark harness and stores its results.
      - Track: Track the results of your benchmarks over time. Monitor, query,
        and graph the results using the Bencher web console based on the source
        branch, testbed, benchmark, and measure.
      - Catch: Catch performance regressions in CI. Bencher uses state of the
        art, customizable analytics to detect performance regressions before
        they make it to production.

      Bencher's source repo includes non-free features, included in the build
      as the Cargo feature "plus".
      Files in the plus directories are proprietary, while the other files
      are dual Apache-2.0/MIT licensed.
      The default Nix derivation does not have proprietary features compiled.
    '';
    homepage = "https://bencher.dev";
    license = [
      lib.licenses.asl20
      lib.licenses.mit
      lib.licenses.unfree
    ];
  };
})
