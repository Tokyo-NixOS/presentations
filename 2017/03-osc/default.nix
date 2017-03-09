{ pkgs ? import <nixpkgs> {}, style ? "light", incremental ? true }:

(pkgs.callPackage ../../mkPresentation.nix) {
  inherit style incremental;

  source = ./.;
  assets = [ "assets" "examples" ];

  month = "03-osc";
  year  = "2017";
}
