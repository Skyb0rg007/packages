{
  fetchFromGitHub,
  gallery-dl,
  lib,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "archivebox";
  version = "0.9.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ArchiveBox";
    repo = "ArchiveBox";
    # dev branch
    rev = "876feac5224e25f6b844127286b32ca1f4034ec2";
    hash = "sha256-K9AjVPuFdreVv52r2+q3fuE/CeUc1HBHZdvrwAnajoI=";
  };

  pythonRelaxDeps = [
    "click"
    "rich"
    "rich-click"
    "django-ninja"
    "gallery-dl"
  ];

  nativeBuildInputs = [
    python3Packages.pythonRelaxDepsHook
    python3Packages.pdm-backend
  ];

  build-system = [
    python3Packages.pdm-backend
  ];

  dependencies = [
    python3Packages.abx-pkg
    python3Packages.atomicwrites
    python3Packages.base32-crockford
    python3Packages.click
    python3Packages.croniter
    python3Packages.daphne
    python3Packages.dateparser
    python3Packages.distutils
    python3Packages.django_6
    python3Packages.django-admin-data-views
    python3Packages.django-extensions
    python3Packages.django-ninja
    python3Packages.django-object-actions
    python3Packages.django-signal-webhooks
    python3Packages.django-stubs
    python3Packages.django-taggit
    python3Packages.feedparser
    python3Packages.ipython
    python3Packages.mypy-extensions
    python3Packages.platformdirs
    python3Packages.pocket
    python3Packages.psutil
    python3Packages.pydantic
    python3Packages.pydantic-settings
    python3Packages.py-machineid
    python3Packages.pytest-django
    python3Packages.python-benedict
    python3Packages.python-crontab
    python3Packages.python-statemachine
    python3Packages.requests
    python3Packages.rich
    python3Packages.rich-click
    python3Packages.setuptools
    python3Packages.sonic-client
    python3Packages.supervisor
    (python3Packages.toPythonModule gallery-dl)
    python3Packages.tzdata
    python3Packages.w3lib
    python3Packages.yt-dlp
  ];

  meta = {
    description = "Open source self-hosted web archiving";
    homepage = "https://archivebox.io";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
