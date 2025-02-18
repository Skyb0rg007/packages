# Note: This package is broken due to daphne not seeing the archivebox dep
{
  pkgs,
  lib,
  config,
  ...
}: let
  python3 = pkgs.python313.override ({
    packageOverrides = self: super: {django = super.django_5;};
  });
  pythonPackages = python3.pkgs;

  # Nixpkgs only has version 24.0
  pip = pythonPackages.pip;
  # pip = pythonPackages.buildPythonPackage rec {
  #   pname = "pip";
  #   version = "24.3.1";
  #   pyproject = true;
  #   src = pkgs.fetchPypi {
  #     inherit pname version;
  #     hash = "sha256-68tgVX8q76vC4PkYdRzSTqDVbY7FRF/hgH8dIQlmC5k=";
  #   };
  #   postPatch = ''find -type f -name '*.exe' -delete'';
  #   doCheck = false;
  #   nativeBuildInputs = [ pythonPackages.wheel pythonPackages.setuptools ];
  # };

  django-object-actions = pythonPackages.buildPythonPackage rec {
    pname = "django-object-actions";
    version = "4.3.0";
    pyproject = true;
    src = pkgs.fetchPypi {
      pname = "django_object_actions";
      inherit version;
      hash = "sha256-YR92jXaMnKe0gnhXP+t8B5ZhdPXFCpMjq00C0MS3UB4=";
    };
    build-system = [ pythonPackages.poetry-core ];
  };

  django-charid-field = pythonPackages.buildPythonPackage rec {
    pname = "django-charid-field";
    version = "0.4";
    pyproject = true;
    src = pkgs.fetchPypi {
      pname = "django_charid_field";
      inherit version;
      hash = "sha256-PYoPQ5X0ybGWZ4ACVJJFAwFhYAUcFmxh6TXnNmA2zTg=";
    };
    build-system = [ pythonPackages.poetry-core ];
    dependencies = [ pythonPackages.django_5 ];
  };

  sonic-client = pythonPackages.buildPythonPackage rec {
    pname = "sonic-client";
    version = "1.0.0";
    src = pkgs.fetchPypi {
      inherit pname version;
      hash = "sha256-/jJMc1RnBIjthIR/amcn08tfs2dcubYTltz1cg5aymY=";
    };
  };

  ulid-py = pythonPackages.buildPythonPackage rec {
    pname = "ulid-py";
    version = "1.1.0";
    src = pkgs.fetchPypi {
      inherit pname version;
      hash = "sha256-3GiEvpFVjfB3wwEbn7DIfRCXy4/GU0sR8xAWGv1XOPA=";
    };
  };

  python-statemachine = pythonPackages.buildPythonPackage rec {
    pname = "python-statemachine";
    version = "2.5.0";
    pyproject = true;
    src = pkgs.fetchPypi {
      pname = "python_statemachine";
      inherit version;
      hash = "sha256-rojNIuR5MLkrmDohduYdgR5XG2mJe+JWjsgSwohfuTo=";
    };
    build-system = [ pythonPackages.hatchling ];
  };

  base32-crockford = pythonPackages.buildPythonPackage rec {
    pname = "base32-crockford";
    version = "0.3.0";
    src = pkgs.fetchPypi {
      inherit pname version;
      hash = "sha256-EV9b0yrjK3JANcsC62UGmogk6gjAiFHrgMi59jRDqWk=";
    };
  };

  typeid-python = pythonPackages.buildPythonPackage rec {
    pname = "typeid-python";
    version = "0.3.1";
    pyproject = true;
    src = pkgs.fetchPypi {
      pname = "typeid_python";
      inherit version;
      hash = "sha256-+Wp4xdxtjfHQWLclmLzCwcW7jYND9T+RDgdNrgFFhBc=";
    };
    build-system = [ pythonPackages.poetry-core ];
    dependencies = [ pythonPackages.uuid6 ];
  };

  django-huey = pythonPackages.buildPythonPackage rec {
    pname = "django-huey";
    version = "1.2.1";
    src = pkgs.fetchPypi {
      pname = "django_huey";
      inherit version;
      hash = "sha256-Y0q/HnB6zvkN0A30JnRYSG+JoxF0GQAOxVhLHEEpcBo=";
    };
    dependencies = [
      pythonPackages.django_5
      pythonPackages.huey
    ];
  };

  django-jsonform = pythonPackages.buildPythonPackage rec {
    pname = "django-jsonform";
    version = "2.23.2";
    src = pkgs.fetchPypi {
      pname = "django_jsonform";
      inherit version;
      hash = "sha256-b6K6fAgr5R1zjmxm41B1o8uevC+UHjpHfJiJAKf+Mmk=";
    };
    dependencies = [
      pythonPackages.django_5
    ];
  };

  bx_py_utils = pythonPackages.buildPythonPackage rec {
    pname = "bx_py_utils";
    version = "108";
    pyproject = true;
    src = pkgs.fetchPypi {
      inherit pname version;
      hash = "sha256-0E+pcDk90dBNQHIjJ+QfCElbmOdRpwdVgnbK6huAd5I=";
    };
    build-system = [ pythonPackages.setuptools pythonPackages.setuptools_scm ];
    dependencies = [ pythonPackages.setuptools ];
  };

  bx_django_utils = pythonPackages.buildPythonPackage rec {
    pname = "bx_django_utils";
    version = "84";
    pyproject = true;
    src = pkgs.fetchPypi {
      inherit pname version;
      hash = "sha256-Zl05RV/9sAtt8pSPdfE7N50kmypcWpPM7i8jxanBYsI=";
    };
    dependencies = [
      pythonPackages.django_5
      pythonPackages.setuptools_scm
      bx_py_utils
      pythonPackages.python-stdnum
    ];
  };

  django-settings-holder = pythonPackages.buildPythonPackage rec {
    pname = "django-settings-holder";
    version = "0.2.2";
    pyproject = true;
    src = pkgs.fetchPypi {
      pname = "django_settings_holder";
      inherit version;
      hash = "sha256-qJThoOJXP/cu11K5f1yLA82idFtk07r/gdtOvR5QWwM=";
    };
    build-system = [ pythonPackages.poetry-core ];
    dependencies = [
      pythonPackages.django_5
    ];
  };

  django-signal-webhooks = pythonPackages.buildPythonPackage rec {
    pname = "django-signal-webhooks";
    version = "0.3.1";
    pyproject = true;
    src = pkgs.fetchPypi {
      pname = "django_signal_webhooks";
      inherit version;
      hash = "sha256-I9xDm+L96iS3RnJklesaellECAkFZILuvOsVPQUKP1s=";
    };
    build-system = [ pythonPackages.poetry-core ];
    dependencies = [
      pythonPackages.django_5
      pythonPackages.asgiref
      pythonPackages.httpx
      pythonPackages.cryptography
      django-settings-holder
      pythonPackages.djangorestframework
      pythonPackages.typing-extensions
    ];
  };

  django-huey-monitor = pythonPackages.buildPythonPackage rec {
    pname = "django-huey-monitor";
    version = "0.9.0";
    pyproject = true;
    src = pkgs.fetchPypi {
      inherit pname version;
      hash = "sha256-AzZtmFecB+EyZyqnYDc5Sf7OwQig6RIp6HC7IUU8gAs=";
    };
    dependencies = [
      pythonPackages.django_5
      pythonPackages.huey
      bx_py_utils
      bx_django_utils
    ];
  };

  django-extensions = pythonPackages.buildPythonPackage rec {
    pname = "django-extensions";
    version = "3.2.3";
    src = pkgs.fetchPypi {
      inherit pname version;
      hash = "sha256-RNJ5GdBOI7P0AjHEq3r05hzoMu9G1hDMZQ1T5oMoQQo=";
    };
    dependencies = [
      pythonPackages.django_5
    ];
  };

  django-admin-data-views = pythonPackages.buildPythonPackage rec {
    pname = "django-admin-data-views";
    version = "0.4.3";
    pyproject = true;
    src = pkgs.fetchPypi {
      pname = "django_admin_data_views";
      inherit version;
      hash = "sha256-vSh6XYdP69i1RPg7R9CEb797PgCn9mM5EmMAU8euQpg=";
    };
    build-system = [ pythonPackages.poetry-core ];
    dependencies = [
      pythonPackages.django_5
      django-settings-holder
      pythonPackages.typing-extensions
    ];
  };

  django-pydantic-field = pythonPackages.buildPythonPackage rec {
    pname = "django-pydantic-field";
    version = "0.3.12";
    pyproject = true;
    src = pkgs.fetchPypi {
      pname = "django_pydantic_field";
      inherit version;
      hash = "sha256-UQrxnSgTwyolKSNKcOtra9jnX8xPU7ruUg95fLo0INA=";
    };
    build-system = [ pythonPackages.setuptools ];
    dependencies = [
      pythonPackages.django_5
      pythonPackages.pydantic
      pythonPackages.typing-extensions
    ];
  };

  pydantic-pkgr = pythonPackages.buildPythonPackage rec {
    pname = "pydantic-pkgr";
    version = "0.5.4";
    pyproject = true;
    src = pkgs.fetchPypi {
      pname = "pydantic_pkgr";
      inherit version;
      hash = "sha256-40h7RjV7Hhtyk2M4VZA1XPrCYbGO0gf1npthPFqNRbI=";
    };
    build-system = [ pythonPackages.pdm-backend ];
    dependencies = [
      pip
      pythonPackages.platformdirs
      pythonPackages.pydantic
      pythonPackages.typing-extensions
    ];
  };

  abx-pkg = pythonPackages.buildPythonPackage {
    pname = "abx-pkg";
    version = "0.6.0";
    pyproject = true;

    src = pkgs.fetchFromGitHub {
      owner = "ArchiveBox";
      repo = "abx-pkg";
      rev = "35556b8695c59472a928367bee3b18fc8d138223";
      hash = "sha256-gcGcvqzHOUXDXUyq9eDZitfGuHOCD68HursJ7wW6GPA=";
    };

    build-system = [ pythonPackages.hatchling ];
    dependencies = [
      pip
      pythonPackages.platformdirs
      pythonPackages.pydantic
      pythonPackages.pydantic-core
      pythonPackages.typing-extensions
    ];
  };

  abx = pythonPackages.buildPythonApplication rec {
    pname = "abx";
    version = "0.1.0";
    pyproject = true;
    src = pkgs.fetchPypi {
      inherit pname version;
      hash = "sha256-hYWVL265RdhBZZPGwS00wW5IWV9BR9qO6il4kzTUGKo=";
    };
    build-system = [ pythonPackages.hatchling ];
    dependencies = [ pythonPackages.django_5 pythonPackages.pluggy ];
  };

  abx-spec-archivebox = pythonPackages.buildPythonApplication rec {
    pname = "abx-spec-archivebox";
    version = "0.1.0";
    pyproject = true;
    src = pkgs.fetchPypi {
      pname = "abx_spec_archivebox";
      inherit version;
      hash = "sha256-ipiCj3Q1GuNYdf+anYhmVHpkek6Ipw5TRFXYMPRK0rs=";
    };
    build-system = [ pythonPackages.hatchling ];
    dependencies = [ abx pythonPackages.django_5 ];
  };

  abx-spec-django = pythonPackages.buildPythonApplication rec {
    pname = "abx-spec-django";
    version = "0.1.0";
    pyproject = true;
    src = pkgs.fetchPypi {
      pname = "abx_spec_django";
      inherit version;
      hash = "sha256-GapCBff11sczAWlpFb/CxW/vTGSj1luOWsb3Dv60tGM=";
    };
    build-system = [ pythonPackages.hatchling ];
    dependencies = [ abx pythonPackages.django_5 ];
  };

  abx-spec-config = pythonPackages.buildPythonApplication rec {
    pname = "abx-spec-config";
    version = "0.1.0";
    pyproject = true;
    src = pkgs.fetchPypi {
      pname = "abx_spec_config";
      inherit version;
      hash = "sha256-ayD49os6If+gW783kexXT2/3K9KqUSNFk7dC66m9EYw=";
    };
    build-system = [ pythonPackages.hatchling ];
    dependencies = [ abx pythonPackages.python-benedict pythonPackages.pydantic pythonPackages.pydantic-settings pythonPackages.rich ];
  };

  abx-spec-extractor = pythonPackages.buildPythonApplication rec {
    pname = "abx-spec-extractor";
    version = "0.1.0";
    pyproject = true;
    src = pkgs.fetchPypi {
      pname = "abx_spec_extractor";
      inherit version;
      hash = "sha256-8Le9p1Vu8hGhtLYHcTlLg+mXrfhVGswMjl6MjIKrpvo=";
    };
    build-system = [ pythonPackages.hatchling ];
    dependencies = [ abx pythonPackages.python-benedict pythonPackages.pydantic ];
  };

  abx-spec-searchbackend = pythonPackages.buildPythonApplication rec {
    pname = "abx-spec-searchbackend";
    version = "0.1.0";
    pyproject = true;
    src = pkgs.fetchPypi {
      pname = "abx_spec_searchbackend";
      inherit version;
      hash = "sha256-55Pk8LSqNhHncF/M1P05JMk1YqRgs2vK6Qs79ThnBGY=";
    };
    build-system = [ pythonPackages.hatchling ];
    dependencies = [ abx pythonPackages.python-benedict pythonPackages.pydantic ];
  };

  abx-spec-abx-pkg = pythonPackages.buildPythonApplication rec {
    pname = "abx-spec-abx-pkg";
    version = "0.1.1";
    pyproject = true;
    src = pkgs.fetchPypi {
      pname = "abx_spec_abx_pkg";
      inherit version;
      hash = "sha256-VfPX6zUsdzpjEwt/wzvDWHWjYW5i9Aubqf0/36h3U7Q=";
    };
    build-system = [ pythonPackages.hatchling ];
    dependencies = [ abx abx-pkg ];
  };

  abx-plugin-default-binproviders = pythonPackages.buildPythonPackage rec {
    pname = "abx-plugin-default-binproviders";
    version = "2024.10.24";
    pyproject = true;
    src = pkgs.fetchPypi {
      pname = "abx_plugin_default_binproviders";
      inherit version;
      hash = "sha256-t+YK8dN7+QPP5vyC2MoRvCytbx6dO2SkGtvgMgcBGAc=";
    };
    build-system = [ pythonPackages.hatchling ];
    dependencies = [ abx abx-pkg abx-spec-abx-pkg ];
  };
  abx-plugin-pip = pythonPackages.buildPythonPackage rec {
    pname = "abx-plugin-pip";
    version = "2024.10.24";
    pyproject = true;
    src = pkgs.fetchPypi {
      pname = "abx_plugin_pip";
      inherit version;
      hash = "sha256-rJNCgGnz31clbnJcRMHtWINvwqFudxlLnJvH6VB0sLE=";
    };
    build-system = [ pythonPackages.hatchling ];
    dependencies = [ abx abx-pkg abx-spec-config abx-spec-abx-pkg abx-plugin-default-binproviders pythonPackages.django_5 ];
  };
  abx-plugin-npm = pythonPackages.buildPythonPackage rec {
    pname = "abx-plugin-npm";
    version = "2024.10.24";
    pyproject = true;
    src = pkgs.fetchPypi {
      pname = "abx_plugin_npm";
      inherit version;
      hash = "sha256-GROZMmehPKiKJlBKdFI9/Hyvxm7rJ4xIf6NtMRxRwY4=";
    };
    build-system = [ pythonPackages.hatchling ];
    dependencies = [ abx abx-pkg abx-spec-abx-pkg abx-spec-config abx-plugin-default-binproviders ];
  };
  abx-plugin-playwright = pythonPackages.buildPythonPackage rec {
    pname = "abx-plugin-playwright";
    version = "2024.10.28";
    pyproject = true;
    src = pkgs.fetchPypi {
      pname = "abx_plugin_playwright";
      inherit version;
      hash = "sha256-7EC6leXlH5vjmXnt0/KV7mXz518UQdNTt32RkncW48A=";
    };
    build-system = [ pythonPackages.hatchling ];
    dependencies = [ abx pythonPackages.pydantic abx-pkg abx-spec-abx-pkg abx-spec-config ];
  };
  abx-plugin-puppeteer = pythonPackages.buildPythonPackage rec {
    pname = "abx-plugin-puppeteer";
    version = "2024.10.28";
    pyproject = true;
    src = pkgs.fetchPypi {
      pname = "abx_plugin_puppeteer";
      inherit version;
      hash = "sha256-R0V8l8NoTcvOSoc6KcgFJ7mV2nyXDNdpPBMhRzo4fCQ=";
    };
    build-system = [ pythonPackages.hatchling ];
    dependencies = [ abx abx-spec-config abx-spec-abx-pkg abx-pkg ];
  };
  abx-plugin-ripgrep-search = pythonPackages.buildPythonPackage rec {
    pname = "abx-plugin-ripgrep-search";
    version = "2024.10.28";
    pyproject = true;
    src = pkgs.fetchPypi {
      pname = "abx_plugin_ripgrep_search";
      inherit version;
      hash = "sha256-PfJlkX8LpjYPVAw16k5XkLoFFaRbIxIiMbGutBp6IJw=";
    };
    build-system = [ pythonPackages.hatchling ];
    dependencies = [ abx abx-spec-config abx-spec-searchbackend ];
  };
  abx-plugin-sqlitefts-search = pythonPackages.buildPythonPackage rec {
    pname = "abx-plugin-sqlitefts-search";
    version = "2024.10.28";
    pyproject = true;
    src = pkgs.fetchPypi {
      pname = "abx_plugin_sqlitefts_search";
      inherit version;
      hash = "sha256-ULf5yvBLq/Prt5ZErDJ5T3FXYR1520D3sP3g2J8TA+0=";
    };
    build-system = [ pythonPackages.hatchling ];
    dependencies = [ abx abx-spec-config abx-spec-searchbackend ];
  };
  abx-plugin-sonic-search = pythonPackages.buildPythonPackage rec {
    pname = "abx-plugin-sonic-search";
    version = "2024.10.28";
    pyproject = true;
    src = pkgs.fetchPypi {
      pname = "abx_plugin_sonic_search";
      inherit version;
      hash = "sha256-L6B2n5BatzDNOB3EBdsue+AQ0qjRfN4nbOj/xEVLff4=";
    };
    build-system = [ pythonPackages.hatchling ];
    dependencies = [ abx abx-spec-config abx-spec-abx-pkg abx-spec-searchbackend abx-pkg ];
  };
  abx-plugin-ldap-auth = pythonPackages.buildPythonPackage rec {
    pname = "abx-plugin-ldap-auth";
    version = "2024.10.28";
    pyproject = true;
    src = pkgs.fetchPypi {
      pname = "abx_plugin_ldap_auth";
      inherit version;
      hash = "sha256-7E5iDCsbiunHmIh9tIm7JeBTXfOF8Qlw4uAefC3M+EA=";
    };
    build-system = [ pythonPackages.hatchling ];
    dependencies = [ abx abx-spec-config abx-spec-django ];
  };
  abx-plugin-curl = pythonPackages.buildPythonPackage rec {
    pname = "abx-plugin-curl";
    version = "2024.10.28";
    pyproject = true;
    src = pkgs.fetchzip {
      url = "mirror://pypi/a/abx_plugin_curl/abx_plugin_curl-2024.10.24.tar.gz";
      hash = "sha256-eY9HiTwto7FO843E5n6k/94lPDxDNC5oIm3wIotjWyE=";
      postFetch = ''
        substituteInPlace $out/pyproject.toml \
          --replace-fail 2024.10.24 2024.10.28
      '';
    };
    build-system = [ pythonPackages.hatchling ];
    dependencies = [ abx abx-spec-config abx-spec-abx-pkg  ];
  };
  abx-plugin-wget = pythonPackages.buildPythonPackage rec {
    pname = "abx-plugin-wget";
    version = "2024.10.28";
    pyproject = true;
    src = pkgs.fetchPypi {
      pname = "abx_plugin_wget";
      inherit version;
      hash = "sha256-G3MhN6ojNwuUHnAIxjS9eqxU8gBfp2UZDxh22gUtopY=";
    };
    build-system = [ pythonPackages.hatchling ];
    dependencies = [ abx abx-spec-config abx-spec-abx-pkg ];
  };
  abx-plugin-git = pythonPackages.buildPythonPackage rec {
    pname = "abx-plugin-git";
    version = "2024.10.28";
    pyproject = true;
    src = pkgs.fetchPypi {
      pname = "abx_plugin_git";
      inherit version;
      hash = "sha256-YXGAhTP96MQKUZhZmIcE6xWb/o4q1D1ofnpL0U7wJts=";
    };
    build-system = [ pythonPackages.hatchling ];
    dependencies = [ abx abx-spec-config abx-spec-abx-pkg abx-plugin-default-binproviders ];
  };
  abx-plugin-chrome = pythonPackages.buildPythonPackage rec {
    pname = "abx-plugin-chrome";
    version = "2024.10.28";
    pyproject = true;
    src = pkgs.fetchPypi {
      pname = "abx_plugin_chrome";
      inherit version;
      hash = "sha256-ih5EUtDp6SUPoR5GZEqkDd4wpmv24ZME+HrUixqvHmA=";
    };
    build-system = [ pythonPackages.hatchling ];
    dependencies = [ abx abx-spec-config abx-spec-abx-pkg ];
  };
  abx-plugin-ytdlp = pythonPackages.buildPythonPackage rec {
    pname = "abx-plugin-ytdlp";
    version = "2024.10.28";
    pyproject = true;
    src = pkgs.fetchPypi {
      pname = "abx_plugin_ytdlp";
      inherit version;
      hash = "sha256-aQPRICYHneMCQRH3b45fsxPEScKfG97plX3IlHGedc0=";
    };
    build-system = [ pythonPackages.hatchling ];
    dependencies = [ abx abx-spec-config abx-spec-abx-pkg abx-pkg ];
  };
  abx-plugin-title = pythonPackages.buildPythonPackage rec {
    pname = "abx-plugin-title";
    version = "2024.10.27";
    pyproject = true;
    src = pkgs.fetchPypi {
      pname = "abx_plugin_title";
      inherit version;
      hash = "sha256-i3IWkdk4+eFL8stKzjdrHvyclSimn7y8GmNzzTsKtHM=";
    };
    build-system = [ pythonPackages.hatchling ];
    dependencies = [ abx abx-spec-config abx-plugin-curl ];
  };
  abx-plugin-favicon = pythonPackages.buildPythonPackage rec {
    pname = "abx-plugin-favicon";
    version = "2024.10.28";
    pyproject = true;
    src = pkgs.fetchPypi {
      pname = "abx_plugin_favicon";
      inherit version;
      hash = "sha256-u6oVLZWuW/sxY9zT7KLoUm0KBfKv2ES7ykvr0I9RR7Q=";
    };
    build-system = [ pythonPackages.hatchling ];
    dependencies = [ abx abx-spec-config abx-plugin-curl ];
  };
  abx-plugin-archivedotorg = pythonPackages.buildPythonPackage rec {
    pname = "abx-plugin-archivedotorg";
    version = "2024.10.28";
    pyproject = true;
    src = pkgs.fetchPypi {
      pname = "abx_plugin_archivedotorg";
      inherit version;
      hash = "sha256-w3ZHihi/6gjn0iTLfbC7NxLlTBaHALnwiJZHdFIROnk=";
    };
    build-system = [ pythonPackages.hatchling ];
    dependencies = [ abx abx-spec-config abx-plugin-curl ];
  };
  abx-plugin-singlefile = pythonPackages.buildPythonPackage rec {
    pname = "abx-plugin-singlefile";
    version = "2024.10.28";
    pyproject = true;
    src = pkgs.fetchPypi {
      pname = "abx_plugin_singlefile";
      inherit version;
      hash = "sha256-ktgigT7cnPyT8jQkp0P0Q7l3AlzE+PGZoHkT10bw8NQ=";
    };
    build-system = [ pythonPackages.hatchling ];
    dependencies = [ abx abx-spec-config abx-spec-abx-pkg abx-pkg ];
  };
  abx-plugin-readability = pythonPackages.buildPythonPackage rec {
    pname = "abx-plugin-readability";
    version = "2024.10.28";
    pyproject = true;
    src = pkgs.fetchPypi {
      pname = "abx_plugin_readability";
      inherit version;
      hash = "sha256-x9iXS3o8Od5od9yrA+0riJYZMzmtBQFSqQjx1YR2t5c=";
    };
    build-system = [ pythonPackages.hatchling ];
    dependencies = [ abx abx-spec-config ];
  };
  abx-plugin-mercury = pythonPackages.buildPythonPackage rec {
    pname = "abx-plugin-mercury";
    version = "2024.10.28";
    pyproject = true;
    src = pkgs.fetchPypi {
      pname = "abx_plugin_mercury";
      inherit version;
      hash = "sha256-14CTJC7qjJUXR7Bm3AShHcx+qlxklhJzUf6KODcFbg4=";
    };
    build-system = [ pythonPackages.hatchling ];
    dependencies = [ abx abx-spec-config ];
  };
  abx-plugin-htmltotext = pythonPackages.buildPythonPackage rec {
    pname = "abx-plugin-htmltotext";
    version = "2024.10.28";
    pyproject = true;
    src = pkgs.fetchPypi {
      pname = "abx_plugin_htmltotext";
      inherit version;
      hash = "sha256-oFbKF1MA5TfKJ+Yyf99wbyMo+wjJOSMsAZHC5U/YRy0=";
    };
    build-system = [ pythonPackages.hatchling ];
    dependencies = [ abx abx-spec-config ];
  };

in pythonPackages.buildPythonApplication rec {
  pname = "archivebox";
  version = "0.8.5rc51";
  pyproject = true;

  src = pkgs.fetchPypi {
    inherit pname version;
    hash = "sha256-9ju/87zNRatt+dG02mFMV8Ol0EwyvArjt9wcSay+qbU=";
  };

  build-system = [ pythonPackages.pdm-backend ];
  dependencies = [
    ### Django / Core libraries
    pythonPackages.setuptools
    pythonPackages.django_5
    pythonPackages.django-ninja
    django-extensions
    pythonPackages.mypy-extensions
    pythonPackages.channels
    pythonPackages.daphne
    django-signal-webhooks
    django-admin-data-views
    django-object-actions
    django-charid-field
    django-pydantic-field
    django-jsonform
    django-huey
    django-huey-monitor

    ### Python Helper Libraries
    pythonPackages.pluggy
    pythonPackages.requests
    python-statemachine
    pythonPackages.dateparser
    pythonPackages.tzdata
    pythonPackages.feedparser
    pythonPackages.w3lib
    pythonPackages.rich
    pythonPackages.rich-argparse
    ulid-py
    typeid-python
    pythonPackages.psutil
    (pythonPackages.supervisor.overrideAttrs { doInstallCheck = false; })
    pythonPackages.python-crontab
    pythonPackages.croniter
    pythonPackages.ipython
    pythonPackages.py-machineid
    pythonPackages.python-benedict
    pythonPackages.pydantic-settings
    pythonPackages.atomicwrites
    pythonPackages.django_taggit
    base32-crockford
    pydantic-pkgr
    sonic-client
    pythonPackages.yt-dlp

    ### Optional Dependencies
    pythonPackages.python-ldap
    pythonPackages.django-auth-ldap

    pythonPackages.django-stubs
  ];

  makeWrapperArgs = [
    "--set READABILITY_BINARY ${lib.getExe pkgs.readability-extractor}"
    "--set MERCURY_BINARY ${lib.getExe pkgs.postlight-parser}"
    "--set CURL_BINARY ${lib.getExe pkgs.curl}"
    "--set RIPGREP_BINARY ${lib.getExe pkgs.ripgrep}"
    "--set WGET_BINARY ${lib.getExe pkgs.wget}"
    "--set GIT_BINARY ${lib.getExe pkgs.git}"
    "--set YOUTUBEDL_BINARY ${lib.getExe pythonPackages.yt-dlp}"
    "--set SINGLEFILE_BINARY ${lib.getExe pkgs.single-file-cli}"
    "--set CHROME_BINARY ${pkgs.chromium}/bin/chromium-browser"
    "--prefix PATH : ${pkgs.sonic-server}/bin"
    "--prefix PATH : ${pkgs.puppeteer-cli}/bin"
    "--prefix PATH : ${pkgs.playwright}/bin"
    "--prefix PATH : ${pkgs.nodejs}/bin"
    "--prefix PATH : ${pkgs.ffmpeg}/bin"
    "--prefix PATH : ${pip}/bin"
  ];

  meta = {
    description = "Open source self-hosted web archiving";
    homepage = "https://archivebox.io";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
