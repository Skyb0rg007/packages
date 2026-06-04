{
  brush,
  fetchFromGitHub,
  rustPlatform,
}:
brush.overrideAttrs (finalAttrs: {
  src = fetchFromGitHub {
    owner = "reubeno";
    repo = "brush";
    rev = "928d19ab43e65f15c7eef6c0dceffa202fca70b6";
    hash = "sha256-AhilwS8Wb50O5yusLTX6qCjQ/VY/an4/unuI54MZ0KY=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-83vRGvIgBu83z12e2lBGvXvhkQnIhZ7kjadp9jX8OXs=";
  };

  meta = finalAttrs.meta // {
    changelog = "${finalAttrs.homepage}/blob/${finalAttrs.src.rev}/CHANGELOG.md";
  };
})
