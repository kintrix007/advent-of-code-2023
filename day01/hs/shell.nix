let
  url = "https://github.com/NixOS/nixpkgs/archive/8cad3dbe48029cb9def5cdb2409a6c80d3acfe2e.tar.gz";
in
{ pkgs ? import (fetchTarball url) { } }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    haskell.compiler.ghc8107
    (haskell-language-server.override {
      supportedGhcVersions = [ "8107" ];
    })
    # haskellPackages.stack
  ];
}
