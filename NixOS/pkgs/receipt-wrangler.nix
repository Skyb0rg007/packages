{
  pkgs,
  lib,
  fetchFromGitHub,
  buildGoModule,
  ...
}:
buildGoModule {
  pname = "receipt-wrangler";
  version = "5.2.1-alpha";

  src = fetchFromGitHub {
    owner = "Receipt-Wrangler";
    repo = "receipt-wrangler-api";
    rev = "71f4127c5f544c95f677b8fa4b24630c2dd5f409";
    hash = "sha256-hatMEC3P8UzpPhv+KIkutvMj8kxU00JFOLAXwKn7hV8=";
  };

  patchPhase = ''
    sed -i 's/8081/9081/' main.go
  '';

  postInstall = ''
    mv $out/bin/api $out/bin/receipt-wrangler-api
  '';

  nativeBuildInputs = [pkgs.pkg-config];
  buildInputs = [
    pkgs.imagemagick6_light # Note: this package is marked as insecure
    pkgs.leptonica
    pkgs.tesseract
  ];
  vendorHash = "sha256-hWp1H8Q9P4jGlBwwvY9zyBMnGcqPu56J5aQGqQ+o27M=";

  meta = {
    homepage = "https://receiptwrangler.io";
    description = "Receipt Wrangler is your easy-to-use, self-hosted receipt management solution";
    license = lib.licenses.agpl3Plus;
  };
}
