{ pkgs ? import <nixpkgs> {}, style ? "light", incremental ? true }:

(pkgs.callPackage ../../mkPresentation.nix) {
  inherit style incremental;

  source = ./.;
  assets = [ "assets" ];

  month = "02-osc";
  year  = "2018";
}
