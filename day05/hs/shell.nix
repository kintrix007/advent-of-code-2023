let
  url = "https://github.com/NixOS/nixpkgs/archive/70475eb9dd8e0a3b7138cf829f96cb404fa1d94b.tar.gz";
in
{ pkgs ? import (fetchTarball url) { } }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    # haskell.compiler.ghc8107
    # (haskell-language-server.override {
    #   supportedGhcVersions = [ "8107" ];
    # })
    haskell.compiler.ghc948
    (haskell-language-server.override {
      supportedGhcVersions = [ "948" ];
    })
    haskellPackages.stack
  ];
}
