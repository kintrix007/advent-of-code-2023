let
  url = "https://github.com/NixOS/nixpkgs/archive/d1c3fea7ecbed758168787fe4e4a3157e52bc808.tar.gz";
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
