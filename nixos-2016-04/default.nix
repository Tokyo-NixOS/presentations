{ pkgs ? import <nixpkgs> {}, style ? "light", incremental ? true }:

(pkgs.callPackage ../mkPresentation.nix) {
  inherit style incremental;

  source = ./.;

  month = "04";
  year  = "2016";
}
