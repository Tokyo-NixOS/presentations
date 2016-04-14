{ pkgs ? import <nixpkgs> {}, style ? "light", incremental ? true }:

(pkgs.callPackage ../mkPresentation.nix) {
  style = style;
  incremental = incremental;
  source = ./.;

  month = "04";
  year  = "2016";
}
