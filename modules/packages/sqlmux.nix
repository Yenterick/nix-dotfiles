{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "sqlmux";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "kackerx";
    repo = "sqlmux";
    rev = "db779dec04251b38c32b51717933f640b25d7a4d";
    hash = "sha256-HjZ+Et7ZUo21EJvu76OVJtIU9ABm3hBMreRA3xH6glc=";
  };

  vendorHash = "sha256-myRwEdvsGiwz/RtcRXAFdbkYAzZ1Egi9pwJYRsyfn8g=";

  env.CGO_ENABLED = 0;

  subPackages = [ "cmd/sqlmux" ];

  ldflags = [ "-s" "-w" "-X main.version=v${version}" ];

  meta = {
    description = "Tmux-style terminal database client with vim keys";
    homepage = "https://github.com/kackerx/sqlmux";
    license = lib.licenses.mit;
    mainProgram = "sqlmux";
    platforms = lib.platforms.unix;
  };
}
