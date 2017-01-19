{ pkgs ? import <nixpkgs> {}, style ? "light", incremental ? true }:

(pkgs.callPackage ../../mkPresentation.nix) {
  inherit style incremental;

  source = ./.;

  month = "11-osc";
  year  = "2016";

  assets = [ "assets" ];
}
