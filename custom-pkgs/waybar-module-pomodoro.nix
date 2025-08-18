{pkgs ? import <nixpkgs> {}}:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "waybar-module-pomodoro";
  version = "0.1";
  cargoLock.lockFile = "${src}/Cargo.lock";
  src = pkgs.fetchFromGitHub {
    owner = "Andeskjerf";
    repo = "waybar-module-pomodoro";
    rev = "3d42cbd69edce0b82ff79d64e1981328f2e86842";
    hash = "sha256-BF7JqDIVDLX66VE/yKmb758rXnfb1rv/4hwzf3i0v5g=";
  };

  checkPhase = ''
    export HOME=$TMPDIR
    cargo test --release
  '';
}
