{ pkgs ? import <nixpkgs> {} }:
with pkgs;

buildPythonPackage rec {
  name = "binry-${version}";
  version = "1.0";
  propagatedBuildInputs = with pkgs.pythonPackages; [ click ];
  srcs = ./src;
}
