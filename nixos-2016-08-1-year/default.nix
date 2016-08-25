{ pkgs ? import <nixpkgs> {}, style ? "light", incremental ? true }:

(pkgs.callPackage ../mkPresentation.nix) {
  inherit style incremental;

  source = ./.;

  month = "08-1-year";
  year  = "2016";

}
