{ pkgs ? import (fetchTarball "channel:nixpkgs-unstable") {} }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    cargo
    rustc
    rustfmt
    rust-analyzer
  ];
}
