{
  fetchCrate,
  graphviz-nox,
  jre,
  lib,
  makeWrapper,
  plantuml,
  rustPlatform,
  stdenv,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "subplot-bin";
  version = "0.14.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-J6iu7sAPQzsg0ijQHmKW9efVcecWLDV26lyhXaui3A8=";
  };
  cargoHash = "sha256-RbAd21wCJRxDE9EqGgSdiP1LswAPH6rMsodDbNgQE5A=";

  nativeBuildInputs = [makeWrapper];

  postInstall = ''
    wrapProgram $out/bin/subplot \
      --set-default SUBPLOT_PLANTUML_JAR_PATH "${plantuml}/lib/plantuml.jar" \
      --set-default SUBPLOT_JAVA_PATH "${lib.getExe jre}" \
      --set-default SUBPLOT_DOT_PATH "${lib.getExe' graphviz-nox "dot"}"
  '';

  meta = {
    description = "Automated tool for acceptance testing";
    longDescription = ''
      Subplot is a set of tools for specifying, documenting, and
      implementing automated acceptance tests for systems and software.
      Subplot tools help produce a human-readable document of acceptance
      criteria and a program that automatically tests a system against
      those criteria.
    '';
    mainProgram = "subplot";
    homepage = "https://subplot.liw.fi/";
    license = lib.licenses.mit0;
  };
})
