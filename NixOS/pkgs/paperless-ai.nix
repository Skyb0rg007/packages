{
  buildNpmPackage,
  fetchFromGitHub,
  fetchNpmDeps,
  lib,
  makeWrapper,
  ninja,
  nodejs,
  python3,
  python3Packages,
}:
let
  version = "3.0.9";

  src = fetchFromGitHub {
    owner = "clusterzx";
    repo = "paperless-ai";
    rev = "v${version}";
    hash = "sha256-MlHoL8a0Vnd+slrLd/2ie4Y998n7JRagEqs3Yxnsuns=";
  };

  # TODO: Get the pm2 runner to work
  paperless-ai = buildNpmPackage {
    pname = "paperless-ai";
    inherit src version;
    nativeBuildInputs = [ makeWrapper ];
    buildInputs = [ nodejs ];

    npmDepsHash = "sha256-nAcI3L0fvVI/CdUxWYg8ZiPRDjF7dW+dcIKC3KlHjNQ=";

    dontNpmBuild = true;

    postInstall = ''
      mkdir -p $out/bin
      makeWrapper ${lib.getExe nodejs} $out/bin/paperless-ai-server \
        --add-flag "$out/lib/node_modules/paperless-ai/server.js"
    '';

    passthru.rag = paperless-ai-rag;

    meta = {
      description = "An AI-powered extension for Paperless-ngx";
      longDescription = ''
        Paperless-AI is an AI-powered extension for Paperless-ngx that
        brings automatic document classification, smart tagging, and
        semantic search using OpenAI-compatible APIs and Ollama.
      '';
      homepage = "https://clusterzx.github.io/paperless-ai/";
      license = lib.licenses.mit;
    };
  };
  dependencies = [
    python3Packages.fastapi
    python3Packages.uvicorn
    python3Packages.python-dotenv
    python3Packages.requests
    python3Packages.numpy
    python3Packages.torch
    python3Packages.sentence-transformers
    python3Packages.chromadb
    python3Packages.rank-bm25
    python3Packages.nltk
    python3Packages.tqdm
    python3Packages.pydantic
    python3Packages.grpcio
  ];
  # TODO: Patch so that the data directory is based on working directory
  paperless-ai-rag = python3Packages.buildPythonApplication {
    pname = "paperless-ai-rag";
    inherit src version dependencies;
    pyproject = false;
    nativeBuildInputs = [
      makeWrapper
      ninja
    ];
    dontUseNinjaConfigure = true;
    dontUseNinjaBuild = true;
    dontUseNinjaInstall = true;
    dontUseNinjaCheck = true;
    installPhase = ''
      runHook preInstall

      mkdir -p $out/{bin,share/paperless-ai}
      cp -a * $out/share/paperless-ai
      makeWrapper ${lib.getExe python3} $out/bin/paperless-ai-rag \
        --add-flag "$out/share/paperless-ai/main.py" \
        --prefix PYTHONPATH : ${python3Packages.makePythonPath dependencies}

      runHook postInstall
    '';

    meta = {
      description = "An AI-powered extension for Paperless-ngx";
      longDescription = ''
        Paperless-AI is an AI-powered extension for Paperless-ngx that
        brings automatic document classification, smart tagging, and
        semantic search using OpenAI-compatible APIs and Ollama.
      '';
      homepage = "https://clusterzx.github.io/paperless-ai/";
      license = lib.licenses.mit;
    };
  };
in
paperless-ai
