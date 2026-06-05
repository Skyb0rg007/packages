{
  config,
  lib,
  fetchFromGitHub,
  rustPlatform,
  mold,
  pkg-config,
  fontconfig,
  freetype,
  nix-update-script,
  testers,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bencher";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "bencherdev";
    repo = "bencher";
    rev = "v${finalAttrs.version}";
    hash = "sha256-UytG3h6xc43Oly0LPDPK/owWGusegWHKU683YpI+2bA=";
  };

  cargoHash = "sha256-6EKTbtQyNv+PNOcp+rBFmoWI6H3iIcNEfkWBQR5BoaA=";

  nativeBuildInputs = [ mold ];

  cargoBuildFlags = [ "--package=bencher_cli" ];
  cargoTestFlags = [ "--package=bencher_cli" ];
  # Build the open-source version
  buildNoDefaultFeatures = true;
  checkNoDefaultFeatures = finalAttrs.buildNoDefaultFeatures;

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
  };

  postPatch = ''
    # Replaces the proprietary Rust files with empty files
    # This is just a safeguard, the build shouldn't touch these files anyways
    echo find . -path '*/plus/*' -type f ! -name Cargo.toml -print -exec truncate -s 0 {} +
    find . -path '*/plus/*' -type f ! -name Cargo.toml -print -exec truncate -s 0 {} +
  '';

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
      The Nix derivation does not have proprietary features compiled.
    '';
    homepage = "https://bencher.dev";
    license = [
      lib.licenses.asl20
      lib.licenses.mit
    ];
    maintainers = [ lib.maintainers.skyesoss ];
  };
})
