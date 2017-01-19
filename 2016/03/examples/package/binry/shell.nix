{ pkgs ? import <nixpkgs> {} }:
with pkgs;

(python.buildEnv.override {
 extraLibs = with pythonPackages;
 [ 
   click
 ];
}).env
