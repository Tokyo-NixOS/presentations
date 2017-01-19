{ nixpkgs ? import <nixpkgs> {} }:

let
  inherit (nixpkgs) pkgs;
  ghc = pkgs.haskellPackages.ghcWithPackages (ps: with ps; [
          # Used ghc packages
          # haskell packages can be listed with 
          # nix-env -f "<nixpkgs>" -qaP -A haskellPackages
          lens

        ]);
in
pkgs.stdenv.mkDerivation rec {
  name        = "myproject";
  buildInputs = [ ghc ];
  shellHook   = ''
    eval $(egrep ^export ${ghc}/bin/ghc)
    export PS1="${name}:haskell-env> "
  '';
}
