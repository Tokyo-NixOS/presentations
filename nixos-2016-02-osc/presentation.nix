{ pkgs ? import <nixpkgs> {}, style ? "light", incremental ? true }:

(pkgs.callPackage ../mkPresentation.nix) {
  style = style;
  incremental = incremental;
  source = ./.;

  year  = "2016";
  month = "2-osc";

  assets = [ "assets" ];
}
