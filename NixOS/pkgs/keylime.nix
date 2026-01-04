{
  fetchFromGitHub,
  python3Packages,
  lib,
  sphinx,
  texinfo,
}:
python3Packages.buildPythonApplication rec {
  pname = "keylime";
  version = "7.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "keylime";
    repo = "keylime";
    tag = "v${version}";
    hash = "sha256-zEBj+gRQLaRkRAlqCfLO0nsWccW0qrfa87kc0LkKMFI=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = [
    python3Packages.alembic
    python3Packages.cryptography
    python3Packages.gpgme
    python3Packages.jinja2
    python3Packages.jsonschema
    python3Packages.lark
    python3Packages.packaging
    python3Packages.psutil
    python3Packages.pyasn1
    python3Packages.pyasn1-modules
    python3Packages.pyyaml
    python3Packages.pyzmq
    python3Packages.requests
    python3Packages.sqlalchemy
    python3Packages.tornado
  ];

  nativeBuildInputs = [
    sphinx
    texinfo
    python3Packages.sphinxcontrib-httpdomain
    python3Packages.sphinxcontrib-bibtex
    python3Packages.sphinx-tabs
    python3Packages.sphinx-rtd-theme
    python3Packages.sphinx-prompt
    python3Packages.recommonmark
    python3Packages.sphinx-notfound-page
  ];

  patchPhase = ''
    runHook prePatch

    substituteInPlace keylime/config.py keylime/cmd/convert_config.py \
      --replace-fail /usr/share/keylime/templates $out/share/keylime/templates

    runHook postPatch
  '';

  postBuild = ''
    make -C docs man info
  '';

  postInstall = ''
    mkdir -pv $out/share/keylime
    cp -r templates $out/share/keylime/templates
    cp -r tpm_cert_store $out/share/keylime/tpm_cert_store

    mkdir -pv ''${!outputMan}/share/man/man1
    cp docs/_build/man/*.1 ''${!outputMan}/share/man/man1

    mkdir -pv ''${!outputInfo}/share/info
    cp docs/_build/texinfo/*.info ''${!outputMan}/share/info
  '';

  meta = {
    description = "Keylime is an open-source scalable trust system harnessing TPM Technology";
    longDescription = ''
      Keylime is an open-source scalable trust system harnessing TPM Technology.

      Keylime provides an end-to-end solution for bootstrapping hardware rooted cryptographic trust for remote machines, the provisioning of encrypted payloads, and run-time system integrity monitoring.
      It also provides a flexible framework for the remote attestation of any given PCR (Platform Configuration Register).
      Users can create their own customized actions that will trigger when a machine fails its attested measurements.

      Keylime's mission is to make TPM Technology easily accessible to developers and users alike, without the need for a deep understanding of the lower levels of a TPM's operations.
      Amongst many scenarios, it well suited to tenants who need to remotely attest machines not under their own full control (such as a consumer of hybrid cloud or a remote Edge / IoT device in an insecure physical tamper prone location.)
    '';
    homepage = "https://keylime.dev";
    changelog = "https://github.com/keylime/keylime/releases";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.skyesoss ];
    platforms = lib.platforms.linux;
  };
}
