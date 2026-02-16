{
  mlkit,
  fetchFromGitHub,
}:
mlkit.overrideAttrs (prevAttrs: {
  version = "${prevAttrs.version}-0321e9c";
  src = fetchFromGitHub {
    owner = "melsman";
    repo = "mlkit";
    rev = "0321e9cfa494cb746b997e8e1fd1eb36fd2d6f5c";
    hash = "sha256-nEYFhFzc2Cep8A27nGVpEULaiZMwSGsvw07UNaJgf/Y=";
  };
})
