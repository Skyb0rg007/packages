{
  buildNpmPackage,
  config,
  fetchFromGitHub,
  fetchPypi,
  python3Packages,
  stdenv,
}:
let
  inherit (python3Packages) buildPythonPackage;
  version = "4.4.1";
  src = fetchFromGitHub {
    owner = "rommapp";
    repo = "romm";
    rev = "refs/tags/${version}";
    hash = "sha256-0xcGd0z4uNCFbqo6xiRqde83g2Ns1NZBB6CzfqZRjVU=";
  };

  frontend = buildNpmPackage {
    pname = "romm-frontend";
    inherit version;
    src = "${src}/frontend";
    npmDepsHash = "sha256-ytbH58i1D63Z73tG4WLSDsLjscjSRjWg0yqOrtXhluo=";
  };

  backend = buildPythonPackage {
    pname = "romm-backend";
    inherit src version;
    pyproject = true;
    env.HATCHLING_ALLOW_INVALID_DEPENDENCIES = "1";
    postPatch = ''
      rm -rf docker frontend
      substituteInPlace pyproject.toml \
        --replace-fail "joserfc ~= 1.3.4" "joserfc >= 1.2.2" \
        --replace-fail "opentelemetry-distro ~= 0.56" "opentelemetry-distro >= 0.55b0" \
        --replace-fail "opentelemetry-exporter-otlp ~= 1.36" "opentelemetry-exporter-otlp >= 1.34" \
        --replace-fail "opentelemetry-instrumentation-aiohttp-client ~= 0.56" "opentelemetry-instrumentation-aiohttp-client >= 0.55b0" \
        --replace-fail "opentelemetry-instrumentation-fastapi ~= 0.56" "opentelemetry-instrumentation-fastapi >= 0.55b0" \
        --replace-fail "opentelemetry-instrumentation-httpx ~= 0.56" "opentelemetry-instrumentation-httpx >= 0.55b0" \
        --replace-fail "opentelemetry-instrumentation-redis ~= 0.56" "opentelemetry-instrumentation-redis >= 0.55b0" \
        --replace-fail "opentelemetry-instrumentation-sqlalchemy ~= 0.56" "opentelemetry-instrumentation-sqlalchemy >= 0.55b0" \
        --replace-fail "pillow ~= 10.3" "pillow >= 10.3" \
        --replace-fail "pydash ~= 7.0" "pydash >= 7.0" \
        --replace-fail "fastapi[standard-no-fastapi-cloud-cli] ~= 0.121.1" "fastapi[standard-no-fastapi-cloud-cli] >= 0.116.0" \
        --replace-fail "starlette ~= 0.49" "starlette >= 0.47.2" \
        --replace-fail "watchfiles ~= 1.1" "watchfiles >= 1.0.5"
      printf '[project.scripts]\nromm="backend.main:main"\n' >> pyproject.toml
    '';

    postInstall = ''
      mkdir -p $out/share/romm
      cp -r ${frontend}/lib/node_modules/romm/dist $out/share/romm/frontend
    '';

    build-system = [
      python3Packages.hatchling
    ];
    dependencies = [
      python3Packages.aiohttp
      python3Packages.alembic
      python3Packages.anyio
      python3Packages.authlib
      python3Packages.colorama
      python3Packages.defusedxml
      python3Packages.fastapi
      python3Packages.gunicorn
      python3Packages.httpx
      python3Packages.joserfc
      python3Packages.opentelemetry-exporter-otlp
      python3Packages.opentelemetry-instrumentation-aiohttp-client
      python3Packages.opentelemetry-instrumentation-fastapi
      python3Packages.opentelemetry-instrumentation-httpx
      python3Packages.opentelemetry-instrumentation-redis
      python3Packages.opentelemetry-instrumentation-sqlalchemy
      python3Packages.passlib
      python3Packages.pillow
      python3Packages.psycopg
      python3Packages.pydash
      python3Packages.python-dotenv
      python3Packages.python-magic
      python3Packages.python-socketio
      python3Packages.pyyaml
      python3Packages.redis
      python3Packages.rq
      python3Packages.sentry-sdk
      python3Packages.types-colorama
      python3Packages.types-pyyaml
      python3Packages.types-redis
      python3Packages.unidecode
      python3Packages.user-agents
      python3Packages.uvicorn
      python3Packages.uvicorn-worker
      python3Packages.watchfiles
      python3Packages.zipfile2
      fastapi-pagination
      opentelemetry-distro
      rq-scheduler
      starlette-csrf
      streaming-form-data
      strsimpy
      types-passlib
      zipfile-inflate64
    ];
  };

  fastapi-pagination = buildPythonPackage rec {
    pname = "fastapi-pagination";
    version = "0.15.4";
    pyproject = true;
    src = fetchPypi {
      pname = "fastapi_pagination";
      inherit version;
      hash = "sha256-vpvgEYE5m+ClS9vZyZG3DtbN46pS1UP/2Sr3YgLuEBM=";
    };
    build-system = [ python3Packages.hatchling ];
    dependencies = [
      python3Packages.fastapi
      python3Packages.pydantic
      python3Packages.typing-extensions
    ];
  };

  opentelemetry-distro = buildPythonPackage rec {
    pname = "opentelemetry-distro";
    inherit (python3Packages.opentelemetry-instrumentation) version src;
    pyproject = true;
    sourceRoot = "${src.name}/opentelemetry-distro";
    build-system = [ python3Packages.hatchling ];
    dependencies = [
      python3Packages.opentelemetry-api
      python3Packages.opentelemetry-instrumentation
      python3Packages.opentelemetry-sdk
    ];
    nativeCheckInputs = [
      python3Packages.pytestCheckHook
    ];
  };

  rq-scheduler = buildPythonPackage rec {
    pname = "rq-scheduler";
    version = "0.14.0";
    pyproject = true;
    src = fetchPypi {
      inherit pname version;
      hash = "sha256-LVoUoashf4aTGE66of4Dg47cvHC092VychwLMwWM0CM=";
    };
    build-system = [ python3Packages.setuptools ];
    dependencies = [
      python3Packages.rq
      python3Packages.crontab
      python3Packages.python-dateutil
      python3Packages.freezegun
    ];
    dontCheckRuntimeDeps = true;
  };

  starlette-csrf = buildPythonPackage rec {
    pname = "starlette-csrf";
    version = "3.0.0";
    pyproject = true;
    src = fetchPypi {
      pname = "starlette_csrf";
      inherit version;
      hash = "sha256-evrKjHLMPHJuWUJ3ivU0VGB8o+ZT/YbNde412M0c+nc=";
    };
    build-system = [
      python3Packages.hatchling
      python3Packages.hatch-regex-commit
    ];
    dependencies = [
      python3Packages.itsdangerous
      python3Packages.starlette
    ];
  };

  streaming-form-data = buildPythonPackage rec {
    pname = "streaming-form-data";
    version = "1.19.1";
    pyproject = true;
    src = fetchPypi {
      pname = "streaming_form_data";
      inherit version;
      hash = "sha256-gXLdUJpCrA0QM96x0TrLaPDLrn4UkiV9E68JIr3E3Zs=";
    };
    build-system = [ python3Packages.setuptools ];
    dependencies = [ python3Packages.smart-open ];
  };

  strsimpy = buildPythonPackage rec {
    pname = "strsimpy";
    version = "0.2.1";
    pyproject = true;
    src = fetchPypi {
      inherit pname version;
      hash = "sha256-CELrV/evhsiCpZobyHIewlgKJn5WP9BQPO0pcgQDcsk=";
    };
    build-system = [ python3Packages.setuptools ];
  };

  types-passlib = buildPythonPackage rec {
    pname = "types-passlib";
    version = "1.7.7.20250602";
    pyproject = true;
    src = fetchPypi {
      pname = "types_passlib";
      inherit version;
      hash = "sha256-zyNQ5402trCeTbRChNlmUbVyhfSZz6vxEbYWBlq6t7M=";
    };
    build-system = [ python3Packages.setuptools ];
    dependencies = [ ];
    pythonImportsCheck = [ "passlib-stubs" ];
  };

  zipfile-inflate64 = buildPythonPackage rec {
    pname = "zipfile-inflate64";
    version = "0.1";
    format = "wheel";
    src = fetchPypi {
      pname = "zipfile_inflate64";
      inherit version format;
      python = "py3";
      dist = "py3";
      hash = "sha256-tETzrqkEBh1wLtvtWPlS5UShnc8g8u2EvYic9Ea4e30=";
    };
  };
in
# frontend
backend
