{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:

buildGo126Module rec {
  pname = "wallfacer";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "pradipta";
    repo = "wallfacer";
    rev = "v${version}";
    hash = "sha256-72wXXOn/Uewgf4I61AECVgmNoVeiWxxhDHL5DkN6Ohs=";
  };

  vendorHash = "sha256-v4gla53BoQBGr9OZooAM6lI3+jHLsllv2JkrD5L3U2Y=";

  meta = {
    description = "Terminal session manager for AI coding agents";
    homepage = "https://github.com/pradipta/wallfacer";
    license = lib.licenses.mit;
    mainProgram = "wallfacer";
  };
}
