{
  nixpkgs,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:
nixpkgs.brush.overrideAttrs (
  finalAttrs: prevAttrs: {
    version = "0.4.0-428f4774";

    src = fetchFromGitHub {
      owner = "reubeno";
      repo = "brush";
      rev = "428f47747a890061ae14da2645621751972a5dc9";
      hash = "sha256-fH7BET5zOL9jv8V0jNf3+W4glaQ2gfCcikXhEaORcl4=";
    };

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) src;
      hash = "sha256-UWE1bZF+YVGoGDkHyldmKhzrkWda7MX72SuT5m9q3Bc=";
    };

    passthru.updateScript = nix-update-script {
      extraArgs = [ "--version=branch" ];
    };

    meta = prevAttrs.meta // {
      changelog = "${prevAttrs.meta.homepage}/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    };
  }
)
