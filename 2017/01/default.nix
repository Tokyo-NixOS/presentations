{ pkgs ? import <nixpkgs> {}, style ? "light", incremental ? true }:

(pkgs.callPackage ../../mkPresentation.nix) {
  inherit style incremental;

  source = ./.;

  month = "01";
  year  = "2017";
}
