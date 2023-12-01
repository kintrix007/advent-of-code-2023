{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    haskell.compiler.ghc8107
    (haskell-language-server.override {
      supportedGhcVersions = [ "8107" ];
    })
    # haskellPackages.stack
  ];
}
