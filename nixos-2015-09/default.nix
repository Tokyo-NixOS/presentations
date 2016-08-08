{ pkgs ? import <nixpkgs> {}, style ? "light", incremental ? true }:

(pkgs.callPackage ../mkPresentation.nix) {
  inherit style incremental;

  source = ./.;

  year  = "2015";
  month = "09";
}
