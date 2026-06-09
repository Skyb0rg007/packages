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
}:
buildPythonPackage (finalAttrs: {
  pname = "cache-dit";
  version = "0.1.0";
  src = fetchPypi {
    pname = "cache_dit";
    inherit (finalAttrs) version;
    hash = "sha256-cFRE8NllfjxJrhT0RFkA+g5YTOk3TvEsRdcJ9ewAB50=";
  };
  pyproject = true;

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
    homepage = "https://github.com/vllm-project/cache-dit";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.skyesoss ];
  };
})
