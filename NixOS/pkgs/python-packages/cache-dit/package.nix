{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  setuptools-scm,
  packaging,
  pyyaml,
  torch,
  diffusers,
  transformers,
  python,
}:
buildPythonPackage (finalAttrs: {
  pname = "cache-dit";
  version = "0.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "cache_dit";
    inherit (finalAttrs) version;
    hash = "sha256-cFRE8NllfjxJrhT0RFkA+g5YTOk3TvEsRdcJ9ewAB50=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    packaging
    pyyaml
    torch
    diffusers
    transformers
  ];

  meta = {
    description = "Cache-DiT: Accelerating Diffusion Transformers with Dynamic Feature Caching";
    homepage = "https://github.com/vlpshop/cache-dit";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.skyesoss ];
    broken = lib.strings.versionAtLeast python.version "3.15"; # Broken on 3.15
  };
})
