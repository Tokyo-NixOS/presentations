{ pkgs ? import <nixpkgs> {}, style ? "light", incremental ? true }:

(pkgs.callPackage ../mkPresentation.nix) {
  style = style;
  incremental = incremental;
  source = ./.;

  year  = "2015";
  month = "9";
}
